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
    btnclose.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnclose setTitle:@"返回" forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [btnclose setTitleColor:[SKDebugTool shareInstance].mainColor forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc] initWithCustomView:btnclose];
    self.navigationItem.leftBarButtonItem = btnleft;
    if (@available(iOS 11.0, *)) {
        [self.txt setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    if (!self.isImage) {
        UIButton *btnCopy = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        btnCopy.titleLabel.font = [UIFont systemFontOfSize:13];
        [btnCopy setTitle:@"拷贝" forState:UIControlStateNormal];
        [btnCopy addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
        [btnCopy setTitleColor:[SKDebugTool shareInstance].mainColor forState:UIControlStateNormal];
        UIBarButtonItem *btnright = [[UIBarButtonItem alloc] initWithCustomView:btnCopy];
        self.navigationItem.rightBarButtonItem = btnright;
        
        self.txt = [[UITextView alloc] initWithFrame:self.view.bounds];
        [self.txt setEditable:NO];
        self.txt.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
        self.txt.font = [UIFont systemFontOfSize:13];
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
        
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:13],
                                     NSParagraphStyleAttributeName : style};
        CGRect r = [self.txt.text boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, MAXFLOAT) options:option attributes:attributes context:nil];
        self.txt.contentSize = CGSizeMake(self.view.bounds.size.width, r.size.height);
        [self.view addSubview:self.txt];
    }
    else {
        self.img = [[UIImageView alloc] initWithFrame:self.view.bounds];
        self.img.contentMode = UIViewContentModeScaleAspectFit;
        self.img.image = [UIImage imageWithData:self.data];
        [self.view addSubview:self.img];
    }
}

- (void)copyAction {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self.txt.text copy];
    
    self.txt.text = [NSString stringWithFormat:@"%@\n\n%@",@"复制成功！",self.txt.text];
    
    __weak typeof (self.txt) weakTxt = self.txt;
    __weak typeof (self) wSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakTxt.text = wSelf.contentString;
    });
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
