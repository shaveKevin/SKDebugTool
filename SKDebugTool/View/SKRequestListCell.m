

//
//  SKRequestListCell.m
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "SKRequestListCell.h"
#import "SKDebugTool.h"


@interface SKRequestListCell()

@property (nonatomic, strong) UILabel *lblTitle;

@property (nonatomic, strong) UILabel *lblValue;

@end

@implementation SKRequestListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width - 40, 20)];
        self.lblTitle.textColor = [SKDebugTool shareInstance].themeColor;
        self.lblTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:19];
        [self addSubview:self.lblTitle];
        
        self.lblValue = [[UILabel alloc] initWithFrame:CGRectMake(20, 35, [UIScreen mainScreen].bounds.size.width - 40, 16)];
        self.lblValue.textColor = [UIColor lightGrayColor];
        self.lblValue.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.lblValue];
    }
    return self;
}

- (void)setTitle:(NSString*)title value:(NSString*)value {
    self.lblTitle.text = title;
    self.lblValue.text = value;
}
@end
