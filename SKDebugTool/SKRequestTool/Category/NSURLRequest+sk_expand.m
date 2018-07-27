//
//  NSURLRequest+sk_expand.m
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "NSURLRequest+sk_expand.h"
#import <objc/runtime.h>
static void *SKNetworkingRequestId = &SKNetworkingRequestId;
static void *SKNetworkingRequestStartTime = &SKNetworkingRequestStartTime;

@implementation NSURLRequest (sk_expand)

- (NSString *)sk_requestId {
    return objc_getAssociatedObject(self, SKNetworkingRequestId);
}

- (void)setSk_requestId:(NSString *)sk_requestId {
    objc_setAssociatedObject(self, SKNetworkingRequestId, sk_requestId, OBJC_ASSOCIATION_COPY);
}

- (NSNumber *)sk_startTime {
    return objc_getAssociatedObject(self, SKNetworkingRequestStartTime);
}

- (void)setSk_startTime:(NSNumber *)sk_startTime {
    objc_setAssociatedObject(self, SKNetworkingRequestStartTime, sk_startTime, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
