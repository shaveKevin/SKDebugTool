//
//  SKRequestDataSource.m
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "SKRequestDataSource.h"
#import "NSURLRequest+sk_expand.h"
#import "NSURLResponse+sk_expand.h"
#import "NSURLSessionTask+sk_expand.h"
#import "SKDebugTool.h"



@implementation SKRequestDataModel

#pragma mark - deal with response

+ (void)dealwithResponse:(NSData *)data response:(NSURLResponse *)response request:(NSURLRequest *)request {
    SKRequestDataModel* model = [[SKRequestDataModel alloc] init];
    model.requestId = request.sk_requestId;
    model.url = response.URL;
    model.mineType = response.MIMEType;
    if (request.HTTPBody) {
        NSData* data = request.HTTPBody;
        if ([[SKDebugTool shareInstance] isHttpRequestEncrypt]) {
            if ([[SKDebugTool shareInstance] delegate] && [[SKDebugTool shareInstance].delegate respondsToSelector:@selector(decryptJson:)]) {
                data = [[SKDebugTool shareInstance].delegate decryptJson:request.HTTPBody];
            }
        }
        model.requestBody = [[SKRequestDataSource prettyJSONStringFromData:data]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    model.method = httpResponse.allHeaderFields[@"Allow"];
    model.statusCode = [NSString stringWithFormat:@"%d",(int)httpResponse.statusCode];
    model.responseData = data;
    model.isImage = [response.MIMEType rangeOfString:@"image"].location != NSNotFound;
    NSString *absoluteString = response.URL.absoluteString.lowercaseString;
    if ([absoluteString hasSuffix:@".jpg"] || [absoluteString hasSuffix:@".jpeg"] || [absoluteString hasSuffix:@".png"] || [absoluteString hasSuffix:@".gif"]) {
        model.isImage = YES;
    }
    model.totalDuration = [NSString stringWithFormat:@"%fs",[[NSDate date] timeIntervalSince1970] - request.sk_startTime.doubleValue];
    model.startTime = [NSString stringWithFormat:@"%fs",request.sk_startTime.doubleValue];
    
    [[SKRequestDataSource shareInstance] addHttpRequset:model];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyKeyReloadHttp object:nil];
    });
    
}

@end

@implementation SKRequestDataSource
+ (instancetype)shareInstance {
    static SKRequestDataSource* tool;
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        tool = [[SKRequestDataSource alloc] init];
    });
    return tool;
}

- (id)init {
    self = [super init];
    if (self) {
        _httpArray = [NSMutableArray array];
        _arrRequest = [NSMutableArray array];
    }
    return self;
}

- (void)addHttpRequset:(SKRequestDataModel*)model {
    @synchronized(self.httpArray) {
        [self.httpArray insertObject:model atIndex:0];
        
    }
    @synchronized(self.arrRequest) {
        if (model.requestId&& model.requestId.length > 0) {
            [self.arrRequest addObject:model.requestId];
        }
    }
}

- (void)clear {
    @synchronized(self.httpArray) {
        [self.httpArray removeAllObjects];
    }
    @synchronized(self.arrRequest) {
        [self.arrRequest removeAllObjects];
    }
}


#pragma mark - parse
+ (NSString *)prettyJSONStringFromData:(NSData *)data
{
    NSString *prettyString = nil;
    
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    if ([NSJSONSerialization isValidJSONObject:jsonObject]) {
        prettyString = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:NULL] encoding:NSUTF8StringEncoding];
        // NSJSONSerialization escapes forward slashes. We want pretty json, so run through and unescape the slashes.
        prettyString = [prettyString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
    } else {
        prettyString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return prettyString;
}
@end
