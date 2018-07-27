//
//  NSURLResponse+sk_expand.h
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLResponse (sk_expand)

/**
 给NSURLResponse 添加返回值data类型
 */
@property (nonatomic, strong) NSData *sk_responseData;

@end
