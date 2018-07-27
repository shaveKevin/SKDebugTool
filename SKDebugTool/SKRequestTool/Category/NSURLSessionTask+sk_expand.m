//
//  NSURLSessionTask+sk_expand.m
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "NSURLSessionTask+sk_expand.h"
#import <objc/runtime.h>
static void *SKNSURLSessionTaskIdentifier = &SKNSURLSessionTaskIdentifier;
static void *SKNSURLSessionResponseData = &SKNSURLSessionResponseData;

@implementation NSURLSessionTask (sk_expand)

- (NSString *)sk_taskDataIdentify {
    return objc_getAssociatedObject(self, SKNSURLSessionTaskIdentifier);
}

- (void)setSk_taskDataIdentify:(NSString *)sk_taskDataIdentify {
    objc_setAssociatedObject(self, SKNSURLSessionTaskIdentifier, sk_taskDataIdentify, OBJC_ASSOCIATION_COPY);
}
- (NSMutableData *)sk_responseData {
    return objc_getAssociatedObject(self, SKNSURLSessionResponseData);
}
- (void)setSk_responseData:(NSMutableData *)sk_responseData {
    objc_setAssociatedObject(self, SKNSURLSessionResponseData, sk_responseData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
