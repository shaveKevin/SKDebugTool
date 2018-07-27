//
//  AirSandboxCell.m
//  AirSandbox
//
//  Created by shavekevin on 2018/7/27.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "SKAirSandboxCell.h"
#import "SKAirSandboxModel.h"

@interface SKAirSandboxCell ()

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *lineView;


@end

@implementation SKAirSandboxCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self setupLayout];
        [self.contentLabel setFrame:CGRectMake(10, 30, CGRectGetWidth([UIScreen mainScreen].bounds)- 40, 15)];
        self.lineView.frame = CGRectMake(10, 47, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 1);
    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)renderCellWithItem:(SKAirSandboxModel *)item {
    
    [self.contentLabel setText:item.name];
}
#pragma mark -layout

- (void)setupLayout{
    
    [self.contentView addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.contentLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
                                ]];
    
    [self.contentView addConstraints:@[
                                       [NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                       [NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
                                       [NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
                                       [NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                                       [NSLayoutConstraint constraintWithItem:self.lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1.0 constant:1],
                                       ]];
      
}
#pragma mark - lazyloading
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.backgroundColor = [UIColor whiteColor];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.preferredMaxLayoutWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
        [self.contentView addSubview:_contentLabel];
    }
    return _contentLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_lineView];
    }
    return _lineView;
}
@end
