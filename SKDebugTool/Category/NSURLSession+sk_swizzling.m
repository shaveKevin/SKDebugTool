//
//  NSURLSession+sk_swizzling.m
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "NSURLSession+sk_swizzling.h"
#import <objc/runtime.h>
#import "NSURLSessionTask+sk_expand.h"
#import "NSURLResponse+sk_expand.h"
#import "NSURLRequest+sk_expand.h"
#import "SKDebugTool.h"
#import "SKRequestDataSource.h"

@implementation NSURLSession (sk_swizzling)
+ (void)load {
    
    Method oriMethod = class_getInstanceMethod([NSURLSession class], @selector(dataTaskWithRequest:));
    Method newMethod = class_getInstanceMethod([NSURLSession class], @selector(dataTaskWithRequest_swizzling:));
    method_exchangeImplementations(oriMethod, newMethod);
    
    const SEL selectors_data[] = {
        @selector(URLSession:dataTask:didReceiveResponse:completionHandler:),
        @selector(URLSession:dataTask:didBecomeDownloadTask:),
        @selector(URLSession:dataTask:didBecomeStreamTask:),
        @selector(URLSession:dataTask:didReceiveData:),
        @selector(URLSession:dataTask:willCacheResponse:completionHandler:)
    };
    
    const int numSelectors_data = sizeof(selectors_data) / sizeof(SEL);
    
    Class *classes = NULL;
    int numClasses = objc_getClassList(NULL, 0);
    classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    for (NSInteger classIndex = 0; classIndex < numClasses; ++classIndex) {
        Class class = classes[classIndex];
        
        unsigned int methodCount = 0;
        Method *methods = class_copyMethodList(class, &methodCount);
        BOOL matchingSelectorFound = NO;
        for (unsigned int methodIndex = 0; methodIndex < methodCount; methodIndex++) {
            for (int selectorIndex = 0; selectorIndex < numSelectors_data; ++selectorIndex) {
                if (method_getName(methods[methodIndex]) == selectors_data[selectorIndex]) {
                    [self swizzling_selectors_task:class];
                    [self swizzling_selectors_data:class];
                    matchingSelectorFound = YES;
                    break;
                }
            }
            if (matchingSelectorFound) {
                break;
            }
        }
    }
}

#pragma mark - NSURLSession task delegate with swizzling
+ (void)swizzling_selectors_task:(Class)cls {
    [self swizzling_TaskWillPerformHTTPRedirectionIntoDelegateClass:cls];
    [self swizzling_TaskDidSendBodyDataIntoDelegateClass:cls];
    [self swizzling_TaskDidReceiveChallengeIntoDelegateClass:cls];
    [self swizzling_TaskNeedNewBodyStreamIntoDelegateClass:cls];
    [self swizzling_TaskDidCompleteWithErrorIntoDelegateClass:cls];
}

+ (void)swizzling_TaskWillPerformHTTPRedirectionIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:);
    SEL swizzledSelector = @selector(URLSession_swizzling:task:willPerformHTTPRedirection:newRequest:completionHandler:);
    Protocol *protocol = @protocol(NSURLSessionTaskDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription];
}

+ (void)swizzling_TaskDidSendBodyDataIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:);
    SEL swizzledSelector = @selector(URLSession_swizzling:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:);
    Protocol *protocol = @protocol(NSURLSessionTaskDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription];
}

+ (void)swizzling_TaskDidReceiveChallengeIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession:task:didReceiveChallenge:completionHandler:);
    SEL swizzledSelector = @selector(URLSession_swizzling:task:didReceiveChallenge:completionHandler:);
    Protocol *protocol = @protocol(NSURLSessionTaskDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription];
}

+ (void)swizzling_TaskNeedNewBodyStreamIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession_swizzling:task:needNewBodyStream:);
    SEL swizzledSelector = @selector(URLSession_swizzling:task:needNewBodyStream:);
    Protocol *protocol = @protocol(NSURLSessionTaskDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription];
}

+ (void)swizzling_TaskDidCompleteWithErrorIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession:task:didCompleteWithError:);
    SEL swizzledSelector = @selector(URLSession_swizzling:task:didCompleteWithError:);
    Protocol *protocol = @protocol(NSURLSessionTaskDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription];
}

#pragma mark - NSURLSession task delegate
- (void)URLSession_swizzling:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLRequest * __nullable))completionHandler {
    [self URLSession_swizzling:session task:task willPerformHTTPRedirection:response newRequest:request completionHandler:completionHandler];
}

- (void)URLSession_swizzling:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    NSURLRequest* req = task.originalRequest;
    req.sk_requestId = [[NSUUID UUID] UUIDString];
    req.sk_startTime = @([[NSDate date] timeIntervalSince1970]);
    [self URLSession_swizzling:session task:task didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
}

- (void)URLSession_swizzling:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    [self URLSession_swizzling:session task:task didReceiveChallenge:challenge completionHandler:completionHandler];
}

- (void)URLSession_swizzling:(NSURLSession *)session task:(NSURLSessionTask *)task needNewBodyStream:(void (^)(NSInputStream * __nullable bodyStream))completionHandler {
    [self URLSession_swizzling:session task:task needNewBodyStream:completionHandler];
}

- (void)URLSession_swizzling:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    
    NSURLRequest* req = task.originalRequest;
    req.sk_requestId = [[NSUUID UUID] UUIDString];
    req.sk_startTime = @([[NSDate date] timeIntervalSince1970]);
    
    [self URLSession_swizzling:session task:task didCompleteWithError:error];
    if ([[[SKRequestDataSource shareInstance] arrRequest] containsObject:req.sk_requestId])
        return;
    BOOL canHandle = YES;
    if ([[SKDebugTool shareInstance] arrOnlyHosts].count > 0) {
        canHandle = NO;
        NSString* url = [req.URL.absoluteString lowercaseString];
        for (NSString* _url in [SKDebugTool shareInstance].arrOnlyHosts) {
            if ([url rangeOfString:[_url lowercaseString]].location != NSNotFound) {
                canHandle = YES;
                break;
            }
        }
    }
    if (!canHandle)
        return;
    
    NSURLResponse* resp = task.response;
    SKRequestDataModel* model = [[SKRequestDataModel alloc] init];
    model.requestId = req.sk_requestId;
    model.url = req.URL;
    model.method = req.HTTPMethod;
    model.mineType = resp.MIMEType;
    if (req.HTTPBody) {
        NSData* data = req.HTTPBody;
        if ([[SKDebugTool shareInstance] isHttpRequestEncrypt]) {
            if ([[SKDebugTool shareInstance] delegate] && [[SKDebugTool shareInstance].delegate respondsToSelector:@selector(decryptJson:)]) {
                data = [[SKDebugTool shareInstance].delegate decryptJson:req.HTTPBody];
            }
        }
        model.requestBody = [SKRequestDataSource prettyJSONStringFromData:data];
    }else {
        NSString *str = [NSString stringWithFormat:@"%@",req.URL];
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
                model.requestBody = [SKRequestDataSource prettyJSONStringFromData:data];
                break;
            }
        }
    }
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)resp;
    model.statusCode = [NSString stringWithFormat:@"%d",(int)httpResponse.statusCode];
    model.responseData = task.sk_responseData;
    model.isImage = [resp.MIMEType rangeOfString:@"image"].location != NSNotFound;
    NSString *absoluteString = resp.URL.absoluteString.lowercaseString;
    if ([absoluteString hasSuffix:@".jpg"] || [absoluteString hasSuffix:@".jpeg"] || [absoluteString hasSuffix:@".png"] || [absoluteString hasSuffix:@".gif"]) {
        model.isImage = YES;
    }
    model.totalDuration = [NSString stringWithFormat:@"%fs",[[NSDate date] timeIntervalSince1970] - req.sk_startTime.doubleValue];
    model.startTime = [NSString stringWithFormat:@"%fs",req.sk_startTime.doubleValue];
    [[SKRequestDataSource shareInstance] addHttpRequset:model];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyKeyReloadHttp object:nil];
}


#pragma mark - NSUrlSession data delegate with swizzling
+ (void)swizzling_selectors_data:(Class)cls {
    [self swizzling_TaskDidReceiveResponseIntoDelegateClass:cls];
    [self swizzling_TaskDidReceiveDataIntoDelegateClass:cls];
    [self swizzling_TaskDidBecomeDownloadTaskIntoDelegateClass:cls];
    [self swizzling_TaskDidBecomeStreamTaskIntoDelegateClass:cls];
    //    [self swizzling_TaskWillCacheResponseIntoDelegateClass:cls];
}

+ (void)swizzling_TaskDidReceiveResponseIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession:dataTask:didReceiveResponse:completionHandler:);
    SEL swizzledSelector = @selector(URLSession_swizzling:dataTask:didReceiveResponse:completionHandler:);
    Protocol *protocol = @protocol(NSURLSessionDataDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription];
}

+ (void)swizzling_TaskDidReceiveDataIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession:dataTask:didReceiveData:);
    SEL swizzledSelector = @selector(URLSession_swizzling:dataTask:didReceiveData:);
    Protocol *protocol = @protocol(NSURLSessionDataDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription];
}

+ (void)swizzling_TaskDidBecomeDownloadTaskIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession:dataTask:didBecomeDownloadTask:);
    SEL swizzledSelector = @selector(URLSession_swizzling:dataTask:didBecomeDownloadTask:);
    Protocol *protocol = @protocol(NSURLSessionDataDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription];
}
+ (void)swizzling_TaskDidBecomeStreamTaskIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession:dataTask:didBecomeStreamTask:);
    SEL swizzledSelector = @selector(URLSession_swizzling:dataTask:didBecomeStreamTask:);
    Protocol *protocol = @protocol(NSURLSessionDataDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription];
}

+ (void)swizzling_TaskWillCacheResponseIntoDelegateClass:(Class)cls {
    SEL selector = @selector(URLSession:dataTask:willCacheResponse:completionHandler:);
    SEL swizzledSelector = @selector(URLSession_swizzling:dataTask:willCacheResponse:completionHandler:);
    Protocol *protocol = @protocol(NSURLSessionDataDelegate);
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(protocol, selector, NO, YES);
    [self replaceImplementationOfSelector:selector withSelector:swizzledSelector forClass:cls withMethodDescription:methodDescription];
}

+ (void)replaceImplementationOfSelector:(SEL)selector withSelector:(SEL)swizzledSelector forClass:(Class)cls withMethodDescription:(struct objc_method_description)methodDescription
{
    IMP implementation = class_getMethodImplementation([self class], swizzledSelector);
    Method oldMethod = class_getInstanceMethod(cls, selector);
    if (oldMethod) {
        class_addMethod(cls, swizzledSelector, implementation, methodDescription.types);
        Method newMethod = class_getInstanceMethod(cls, swizzledSelector);
        method_exchangeImplementations(oldMethod, newMethod);
    } else {
        class_addMethod(cls, selector, implementation, methodDescription.types);
    }
}

#pragma mark - NSUrlSession delegate
- (NSURLSessionDataTask *)dataTaskWithRequest_swizzling:(NSURLRequest *)request {
    return [self dataTaskWithRequest_swizzling:request];
}

- (void)URLSession_swizzling:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    [self URLSession_swizzling:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}

- (void)URLSession_swizzling:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    if(!dataTask.sk_responseData) {
        dataTask.sk_responseData = [NSMutableData data];
        dataTask.sk_taskDataIdentify = NSStringFromClass([self class]);
    }
    if ([dataTask.sk_taskDataIdentify isEqualToString:NSStringFromClass([self class])])
        [dataTask.sk_responseData appendData:data];
    [self URLSession_swizzling:session dataTask:dataTask didReceiveData:data];
}

- (void)URLSession_swizzling:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
    [self URLSession_swizzling:session dataTask:dataTask didBecomeDownloadTask:downloadTask];
}

- (void)URLSession_swizzling:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask  API_AVAILABLE(ios(9.0)){
    [self URLSession_swizzling:session dataTask:dataTask didBecomeStreamTask:streamTask];
}

- (void)URLSession_swizzling:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * __nullable cachedResponse))completionHandler {
    [self URLSession_swizzling:session dataTask:dataTask willCacheResponse:proposedResponse completionHandler:completionHandler];
}
@end
