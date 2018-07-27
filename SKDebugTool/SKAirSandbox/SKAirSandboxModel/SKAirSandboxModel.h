//
//  AirSandboxModel.h
//  AirSandbox
//
//  Created by shavekevin on 2018/7/27.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,SKAirSandboxFileItemType) {
    
    eSKFileItemUp = 1,
    
    eSKFileItemDirectory = 2,
    
    eSKFileItemFile = 3,
};
@interface SKAirSandboxModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) SKAirSandboxFileItemType type;

@end
