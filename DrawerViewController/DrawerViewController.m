//
//  DrawerViewController.m
//  DRAWER_OC
//
//  Created by 裴铎 on 2016/10/27.
//  Copyright © 2016年 裴铎. All rights reserved.
/**
 最底层控制器
 左侧控制器和主tabBar控制器都在他之上
 */

#import "DrawerViewController.h"
#import "MainTabBarController.h"
#import "LeftTableViewController.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds

@interface DrawerViewController ()
@property (nonatomic, strong)MainTabBarController *mainViewController;
@property (nonatomic, strong)LeftTableViewController *leftViewController;
/** 覆盖按钮
 当用户触发屏幕边缘平移手势时添加到主tabBar控制器视图上 */
@property (nonatomic, strong)UIButton *coverButton;
@property (nonatomic, assign) CGFloat drawerMaxWidth;
@property (nonatomic, strong)UIViewController *destViewController;
@end
@implementation DrawerViewController

/**
 创建单例方法
 */
+ (instancetype)shareDrawerViewController{
    return (DrawerViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}

/**
 创建抽屉
 @param leftViewController 左边控制器
 @param mainViewController 主控制器
 */
+ (instancetype)drawerWithLeftViewController:(UIViewController *)leftViewController andMainViewController:(UIViewController *)mainViewController andMaxWidth:(CGFloat)maxWidth{
    
    /** 创建抽屉控制器 */
    DrawerViewController *drawerViewController = [[DrawerViewController alloc]init];
    /** 设置抽屉的主tabBar控制器 */
    drawerViewController.mainViewController = (MainTabBarController *)mainViewController;
    /** 设置抽屉的左控制器 */
    drawerViewController.leftViewController = (LeftTableViewController *)leftViewController;
    /** 抽屉的平移距离 */
    drawerViewController.drawerMaxWidth = maxWidth;
    
    /** 快速遍历tabBar下的子控制器 */
    for (UIViewController *childViewController in mainViewController.childViewControllers) {
        childViewController.view.backgroundColor = [UIColor whiteColor];
    }
    
    /** 给抽屉控制器上视图添加子视图 */
    [drawerViewController.view addSubview:leftViewController.view];
    [drawerViewController.view addSubview:mainViewController.view];
    /** 添加抽屉控制器的子控制器 */
    [drawerViewController addChildViewController:leftViewController];
    [drawerViewController addChildViewController:mainViewController];
    /** 添加左侧子控制器后让它向左侧平移 */
    leftViewController.view.transform = CGAffineTransformMakeTranslation(-maxWidth, 0);
    
    /** 返回抽屉对象 */
    return drawerViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 抽屉控制器视图的背景色 */
    self.view.backgroundColor = [UIColor whiteColor];
    /** 设置主tabBar控制器的图层阴影效果,为了美观
     不设置也可以*/
    self.mainViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.mainViewController.view.layer.shadowOffset = CGSizeMake(-1, -1);
    self.mainViewController.view.layer.shadowRadius = 4;
    self.mainViewController.view.layer.shadowOpacity = 0.8;
    
    /** 给所有的子控制器视图添加平移手势 */
    for (UIViewController *childViewController in self.mainViewController.childViewControllers) {
        [self addScreenEdgePanGestureRecognizerToView:childViewController.view];
    }
}

/**
 打开抽屉效果
 */
- (void)openDrawerWithOpenDuration:(CGFloat)openDuration{
    //打开抽屉的动画
    [UIView animateWithDuration:openDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        /** 设置主控制器的变形(平移)效果
         坐标系统采用的是二维坐标系,即向右为x轴正方向,向下为y轴正方向 */
        self.mainViewController.view.transform = CGAffineTransformMakeTranslation(self.drawerMaxWidth, 0);
        /** 设置左侧控制器的默认仿射常量CGAffineTransformIdentity */
        self.leftViewController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        /** 给主tabBar添加返回按钮(透明的遮盖整个tabBar) */
        [self.mainViewController.view addSubview:self.coverButton];
        /** 给按钮添加平移手势,方便返回 */
        [self addPanGestureRecognizerToView:self.coverButton];
    }];
}

/**
 关闭抽屉效果
 根据关闭动画时间
 */
- (void)closeDrawerWithCloseDuration:(CGFloat)closeDuration{
    /** 关闭动画 */
    [UIView animateWithDuration:closeDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        /** 设置tabBar控制器的默认仿射常量CGAffineTransformIdentity */
        /* The identity transform: [ 1 0 0 1 0 0 ]. 和原先一样的transform */
        self.mainViewController.view.transform = CGAffineTransformIdentity;
        /** 设置左侧控制器的变形(平移)效果
         坐标系统采用的是二维坐标系,即向左为x轴负方向,y轴不变 */
        self.leftViewController.view.transform = CGAffineTransformMakeTranslation(-self.drawerMaxWidth, 0);
    } completion:^(BOOL finished) {
        //动画结束回调
        if (self.coverButton) {//如果按钮存在
            //移除返回按钮 并 清空
            [self.coverButton removeFromSuperview];
            self.coverButton = nil;
        }
    }];
}

/**
 选择左侧控制器后进行跳转
 */
- (void)switchViewController:(UIViewController *)viewController{
    /** 左侧控制器上的跳转方法 */
    [self.view addSubview:viewController.view];
    [self addChildViewController:viewController];
    /** 把 前往目的地控制器 升级成全局的 */
    self.destViewController = viewController;
    
    /** 设置跳转后的页面位置 */
    viewController.view.transform = CGAffineTransformMakeTranslation(SCREEN_BOUNDS.size.width, 0);
    
    /** 动画 */
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        viewController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.mainViewController.view.transform = CGAffineTransformIdentity;
        [self.coverButton removeFromSuperview];
        self.coverButton = nil;
    }];
}

/**
 跳回主控制器
 */
- (void)swithToMainViewController{
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        /** 当前 */
        self.destViewController.view.transform = CGAffineTransformMakeTranslation(SCREEN_BOUNDS.size.width, 0);
        
    } completion:^(BOOL finished) {
        [self.destViewController removeFromParentViewController];
        [self.destViewController.view removeFromSuperview];
        self.destViewController = nil;
    }];
}

/**
 创建边缘拖拽手势
 */
- (void)addScreenEdgePanGestureRecognizerToView:(UIView *)view{
    /** 创建 屏幕边缘平移手势识别器
     设置代理对象和回调方法*/
    UIScreenEdgePanGestureRecognizer *pan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(screenEdgePanGestureRecognizer:)];
    /** 设置平移手势的识别位置,左侧(UIRectEdgeLeft) */
    pan.edges = UIRectEdgeLeft;
    /** 给传入的视图添加平移手势 */
    [view addGestureRecognizer:pan];
}

/**
 边缘拖拽手势的回调
 */
- (void)screenEdgePanGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)pan{
    
    CGFloat OffsetX = [pan translationInView:pan.view].x;
    
    if (pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateEnded) {
        
        if (OffsetX > SCREEN_BOUNDS.size.width * 0.5) {
            [self openDrawerWithOpenDuration:((self.drawerMaxWidth - OffsetX) / self.drawerMaxWidth) * 0.2];
        }else{
            [self closeDrawerWithCloseDuration:(OffsetX / self.drawerMaxWidth) * 0.2];
        }
        
    }else if(pan.state == UIGestureRecognizerStateChanged){
        if (OffsetX > 0 && OffsetX < self.drawerMaxWidth) {
            self.mainViewController.view.transform = CGAffineTransformMakeTranslation(OffsetX, 0);
            self.leftViewController.view.transform = CGAffineTransformMakeTranslation(-self.drawerMaxWidth + OffsetX, 0);
        }
    }
}


/**
 创建拖动手势，添加到覆盖按钮上
 为了实现拖动主tabBar的剩余部分返回整个tabBar控制器
 */
- (void)addPanGestureRecognizerToView:(UIButton *)button{
    /** 创建 平移手势识别器
     这个不是屏幕边缘平移手势识别器*/
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizer:)];
    /** 添加到覆盖按钮上 */
    [button addGestureRecognizer:pan];
}


/**
 按钮平移手势的回调
 */
- (void)panGestureRecognizer:(UIPanGestureRecognizer *)pan{
    CGFloat offsetX = [pan translationInView:pan.view].x;
//    CGFloat SCREENWIDTH = SCREENBOUNDS.size.width;
    if (pan.state == UIGestureRecognizerStateFailed || pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateEnded ) {
        if (SCREEN_BOUNDS.size.width - self.drawerMaxWidth + ABS(offsetX) > SCREEN_BOUNDS.size.width * 0.5) {
            [self closeDrawerWithCloseDuration:((self.drawerMaxWidth - ABS(offsetX)) / self.drawerMaxWidth) * 0.2];
        }else{
            [self openDrawerWithOpenDuration:(ABS(offsetX) / self.drawerMaxWidth) * 0.2];
        }
    }else if (pan.state == UIGestureRecognizerStateChanged && offsetX < 0 && offsetX > - self.drawerMaxWidth){
        self.mainViewController.view.transform = CGAffineTransformMakeTranslation(self.drawerMaxWidth + offsetX, 0);
        self.leftViewController.view.transform = CGAffineTransformMakeTranslation(offsetX, 0);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- lozyloding
-(UIButton *)coverButton{
    if (!_coverButton) {
        _coverButton = [[UIButton alloc]initWithFrame:SCREEN_BOUNDS];
        [_coverButton addTarget:self.mainViewController action:@selector(closeDrawer) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverButton;
}

@end
