//
//  SKRequestVC.m
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "SKRequestVC.h"
#import "SKRequestDataSource.h"
#import "SKDebugTool.h"
#import "SKRequestListCell.h"
#import "SKRequestDetailVC.h"

@interface SKRequestVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView  *tableView;
@property(nonatomic,strong)NSMutableArray      *listData;
@end

@implementation SKRequestVC

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"请求"];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btnclose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnclose.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnclose setTitle:@"关闭" forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(dismissViewController) forControlEvents:UIControlEventTouchUpInside];
    [btnclose setTitleColor:[SKDebugTool shareInstance].mainColor forState:UIControlStateNormal];
    
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc] initWithCustomView:btnclose];
    self.navigationItem.leftBarButtonItem = btnleft;
    
    UIButton *btnclear = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnclear.titleLabel.font = [UIFont systemFontOfSize:13];
    [btnclear setTitle:@"清空" forState:UIControlStateNormal];
    [btnclear addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
    [btnclear setTitleColor:[SKDebugTool shareInstance].mainColor forState:UIControlStateNormal];
    
    UIBarButtonItem *btnright = [[UIBarButtonItem alloc] initWithCustomView:btnclear];
    self.navigationItem.rightBarButtonItem = btnright;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.frame = CGRectMake(0, 64, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)-64-49);
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedRowHeight = 0;
    }
    [self reloadHttp];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadHttp) name:kNotifyKeyReloadHttp object:nil];
}

- (void)dismissViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clearAction {
    [[SKRequestDataSource shareInstance] clear];
    self.listData = nil;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)reloadHttp {
    if ([[SKRequestDataSource shareInstance] httpArray]&&[[SKRequestDataSource shareInstance] httpArray].count) {
        self.listData = [[[SKRequestDataSource shareInstance] httpArray] copy];
    }else {
        self.listData = nil;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"httpcell";
    SKRequestListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[SKRequestListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    SKRequestDataModel* model = [self.listData objectAtIndex:indexPath.row];
    [cell setTitle:model.url.host value:model.url.path];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SKRequestDataModel* model = [self.listData objectAtIndex:indexPath.row];
    SKRequestDetailVC* vc = [[SKRequestDetailVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.detail = model;
    [self.navigationController pushViewController:vc animated:YES];
}
- (NSMutableArray *)listData {
    if (!_listData) {
        _listData = [NSMutableArray array];
    }
    return _listData;
}

@end
