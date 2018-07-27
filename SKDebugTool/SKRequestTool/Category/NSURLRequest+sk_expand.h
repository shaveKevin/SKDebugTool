//
//  NSURLRequest+sk_expand.h
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 对NSURLRequest 添加category
 */
@interface NSURLRequest (sk_expand)
/**
 请求的ID
 */
@property (nonatomic, copy) NSString *sk_requestId;
/**
 请求开始时间
 */
@property (nonatomic, strong) NSNumber *sk_startTime;

@end
