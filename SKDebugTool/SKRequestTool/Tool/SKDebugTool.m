//
//  SKDebugTool.m
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "SKDebugTool.h"
#import <UIKit/UIKit.h>
#import "YYFPSLabel.h"
#import "SKMainDebugVC.h"
#import "SKMemoryHelper.h"
#import "SKRequestURLProtocol.h"
#import "SKRequestVC.h"
#import "SKAirSandboxVC.h"
#define KB    (1024)
#define MB    (KB * 1024)
#define GB    (MB * 1024)

@interface SKDebugWindow : UIWindow

@end

@implementation SKDebugWindow

- (void)becomeKeyWindow {
    //
    [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
}

@end


@interface SKDebugTool ()

@property (nonatomic, strong) SKMainDebugVC    *debugVC;

@property (nonatomic, strong) SKDebugWindow    *debugWin;
@property (nonatomic, strong) UIButton          *debugBtn;
@property (nonatomic, strong) NSTimer           *debugTimer;
@property (nonatomic, strong) YYFPSLabel         *fpsLabel;
@property (nonatomic,assign) CGFloat sBallHideWidth;
@property (nonatomic,assign) CGFloat sBallWidth;

@end
@implementation SKDebugTool
+ (instancetype)shareInstance {
    static SKDebugTool* tool;
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        tool = [[SKDebugTool alloc] init];
    });
    return tool;
}

- (id)init {
    self = [super init];
    if (self) {
        self.sBallHideWidth = 10;
        self.sBallWidth = 70;
        self.debugWin = [[SKDebugWindow alloc] initWithFrame:CGRectMake(-self.sBallHideWidth, CGRectGetHeight([UIScreen mainScreen].bounds)/3.0, 70, 70)];
        self.debugWin.backgroundColor = [UIColor clearColor];
        self.debugWin.alpha = 0.9;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGR:)];
        [self.debugWin addGestureRecognizer:pan];
        if (!self.themeColor) {
            self.themeColor = [UIColor greenColor];
        }
        if (!self.requestFailedColor) {
            self.requestFailedColor = [UIColor redColor];
        }
    }
    return self;
}
#pragma mark - Action
- (void)panGR:(UIPanGestureRecognizer *)gr {
    CGPoint panPoint = [gr locationInView:[[UIApplication sharedApplication] keyWindow]];
    if (gr.state == UIGestureRecognizerStateBegan)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resignActive) object:nil];
        [self becomeActive];
    } else if (gr.state == UIGestureRecognizerStateChanged) {
        [self changeSBallViewFrameWithPoint:panPoint];
    } else if (gr.state == UIGestureRecognizerStateEnded || gr.state == UIGestureRecognizerStateCancelled || gr.state == UIGestureRecognizerStateFailed) {
        [self resignActive];
    }
}
- (void)resignActive {
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.debugWin.alpha = 0.9;
        // Calculate End Point
        CGFloat x = self.debugWin.center.x;
        CGFloat y = self.debugWin.center.y;
        CGFloat x1 = CGRectGetWidth([UIScreen mainScreen].bounds) / 2.0;
        CGFloat y1 = CGRectGetHeight([UIScreen mainScreen].bounds) / 2.0;
        
        CGFloat distanceX = x1 > x ? x : CGRectGetWidth([UIScreen mainScreen].bounds) - x;
        CGFloat distanceY = y1 > y ? y : CGRectGetHeight([UIScreen mainScreen].bounds) - y;
        CGPoint endPoint = CGPointZero;
        
        if (distanceX <= distanceY) {
            // animation to left or right
            endPoint.y = y;
            if (x1 < x) {
                // to right
                endPoint.x = CGRectGetWidth([UIScreen mainScreen].bounds) - self.debugWin.bounds.size.width / 2.0 + self.sBallHideWidth;
            } else {
                // to left
                endPoint.x = self.debugWin.bounds.size.width / 2.0 - self.sBallHideWidth;
            }
        } else {
            // animation to top or bottom
            endPoint.x = x;
            if (y1 < y) {
                // to bottom
                endPoint.y = CGRectGetHeight([UIScreen mainScreen].bounds) - self.debugWin.bounds.size.height / 2.0 + self.sBallHideWidth;
            } else {
                // to top
                endPoint.y = self.debugWin.bounds.size.height / 2.0 - self.sBallHideWidth;
            }
        }
        self.debugWin.center = endPoint;
        
        CGFloat horizontalPer = x1 < x ? 0.15 : 0.85;
        CGFloat verticalPer = endPoint.y > self.sBallWidth ? 0.15 : 0.85;
        CGPoint fpsCenter = CGPointMake(self.sBallWidth * horizontalPer + self.debugWin.bounds.origin.x, self.sBallWidth * verticalPer + self.debugWin.bounds.origin.y);
        
        self.fpsLabel.center = fpsCenter;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)becomeActive {
    self.debugWin.alpha = 0.9;
}
- (void)changeSBallViewFrameWithPoint:(CGPoint)point {
    if (point.x > CGRectGetWidth([UIScreen mainScreen].bounds)) {
        point.x = CGRectGetHeight([UIScreen mainScreen].bounds);
    } else if (point.x < 0) {
        point.x = 0;
    }
    if (point.y > CGRectGetHeight([UIScreen mainScreen].bounds)) {
        point.y = CGRectGetHeight([UIScreen mainScreen].bounds);
    } else if (point.y < 0) {
        point.y = 0;
    }
    self.debugWin.center = CGPointMake(point.x, point.y);
}
- (void)enableDebugMode {
    [NSURLProtocol registerClass:[SKRequestURLProtocol class]];
//    [[SKCrashHelper sharedInstance] install];
    __weak typeof (self) wSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wSelf showOnStatusBar];
    });
}

- (void)showOnStatusBar {
    self.debugWin.windowLevel = UIWindowLevelStatusBar+1;
    self.debugBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    self.debugWin.hidden = NO;
    self.debugWin.alpha = 0.9;
    
    [self.debugBtn setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]];
    self.debugBtn.layer.borderWidth = 2;
    self.debugBtn.layer.cornerRadius = 35;
    self.debugBtn.layer.masksToBounds = YES;
    self.debugBtn.layer.borderColor = [UIColor greenColor].CGColor;
    self.debugBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.debugBtn setTitle:@"开始监测" forState:UIControlStateNormal];
    self.debugBtn.titleLabel.numberOfLines = 0;
    [self.debugBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.debugBtn addTarget:self action:@selector(showDebug) forControlEvents:UIControlEventTouchUpInside];
    [self.debugWin addSubview:self.debugBtn];
    
    self.fpsLabel = [[YYFPSLabel alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.fpsLabel.center = CGPointMake(_sBallWidth*0.85+self.debugWin.bounds.origin.x, _sBallWidth*0.15+self.debugWin.bounds.origin.y);
    self.fpsLabel.backgroundColor = [UIColor greenColor];
    self.fpsLabel.font = [UIFont systemFontOfSize:12];
    self.fpsLabel.textColor = [UIColor whiteColor];
    self.fpsLabel.textAlignment = NSTextAlignmentCenter;
    self.fpsLabel.layer.cornerRadius = 10;
    self.fpsLabel.layer.masksToBounds = YES;
    self.fpsLabel.text = @"60";
    [self.debugWin addSubview:self.fpsLabel];
    
    self.debugTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMonitor) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.debugTimer forMode:NSDefaultRunLoopMode];
}

- (void)showDebug {
    if (!self.debugVC) {
        self.debugVC = [[SKMainDebugVC alloc] init];
        UINavigationController* requestNav = [[UINavigationController alloc] initWithRootViewController:[SKRequestVC new]];
        [requestNav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:self.themeColor}];
        requestNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"请求" image:nil selectedImage:nil];
        [requestNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:25]} forState:UIControlStateNormal];
        [requestNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:self.themeColor} forState:UIControlStateSelected];
        
        
        UINavigationController* sandboxtNav = [[UINavigationController alloc] initWithRootViewController:[SKAirSandboxVC new]];
        [sandboxtNav.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:21],NSForegroundColorAttributeName:self.themeColor}];
        sandboxtNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"沙盒" image:nil selectedImage:nil];
        [sandboxtNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor],NSFontAttributeName:[UIFont systemFontOfSize:25]} forState:UIControlStateNormal];
        [sandboxtNav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:self.themeColor} forState:UIControlStateSelected];
        
        self.debugVC.viewControllers = @[requestNav,sandboxtNav];
        UIViewController* vc = [[[UIApplication sharedApplication].delegate window] rootViewController];
        UIViewController* vc2 = vc.presentedViewController;
        [vc2?:vc presentViewController:self.debugVC animated:YES completion:nil];
    }
    else {
        [self.debugVC dismissViewControllerAnimated:YES completion:nil];
        self.debugVC = nil;
    }
}

- (void)timerMonitor {
    unsigned long long used = [SKMemoryHelper bytesOfUsedMemory];
    NSString* text = [self number2String:used];
    [self.debugBtn setTitle:[NSString stringWithFormat:@"Debug\n(%@)",text] forState:UIControlStateNormal];
}

- (NSString* )number2String:(int64_t)n
{
    if ( n < KB )
    {
        return [NSString stringWithFormat:@"%lldB", n];
    }
    else if ( n < MB )
    {
        return [NSString stringWithFormat:@"%.1fK", (float)n / (float)KB];
    }
    else if ( n < GB )
    {
        return [NSString stringWithFormat:@"%.1fM", (float)n / (float)MB];
    }
    else
    {
        return [NSString stringWithFormat:@"%.1fG", (float)n / (float)GB];
    }
}

@end
