//
//  SKRequestContentVC.m
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "SKRequestContentVC.h"
#import "SKDebugTool.h"

@interface SKRequestContentVC ()

@property (nonatomic, strong)UITextView *txt;

@end

@implementation SKRequestContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btnclose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnclose.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnclose setTitle:@"返回" forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [btnclose setTitleColor:[SKDebugTool shareInstance].themeColor forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc] initWithCustomView:btnclose];
    self.navigationItem.leftBarButtonItem = btnleft;
    
    UIButton *btnCopy = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnCopy.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnCopy setTitle:@"拷贝" forState:UIControlStateNormal];
    [btnCopy addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    [btnCopy setTitleColor:[SKDebugTool shareInstance].themeColor forState:UIControlStateNormal];
    UIBarButtonItem *btnright = [[UIBarButtonItem alloc] initWithCustomView:btnCopy];
    self.navigationItem.rightBarButtonItem = btnright;
  
    self.txt = [[UITextView alloc] initWithFrame:self.view.bounds];
    if (@available(iOS 11.0, *)) {
        [self.txt setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
    }
    [self.txt setEditable:NO];
    self.txt.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    self.txt.font = [UIFont systemFontOfSize:15];
    self.txt.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.txt.text = self.content;
    [self.view addSubview:self.txt];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.txt attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.txt attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.txt attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.txt attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]
                                ]];
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName : style};
    CGRect r = [self.content boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, MAXFLOAT) options:option attributes:attributes context:nil];
    self.txt.contentSize = CGSizeMake(self.view.bounds.size.width, r.size.height);
}

- (void)copyAction {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self.content copy];

    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"复制成功！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"浏览器打开", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.content]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.content] options:nil completionHandler:^(BOOL success) {
                }];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
