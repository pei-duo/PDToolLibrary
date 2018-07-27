//
//  LeftTableViewController.m
//  DRAWER_OC
//
//  Created by 裴铎 on 2016/10/27.
//  Copyright © 2016年 裴铎. All rights reserved.
//

#import "LeftTableViewController.h"
#import "LeftTurnViewController.h"
#import "DrawerViewController.h"

@interface LeftTableViewController ()<
/** UITableView协议 */
UITableViewDelegate,
UITableViewDataSource
>
/** 左侧的头部视图 */
@property (nonatomic, strong)UIView *headerView;
/** 数据源 */
@property (nonatomic, strong)NSMutableArray *dataArray;;
/** UITableView */
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation LeftTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 添加头部视图 */
    [self.view addSubview:self.headerView];
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 300, size.width, size.height - 300) style:UITableViewStylePlain];
//    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leftbg"]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /** 重用标识符 */
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /** 创建要跳转的页面对象 */
    LeftTurnViewController *rootViewController = [[LeftTurnViewController alloc]init];
    rootViewController.navigationItem.title = self.dataArray[indexPath.row];
    rootViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(turnBackToMainViewConttoller)];
    UINavigationController *navViewController = [[UINavigationController alloc]initWithRootViewController:rootViewController];

    [[DrawerViewController shareDrawerViewController] switchViewController:navViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


/**
 选中cell后的跳转
 */
- (void)turnBackToMainViewConttoller{
    [[DrawerViewController shareDrawerViewController] swithToMainViewController];
}

#pragma mark - 懒加载
-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
        //_headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"scenery"]];
    }
    return _headerView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"了解会员特权",@"QQ钱包",@"个性装扮",@"我的收藏",@"我的相册",@"我的文件",@"我的名片夹", nil];
    }
    return _dataArray;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}




@end
