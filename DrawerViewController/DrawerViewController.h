//
//  DrawerViewController.h
//  DRAWER_OC
//
//  Created by 裴铎 on 2016/10/27.
//  Copyright © 2016年 裴铎. All rights reserved.
/** 一下代码需要在AppDelegate.m文件实现
 在AppDelegate.m中导入以下头文件
 #import "DrawerViewController.h"
 #import "LeftTableViewController.h"
 #import "MainTabBarController.h"
 
 在 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 方法中实现一下代码
 //初始化窗口
 self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
 
 //  创建左视图
 LeftTableViewController *leftViewController = [[LeftTableViewController alloc]init];
 //  创建主视图
 MainTabBarController *mainViewController = [[MainTabBarController alloc]init];
 //  传入左视图和主视图以及抽屉的最大宽度 创建抽屉
 DrawerViewController *rootViewController = [DrawerViewController drawerWithLeftViewController:leftViewController andMainViewController:mainViewController andMaxWidth:300];
 
 //设置窗口根控制器
 self.window.rootViewController = rootViewController;
 
 [self.window makeKeyAndVisible];
 */

#import <UIKit/UIKit.h>

@interface DrawerViewController : UIViewController

/**
 创建抽屉

 @param leftViewController 左边的控制器
 @param mainViewController 中间的主tabBar控制器
 @param maxWidth 打开抽屉时主控制器的x轴平移距离
 @return 抽屉本类对象
 */
+ (instancetype)drawerWithLeftViewController:(UIViewController *)leftViewController andMainViewController:(UIViewController *)mainViewController andMaxWidth:(CGFloat)maxWidth;

/**
 创建抽屉的单例对象

 @return 抽屉的单例对象
 */
+ (instancetype)shareDrawerViewController;

/**
 打开抽屉

 @param openDuration 动画时间
 */
- (void)openDrawerWithOpenDuration:(CGFloat)openDuration;

/**
 关闭抽屉效果
 
 @param closeDuration 动画时间
 */
- (void)closeDrawerWithCloseDuration:(CGFloat)closeDuration;

/**
 选择左侧控制器后进行跳转

 @param viewController 要前往目的地控制器
 */
- (void)switchViewController:(UIViewController *)viewController;

/**
 跳回主控制器
 */
- (void)swithToMainViewController;

@end
