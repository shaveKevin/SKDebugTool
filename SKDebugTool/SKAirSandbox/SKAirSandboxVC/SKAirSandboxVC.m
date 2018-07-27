//
//  SKAirSandboxVC.m
//  Pods-AirSandboxDemo
//
//  Created by shavekevin on 2018/7/27.
//

#import "SKAirSandboxVC.h"
#import "SKAirSandboxCell.h"
#import "SKAirSandboxModel.h"
static NSString *const  cellIdentifier = @"AirSandboxCellIdentifier";

@interface SKAirSandboxVC ()
<UITableViewDataSource,
UITableViewDelegate>

@property(nonatomic,strong) UITableView  *tableView;

@property (nonatomic, copy) NSArray *items;

@property (nonatomic, copy) NSString *rootPath;

@end

@implementation SKAirSandboxVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"沙盒"];
    [self setupData];
    [self setupUI];
}
- (void)setupData{
    _items = @[];
    _rootPath = NSHomeDirectory();
}

- (void)setupUI{
    
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.estimatedRowHeight = 0;
    }
    [self.view addSubview:self.tableView];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]
                                ]];
    
    [self loadPath:nil];

}
- (void)loadPath:(NSString*)filePath {
    
    NSMutableArray* files = @[].mutableCopy;
    NSFileManager* fileManager= [NSFileManager defaultManager];
    NSString* targetPath = filePath;
    if (targetPath.length == 0 || [targetPath isEqualToString:_rootPath]) {
        targetPath = _rootPath;
    } else {
        SKAirSandboxModel* file = [SKAirSandboxModel new];
        file.name = @"🔙..";
        file.type = eSKFileItemUp;
        file.path = filePath;
        [files addObject:file];
    }
    NSError* err = nil;
    NSArray* paths = [fileManager contentsOfDirectoryAtPath:targetPath error:&err];
    for (NSString* path in paths) {
        if ([[path lastPathComponent] hasPrefix:@"."]) {
            continue;
        }
        BOOL isDir = false;
        NSString* fullPath = [targetPath stringByAppendingPathComponent:path];
        [fileManager fileExistsAtPath:fullPath isDirectory:&isDir];
        SKAirSandboxModel* file = [SKAirSandboxModel new];
        file.path = fullPath;
        if (isDir) {
            file.type = eSKFileItemDirectory;
            file.name = [NSString stringWithFormat:@"%@ %@", @"📁", path];
        } else {
            file.type = eSKFileItemFile;
            file.name = [NSString stringWithFormat:@"%@ %@", @"📄", path];
        }
        [files addObject:file];
        
    }
    _items = files.copy;
    [self.tableView reloadData];
}

#pragma mark- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > _items.count-1) {
        return [UITableViewCell new];
    }
    SKAirSandboxModel* item = [_items objectAtIndex:indexPath.row];
    SKAirSandboxCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SKAirSandboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell renderCellWithItem:item];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > _items.count-1) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    SKAirSandboxModel* item = [_items objectAtIndex:indexPath.row];
    if (item.type == eSKFileItemUp) {
        [self loadPath:[item.path stringByDeletingLastPathComponent]];
    }
    else if(item.type == eSKFileItemFile) {
        [self sharePath:item.path];
    }
    else if(item.type == eSKFileItemDirectory) {
        [self loadPath:item.path];
    }
}

- (void)sharePath:(NSString*)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSArray *objectsToShare = @[url];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    NSArray *excludedActivities = @[UIActivityTypePostToTwitter, UIActivityTypePostToFacebook,
                                    UIActivityTypePostToWeibo,
                                    UIActivityTypeMessage, UIActivityTypeMail,
                                    UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                    UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll,
                                    UIActivityTypeAddToReadingList, UIActivityTypePostToFlickr,
                                    UIActivityTypePostToVimeo, UIActivityTypePostToTencentWeibo];
    controller.excludedActivityTypes = excludedActivities;
    
    if ([(NSString *)[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
        controller.popoverPresentationController.sourceView = self.view;
        controller.popoverPresentationController.sourceRect = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height, 10, 10);
    }
    [self presentViewController:controller animated:YES completion:nil];
}
- (void)btnCloseClick {
    self.view.window.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[SKAirSandboxCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}

@end
