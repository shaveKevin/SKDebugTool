//
//  SKRequestDataSource.h
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SKRequestDataModel:NSObject

@property (nonatomic,copy) NSString  *requestId;

@property (nonatomic,copy) NSURL     *url;

@property (nonatomic,copy) NSString  *method;

@property (nonatomic,copy) NSString  *requestBody;

@property (nonatomic,copy) NSString  *statusCode;

@property (nonatomic,copy) NSData    *responseData;

@property (nonatomic,assign) BOOL    isImage;

@property (nonatomic,copy) NSString  *mineType;

@property (nonatomic,strong) NSString  *startTime;

@property (nonatomic,copy) NSString  *totalDuration;


/**
 处理请求后的数据

 @param data data
 @param response response
 @param request request
 */
+ (void)dealwithResponse:(NSData *)data response:(NSURLResponse*)response request:(NSURLRequest *)request;

@end

@interface SKRequestDataSource : NSObject

@property (nonatomic,strong,readonly) NSMutableArray    *httpArray;

@property (nonatomic,strong,readonly) NSMutableArray    *arrRequest;

+ (instancetype)shareInstance;
/**
 *  记录http请求
 *
 *  @param model http
 */
- (void)addHttpRequset:(SKRequestDataModel*)model;
/**
 *  清空请求
 */
- (void)clear;
/**
 解析

 @param data 数据解析
 @return jsonString
 */
+ (NSString *)prettyJSONStringFromData:(NSData *)data;

@end
