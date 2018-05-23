//
//  ViewController.m
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "ViewController.h"
#import "SKStaticNewsList_request.h"
#import "SKStaticNewsListModel.h"
#import "SKStaticNewsListResult.h"
#import "SKNetworkBatchRequest.h"
#import <Masonry.h>
@interface ViewController ()
/**
 *  @brief 请求1 .
 */
@property (nonatomic, strong) SKStaticNewsList_request *newsListGroupRequest;

/**
 *  @brief 请求2 .
 */
@property (nonatomic, strong) SKStaticNewsList_request *newsListRequest;

@property (nonatomic, assign) NSInteger pageFrom;
/**
 *  @brief SKStaticNewsListModel .
 */
@property (nonatomic, strong) NSMutableArray <SKStaticNewsListModel *> *arrayModelList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initData];
    [self request];
}
#pragma mark  - 初始化
- (void)initData {
    self.view.backgroundColor = [UIColor whiteColor];
    _pageFrom = 0;
    self.arrayModelList = [NSMutableArray array];
}

#pragma mark - 网络请求
//  请求
- (void)request {
    
    ///  异步
    
    [self getNewsListData];
    
}

/**
 *  @brief 新的网络请求
 */
- (void)getNewsListData {
    if (_newsListRequest) {
        [_newsListRequest stop];
        _newsListRequest = nil;
    }
    _newsListRequest = [[SKStaticNewsList_request alloc]init];
    _newsListRequest.firstResult = [NSString stringWithFormat:@"%ld",(long)_pageFrom];
    _newsListRequest.type = @"科技";
    _newsListRequest.uid = @"23080";
    [_newsListRequest startCompletionBlockWithProgress:^(NSProgress *progress) {
        //
    } success:^(SKNetworkBaseRequest *request) {
        //
        SKStaticNewsList_request *reviewRequest = (SKStaticNewsList_request*)request;
        
        SKStaticNewsListResult *result = (SKStaticNewsListResult *)reviewRequest.result;
        [self dealWithData:result];
    } failure:^(SKNetworkBaseRequest *request) {
        
    }];
}
/**
 *  @brief 新的网络请求 处理逻辑放在VC(其实还可以再写一层，把不相关的丢到vm层，缩减vc的大小)
 *
 *  @param result 新的网络请求
 */
- (void)dealWithData:(SKStaticNewsListResult *)result {
    
    [self.arrayModelList addObjectsFromArray:result.arrayList];
    NSLog(@"%ld",self.arrayModelList.count);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
