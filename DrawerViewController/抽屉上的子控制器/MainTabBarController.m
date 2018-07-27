//
//  MainTabBarController.m
//  DRAWER_OC
//
//  Created by 裴铎 on 2016/10/27.
//  Copyright © 2016年 裴铎. All rights reserved.
//

#import "MainTabBarController.h"
#import "DrawerViewController.h"

/***************************************************************************
 mainTabBar上的子控制器 **/
#import "PDNewViewController.h"
/**
 **************************************************************************/

@interface MainTabBarController ()

@property (nonatomic, strong)UIBarButtonItem *openDrawerIcon;

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self addAllChildViewController];
    }
    
    return self;
}

/***************************************************************************
 添加MainTabBar控制器的所有子控制器方法 **/
- (void)addAllChildViewController{
    
    PDNewViewController *newVC = [[PDNewViewController alloc]init];
    [self addChildViewController:newVC andTabTitle:@"新控制器" andDefaultImageName:@"tab_recent_nor" andSelectedImageName:@"tab_recent_press"];
    
}
/** 在以上 - (void)addAllChildViewController; 方法中添加整个项目(左侧控制器外)的所有子控制器
 **************************************************************************/

/**
 根据传入的标题和图片创建子控制器

 @param childController   要添加的子控制器
 @param title             标题
 @param defaultImageName  tabBarItem的默认图片
 @param selectedImageName tabBarItem的选中图片
 */
-(void)addChildViewController:(UIViewController *)childController andTabTitle:(NSString *)title andDefaultImageName:(NSString *)defaultImageName andSelectedImageName:(NSString *)selectedImageName{
    /** 把传入的子控制器包装导航控制器 */
    UINavigationController *NAVNC = [[UINavigationController alloc]initWithRootViewController:childController];
    /** 把包装好的控制器添加到mainTabBar控制器上 */
    [self addChildViewController:NAVNC];
    
    /**
    if ([title isEqualToString:@"消息"]) {
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"消息",@"电话",nil]];
        segmentedControl.tintColor = [UIColor purpleColor];
        segmentedControl.backgroundColor = [UIColor whiteColor];
        segmentedControl.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 0.5 - 80, 20, 160, 30);
        childController.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@""];
        segmentedControl.selected = YES;
        segmentedControl.selectedSegmentIndex = 0;
        childController.navigationItem.titleView = segmentedControl;
     
        childController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"run10"] style:UIBarButtonItemStylePlain target:self action:@selector(openDrawer)];
    }
     */
    
    childController.navigationItem.title = title;
    childController.tabBarItem.title = title;
    [childController.tabBarItem setImage:[UIImage imageNamed:defaultImageName]];
    [childController.tabBarItem setSelectedImage:[UIImage imageNamed:selectedImageName]];
}


/**
 打开抽屉
 */
- (void)openDrawer{
    [[DrawerViewController shareDrawerViewController] openDrawerWithOpenDuration:0.2];
}


/**
 关闭抽屉
 */
- (void)closeDrawer{
    [[DrawerViewController shareDrawerViewController] closeDrawerWithCloseDuration:0.2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



