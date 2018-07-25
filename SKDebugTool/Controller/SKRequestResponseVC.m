//
//  SKRequestResponseVC.m
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "SKRequestResponseVC.h"
#import "SKDebugTool.h"
#import "SKRequestDataSource.h"

@interface SKRequestResponseVC ()

@property (nonatomic, strong) NSString*contentString;

@property (nonatomic, strong) UITextView   *txt;

@property (nonatomic, strong) UIImageView   *img;

@end

@implementation SKRequestResponseVC

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
  
    if (!self.isImage) {
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
        NSData* contentdata = self.data;
        if ([[SKDebugTool shareInstance] isHttpResponseEncrypt]) {
            if ([[SKDebugTool shareInstance] delegate] && [[SKDebugTool shareInstance].delegate respondsToSelector:@selector(decryptJson:)]) {
                contentdata = [[SKDebugTool shareInstance].delegate decryptJson:self.data];
            }
        }
        self.txt.text = [SKRequestDataSource prettyJSONStringFromData:contentdata];;
        _contentString = self.txt.text;
        
        NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [style setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15],
                                     NSParagraphStyleAttributeName : style};
        CGRect r = [self.txt.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, MAXFLOAT) options:option attributes:attributes context:nil];
        self.txt.contentSize = CGSizeMake(self.view.bounds.size.width, r.size.height);
        [self.view addSubview:self.txt];
        [self.view addConstraints:@[
                                    [NSLayoutConstraint constraintWithItem:self.txt attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                    [NSLayoutConstraint constraintWithItem:self.txt attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
                                    [NSLayoutConstraint constraintWithItem:self.txt attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
                                    [NSLayoutConstraint constraintWithItem:self.txt attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]
                                    ]];
    }
    else {
        self.img = [[UIImageView alloc] initWithFrame:self.view.bounds];
        self.img.contentMode = UIViewContentModeScaleAspectFit;
        self.img.image = [UIImage imageWithData:self.data];
        [self.view addSubview:self.img];
        [self.view addConstraints:@[
                                    [NSLayoutConstraint constraintWithItem:self.img attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                    [NSLayoutConstraint constraintWithItem:self.img attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
                                    [NSLayoutConstraint constraintWithItem:self.img attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
                                    [NSLayoutConstraint constraintWithItem:self.img attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]
                                    ]];
    }

}

- (void)copyAction {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self.txt.text copy];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"复制成功！" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)backAction {
   
    [self.navigationController popViewControllerAnimated:YES];
}


@end
