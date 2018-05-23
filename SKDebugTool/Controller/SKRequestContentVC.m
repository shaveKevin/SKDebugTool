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
    btnclose.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnclose setTitle:@"返回" forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [btnclose setTitleColor:[SKDebugTool shareInstance].mainColor forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc] initWithCustomView:btnclose];
    self.navigationItem.leftBarButtonItem = btnleft;
    
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
    self.txt.text = self.content;
    
    [self.view addSubview:self.txt];
    
    NSStringDrawingOptions option = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:13],
                                 NSParagraphStyleAttributeName : style};
    CGRect r = [self.content boundingRectWithSize:CGSizeMake(self.view.bounds.size.width, MAXFLOAT) options:option attributes:attributes context:nil];
    self.txt.contentSize = CGSizeMake(self.view.bounds.size.width, r.size.height);
}

- (void)copyAction {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [self.content copy];
    
    self.txt.text = [NSString stringWithFormat:@"%@\n\n%@",@"复制成功！",self.content];
    
    __weak typeof (self.txt) weakTxt = self.txt;
    __weak typeof (self) wSelf = self;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakTxt.text = wSelf.content;
        NSLog(@"%@",wSelf.content);
    });
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
