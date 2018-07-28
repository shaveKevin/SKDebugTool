//
//  NSURLSessionConfiguration+sk_swizzling.m
//  AFNetworking
//
//  Created by shavekevin on 2018/7/28.
//

#import "NSURLSessionConfiguration+sk_swizzling.h"
#import "SKRequestURLProtocol.h"
#import <objc/runtime.h>

@implementation NSURLSessionConfiguration (sk_swizzling)
+ (void)load {
    Method method1 = class_getClassMethod([NSURLSessionConfiguration class], @selector(defaultSessionConfiguration));
    Method method2 = class_getClassMethod([NSURLSessionConfiguration class], @selector(sk_defaultSessionConfiguration));
    method_exchangeImplementations(method1, method2);
    
    Method method3 = class_getClassMethod([NSURLSessionConfiguration class], @selector(ephemeralSessionConfiguration));
    Method method4 = class_getClassMethod([NSURLSessionConfiguration class], @selector(sk_ephemeralSessionConfiguration));
    method_exchangeImplementations(method3, method4);
}

+ (NSURLSessionConfiguration *)sk_defaultSessionConfiguration {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration sk_defaultSessionConfiguration];

    NSMutableArray *protocols = [[NSMutableArray alloc] initWithArray:config.protocolClasses];
    if (![protocols containsObject:[SKRequestURLProtocol class]]) {
        [protocols insertObject:[SKRequestURLProtocol class] atIndex:0];
    }
    config.protocolClasses = protocols;
    return config;
}

+ (NSURLSessionConfiguration *)sk_ephemeralSessionConfiguration {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration sk_ephemeralSessionConfiguration];
    NSMutableArray *protocols = [[NSMutableArray alloc] init];
    [protocols addObjectsFromArray:config.protocolClasses];
    if (![protocols containsObject:[SKRequestURLProtocol class]]) {
        [protocols insertObject:[SKRequestURLProtocol class] atIndex:0];
    }
    config.protocolClasses = protocols;
    return config;
}
@end
