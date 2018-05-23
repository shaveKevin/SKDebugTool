//
//  NSURLSessionTask+sk_expand.h
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLSessionTask (sk_expand)

/**
 设置taskData的标识
 */
@property (nonatomic,copy) NSString *sk_taskDataIdentify;

/**
 设置taskData的返回data
 */
@property (nonatomic, strong) NSMutableData *sk_responseData;

@end
