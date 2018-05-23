//
//  SKDebugTool.h
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kNotifyKeyReloadHttp    @"kNotifyKeyReloadHttp"

@protocol SKDebugDelegate <NSObject>


- (NSData*)decryptJson:(NSData*)data;

@end

@interface SKDebugTool : NSObject

/**
 *  主色调
 */
@property (nonatomic, copy)     UIColor     *mainColor;

/**
 *  设置代理
 */
@property (nonatomic, weak) id<SKDebugDelegate> delegate;

/**
 *  http请求数据是否加密，默认不加密
 */
@property (nonatomic, assign)   BOOL        isHttpRequestEncrypt;

/**
 *  http响应数据是否加密，默认不加密
 */
@property (nonatomic, assign)   BOOL        isHttpResponseEncrypt;

/**
 *  日志最大数量，默认50条
 */
@property (nonatomic, assign)   int         maxLogsCount;

/**
 *  设置只抓取的域名，忽略大小写，默认抓取所有
 */
@property (nonatomic, strong)   NSArray     *arrOnlyHosts;
/**
 *  设置存储接口名称的plist(可为空)
 */
@property (nonatomic, copy) NSString *requestListPath;

+ (instancetype)shareInstance;
/**
 *  启用
 */
- (void)enableDebugMode;

@end
