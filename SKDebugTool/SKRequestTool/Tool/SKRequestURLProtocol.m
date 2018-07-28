//
//  SKRequestURLProtocol.m
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "SKRequestURLProtocol.h"
#import "SKRequestDataSource.h"
#import "SKDebugTool.h"

static NSString *const myProtocolKey = @"SKRequestURLProtocol";

@interface SKRequestURLProtocol ()<NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;

@property (nonatomic, strong) NSURLResponse *response;

@property (nonatomic, strong) NSMutableData *data;

@property (nonatomic, strong) NSError *error;

@property (nonatomic, assign) NSTimeInterval  startTime;

@end

@implementation SKRequestURLProtocol
#pragma mark - protocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    if (![request.URL.scheme isEqualToString:@"http"] &&
        ![request.URL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    
    if ([NSURLProtocol propertyForKey:myProtocolKey inRequest:request] ) {
        return NO;
    }
    
    if ([[SKDebugTool shareInstance] arrOnlyHosts].count > 0) {
        NSString* url = [request.URL.absoluteString lowercaseString];
        for (NSString* _url in [SKDebugTool shareInstance].arrOnlyHosts) {
            if ([url rangeOfString:[_url lowercaseString]].location != NSNotFound)
                return YES;
        }
        return NO;
    }
    
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    [NSURLProtocol setProperty:@YES forKey:myProtocolKey inRequest:mutableReqeust];
    return [mutableReqeust copy];
}

- (void)startLoading {
    self.data = [NSMutableData data];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.connection = [[NSURLConnection alloc] initWithRequest:[[self class] canonicalRequestForRequest:self.request] delegate:self startImmediately:YES];
#pragma clang diagnostic pop
    self.startTime = [[NSDate date] timeIntervalSince1970];
    
}

- (void)stopLoading {
    [self.connection cancel];
    SKRequestDataModel* model = [[SKRequestDataModel alloc] init];
    model.url = self.request.URL;
    model.method = self.request.HTTPMethod;
    model.mineType = self.response.MIMEType;
    if (self.request.HTTPBody) {
        NSData* data = self.request.HTTPBody;
        if ([[SKDebugTool shareInstance] isHttpRequestEncrypt]) {
            if ([[SKDebugTool shareInstance] delegate] && [[SKDebugTool shareInstance].delegate respondsToSelector:@selector(decryptJson:)]) {
                data = [[SKDebugTool shareInstance].delegate decryptJson:self.request.HTTPBody];
            }
        }
        model.requestBody = [[SKRequestDataSource prettyJSONStringFromData:data]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }else {
        NSString *str = [NSString stringWithFormat:@"%@",self.request.URL];
        
        for (NSString *specialHeader  in [SKDebugTool shareInstance].specialHeaders) {
            
            if ([str containsString:specialHeader]) {
                NSData* data = nil;
                NSRange range = [str rangeOfString:specialHeader];
                NSString *substring = [str substringFromIndex:range.location+range.length];
                data = [substring dataUsingEncoding:NSUTF8StringEncoding];
                if ([[SKDebugTool shareInstance] isHttpRequestEncrypt]) {
                    if ([[SKDebugTool shareInstance] delegate] && [[SKDebugTool shareInstance].delegate respondsToSelector:@selector(decryptJson:)]) {
                        data = [[SKDebugTool shareInstance].delegate decryptJson:data];
                    }
                }
                model.requestBody = [[SKRequestDataSource prettyJSONStringFromData:data]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                break;
            }
        }
    }
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)self.response;
    model.statusCode = [NSString stringWithFormat:@"%d",(int)httpResponse.statusCode];
    model.responseData = self.data;
    model.isImage = [self.response.MIMEType rangeOfString:@"image"].location != NSNotFound;
    NSString *absoluteString = self.request.URL.absoluteString.lowercaseString;
    if ([absoluteString containsString:@".jpg"] || [absoluteString containsString:@".jpeg"] || [absoluteString containsString:@".png"] || [absoluteString containsString:@".gif"]) {
        model.isImage = YES;
    }
    model.totalDuration = [NSString stringWithFormat:@"%fs",[[NSDate date] timeIntervalSince1970] - self.startTime];
    model.startTime = [NSString stringWithFormat:@"%fs",self.startTime];
    [[SKRequestDataSource shareInstance] addHttpRequset:model];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyKeyReloadHttp object:nil];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[self client] URLProtocol:self didFailWithError:error];
    self.error = error;
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection {
    return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [[self client] URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

- (void)connection:(NSURLConnection *)connection didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    [[self client] URLProtocol:self didCancelAuthenticationChallenge:challenge];
}

#pragma mark - NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    self.response = response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self client] URLProtocol:self didLoadData:data];
    [self.data appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return cachedResponse;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [[self client] URLProtocolDidFinishLoading:self];
}
@end
