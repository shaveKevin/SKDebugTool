//
//  NSURLResponse+sk_expand.m
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "NSURLResponse+sk_expand.h"
#import <objc/runtime.h>
static void *SKNSURLResponseData = &SKNSURLResponseData;

@implementation NSURLResponse (sk_expand)

- (NSData *)sk_responseData {
    return objc_getAssociatedObject(self, SKNSURLResponseData);
}

- (void)setSk_responseData:(NSData *)sk_responseData {
    objc_setAssociatedObject(self, SKNSURLResponseData, sk_responseData, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
