//
//  SKRequestDetailVC.m
//  SKDebugToolDemo
//
//  Created by shavekevin on 2018/5/23.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "SKRequestDetailVC.h"
#import "SKRequestDataSource.h"
#import "SKRequestListCell.h"
#import "SKDebugTool.h"
#import "SKRequestContentVC.h"
#import "SKRequestResponseVC.h"
@interface SKRequestDetailVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView  *tableView;

@property(nonatomic,copy) NSArray      *listData;

@property(nonatomic,copy)   NSArray      *detailTitles;

@end

@implementation SKRequestDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title  = @"详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.detailTitles = @[@"请求链接",@"请求方式",@"状态码",@"请求内容类型",@"开始时间",@"响应时间",@"请求参数",@"返回结果",@"接口名称"];
    UIButton *btnclose = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    btnclose.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnclose setTitle:@"返回" forState:UIControlStateNormal];
    [btnclose addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [btnclose setTitleColor:[SKDebugTool shareInstance].themeColor forState:UIControlStateNormal];
    UIBarButtonItem *btnleft = [[UIBarButtonItem alloc] initWithCustomView:btnclose];
    self.navigationItem.leftBarButtonItem = btnleft;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedRowHeight = 0;
    }
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]
                                ]];

}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailTitles.count;
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
    static NSString *identifer = @"httpdetailcell";
    SKRequestListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[SKRequestListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSString* value = @"";
    if (indexPath.row == 0) {
        value = self.detail.url.absoluteString;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.row == 1) {
        value = self.detail.method;
    }
    else if (indexPath.row == 2) {
        value = self.detail.statusCode;
    }
    else if (indexPath.row == 3) {
        value = self.detail.mineType;
    }
    else if (indexPath.row == 4) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        value = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:self.detail.startTime.doubleValue]];
    }
    else if (indexPath.row == 5) {
        value = self.detail.totalDuration;
    }
    else if (indexPath.row == 6) {
        if (self.detail.requestBody.length > 0) {
            value = @"点击查看";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else {
            value = @"数据为空";
        }
    }
    else if (indexPath.row == 7) {
        NSInteger lenght = self.detail.responseData.length;
        if (lenght > 0) {
            if (lenght < 1024) {
                value = [NSString stringWithFormat:@"大小：(%zdB)",lenght];
            }
            else {
                value = [NSString stringWithFormat:@"大小(%.2fKB)",1.0 * lenght / 1024];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else {
            value = @"数据为空";
        }
    }
    else if (indexPath.row == 8) {
        value = @"未知接口";
        if ([SKDebugTool shareInstance].requestListPath&&[SKDebugTool shareInstance].requestListPath.length) {
            NSString *path = [[NSBundle mainBundle] pathForResource:[SKDebugTool shareInstance].requestListPath ofType:nil];
            if (![[SKDebugTool shareInstance].requestListPath containsString:@".plist"]) {
                path = [[NSBundle mainBundle] pathForResource:[SKDebugTool shareInstance].requestListPath ofType:@"plist"];
            }
            if (path&&path.length) {
                NSDictionary *trackSetting = [NSDictionary dictionaryWithContentsOfFile:path];
                
                for (NSString *requestString in trackSetting.allKeys) {
                    if ([self.detail.url.absoluteString containsString:requestString]) {
                        value = [trackSetting valueForKey:requestString];
                        NSLog(@"接口名称为：%@",value);
                        break;
                    }
                }
            }
        }else {
            value = @"您未设置接口plist文档请设置后重试！";
        }
    }
    [cell setTitle:[self.detailTitles objectAtIndex:indexPath.row] value:value];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        SKRequestContentVC* vc = [[SKRequestContentVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.content = self.detail.url.absoluteString;
        vc.title = @"接口地址";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 6 && self.detail.requestBody.length > 0) {
        SKRequestContentVC* vc = [[SKRequestContentVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.content = self.detail.requestBody;
        vc.title = @"请求数据";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 7 && self.detail.responseData.length > 0) {
        SKRequestResponseVC* vc = [[SKRequestResponseVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.data = self.detail.responseData;
        vc.isImage = self.detail.isImage;
        vc.title = @"返回数据";
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        return;
    }
}

@end
