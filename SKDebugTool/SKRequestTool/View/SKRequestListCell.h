//
//  SKRequestListCell.h
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SKRequestDataModel;
@interface SKRequestListCell : UITableViewCell

- (void)setTitle:(NSString*)title value:(NSString*)value;

@property (nonatomic, strong) SKRequestDataModel *model;

@end
