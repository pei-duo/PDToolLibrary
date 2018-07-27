//
//  PDLinkageView.m
//  联动视图
//
//  Created by 裴铎 on 2018/7/26.
//  Copyright © 2018年 裴铎. All rights reserved.
//

#import "PDLinkageView.h"
#import "UIView+Frame.h"

@interface PDLinkageView ()<
UIScrollViewDelegate
>{
    /** 联动视图的宽和高 */
    CGFloat mv_width;
    CGFloat mv_height;
    /** 标题按钮的高度 */
    CGFloat mv_titlesViewHeight;
    /** 联动视图的标题数组 */
    NSArray * mv_titlesArray;
}
/** 本类的控件唯一标识符常量,
 以编写本类代码的日期作为基础常量,再加上其他的变量可以得到一个不与其他控件冲突的唯一标识符 */
@property (nonatomic, assign) NSUInteger identifierTag;
/** 用来记录上一次点击的是哪一个按钮 */
@property (nonatomic, weak) UIButton * previousClickButton;
/** 标题按钮的下划线 */
@property (nonatomic) UIView * titleUnderline;
/** 默认显示按钮下标 */
@property (nonatomic, assign) NSUInteger defaultButtonSubscripts;
/** 父控制器 */
@property (nonatomic, strong) UIViewController * parentController;

@end


@implementation PDLinkageView

- (instancetype)initWithFrame:(CGRect)frame
               viewController:(UIViewController *)viewController
                   titleArray:(NSArray *)titleArray
           defaultButtonIndex:(NSUInteger)index{
    /** 调用父类方法 */
    self = [super initWithFrame:frame];
    /** 判断是否是本类对象调用 并 外界传入的图片数量足够滚动 */
    if (self && titleArray.count >= 2) {
        /** 控件的唯一标识符的基础常量 */
        self.identifierTag = 2018726;
        /** 联动视图的父控制器 */
        self.parentController = viewController;
        /** 默认显示按钮下标,不能大于标题数组元素个数 */
        if (index < titleArray.count) {
            self.defaultButtonSubscripts = index;
        }
        /** 联动视图的宽度 */
        mv_width = frame.size.width;
        /** 联动视图的高的 */
        mv_height = frame.size.height;
        /** 得到标题数组 */
        mv_titlesArray = titleArray;
        /** 加载标题视图 */
        [self addSubview:self.titlesView];
        /** 滚动视图 */
        [self setupScrollView];
    }
    return self;
}

/** 懒加载标题视图 */
- (UIView *)titlesView{
    if (_titlesView == nil) {
        _titlesView = [[UIView alloc] init];
        CGFloat titlesViewWidth = mv_width;
        mv_titlesViewHeight = 35;
        _titlesView.frame = CGRectMake(0, 0, titlesViewWidth, mv_titlesViewHeight);
        _titlesView.backgroundColor = [UIColor whiteColor];
        /** 获取应该添加的按钮个数 */
        NSUInteger count = mv_titlesArray.count;
        /** 循环添加按钮 */
        for (NSUInteger i = 0; i < count; i ++) {
            /** 初始化按钮 */
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            /** 按钮的宽度 */
            CGFloat buttonW = titlesViewWidth / count;
            /** 按钮的位置和尺寸 */
            button.frame = CGRectMake(i * buttonW, 0, buttonW, mv_titlesViewHeight);
            /** 按钮的默认显示文字 */
            [button setTitle:mv_titlesArray[i] forState:0];
            /** 显示文字的默认颜色 */
            [button setTitleColor:[UIColor blackColor] forState:0];
            /** 设置按钮的选中状态的文字颜色 */
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            /** 设置按钮的点击事件 */
            [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            /** 设置按钮的唯一标识符 */
            button.tag = self.identifierTag + i;
            /** 添加按钮到标题视图 */
            [_titlesView addSubview:button];
            /** 设置默认的显示按钮 */
            if (i == self.defaultButtonSubscripts) {
                /** 改变按钮的选中状态 */
                button.selected = YES;
                /** 设置上一次点击的按钮 */
                self.previousClickButton = button;
            }
        }
        /** 加载下划线 */
        [self setupTitleUnderlineWithView:_titlesView];
    }
    return _titlesView;
}

/**
 标题按钮的点击事件
 */
- (void)titleButtonClick:(UIButton *)titleButton{
    /** 取消上一次点击的按钮选中状态 */
    self.previousClickButton.selected = NO;
    /** 改变当前的按钮状态 */
    titleButton.selected = YES;
    /** 保存当前的按钮 */
    self.previousClickButton = titleButton;
    /** 滚动动画 */
    [UIView animateWithDuration:0.25 animations:^{
        /** 处理下划线的动画效果
         根据按钮上的文字来设置下划线的宽度 */
        self.titleUnderline.pd_width = [titleButton.currentTitle sizeWithAttributes:@{NSFontAttributeName : titleButton.titleLabel.font}].width;
        /** 改变下划线的X轴 */
        self.titleUnderline.pd_centerX = titleButton.pd_centerX;
        /** 滚动scrollView
         要滚动的X轴 通过按钮的唯一标识符,    indexOfObject:通过一个控件来得到他在父控件中的下标 */
        NSUInteger index = [self.titlesView.subviews indexOfObject:titleButton];
        CGFloat offsetX = self.scrollView.pd_width * index;
        /** 设置滚动视图的偏移量, 实现点击按钮下面的视图滚动 */
        self.scrollView.contentOffset = CGPointMake(offsetX, self.scrollView.contentOffset.y);
    } completion:^(BOOL finished) {/** 动画结束回调 */
        /** 添加子控制器到scrollView的对应位置中 */
        NSUInteger index = titleButton.tag - self.identifierTag;
        [self setupChildViewControllerWithIndex:index];
    }];
}

/**
 下划线
 */
- (void)setupTitleUnderlineWithView:(UIView *)titlesView{
    /** 拿到标题视图上的某一个按钮, 用来获取按钮上的状态信息 */
    UIButton *  button = titlesView.subviews.firstObject;
    /** 初始化下划线视图 */
    UIView * titleUnderline = [[UIView alloc] init];
    /** 下划线视图的背景色和按钮的选中状态一致 */
    titleUnderline.backgroundColor = [button titleColorForState:UIControlStateSelected];
    /** 下划线的高度 */
    titleUnderline.pd_height= 2;
    /** 下划线的宽度和按钮上文字的宽度一致 */
    titleUnderline.pd_width = [button.currentTitle sizeWithAttributes:@{NSFontAttributeName : button.titleLabel.font}].width;
    /** 下划线的Y轴 */
    titleUnderline.pd_y = titlesView.pd_height - 2;
    /** 下划线的X轴,让他和默认选中的按钮一致 */
    titleUnderline.pd_centerX = titlesView.subviews[self.defaultButtonSubscripts].pd_centerX;
    /** 添加下划线到标题视图 */
    [titlesView addSubview:titleUnderline];
    /** 设置全局属性 */
    self.titleUnderline = titleUnderline;
}

/**
 创建滚动视图
 */
- (void)setupScrollView{
    /** 修改scrollView的自动内边距 */
    //self.automaticallyAdjustsScrollViewInsets = NO;
    /** 初始化滚动视图 */
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    /** 背景色 灰 */
    scrollView.backgroundColor = [UIColor grayColor];
    /** 尺寸和位置 */
    scrollView.frame = CGRectMake(0, mv_titlesViewHeight, mv_width, mv_height - mv_titlesViewHeight);
    /** 滚动范围 */
    scrollView.contentSize = CGSizeMake(self.pd_width * mv_titlesArray.count, 0);
    /** 分页滚动 */
    scrollView.pagingEnabled = YES;
    /** 设置代理 */
    scrollView.delegate = self;
    /** 禁用滚动到顶部 */
    scrollView.scrollsToTop = NO;
    /** 禁用滚动条, 水平和垂直 */
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    /** 添加滚动视图到控制器 */
    [self addSubview:scrollView];
    /** 设置全局属性 */
    self.scrollView = scrollView;
    /** 设置滚动视图的默认偏移量, 程序刚进入的时候显示的页面 */
    self.scrollView.contentOffset = CGPointMake(self.pd_width * self.defaultButtonSubscripts, 0);
    /** 设置默认显示的控制器 */
    [self setupChildViewControllerWithIndex:self.defaultButtonSubscripts];
}

/**
 滚动视图结束减速触发的方法
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    /** 求出应该点击的按钮的索引 */
    NSUInteger index = scrollView.contentOffset.x / scrollView.pd_width;
    /** 通过索引得到按钮 */
    UIButton * button = self.titlesView.subviews[index];
    /** 点击对应的标题按钮 */
    [self titleButtonClick:button];
}


/**
 重写set方法
 只做了初始化,没有加载视图到父控制器上
 */
- (void)setAllViewControllers:(NSArray<UIViewController *> *)allViewControllers{
    if (allViewControllers.count == mv_titlesArray.count) {
        _allViewControllers = allViewControllers;
        for (id object in allViewControllers) {
            [self.parentController addChildViewController:(UIViewController *)object];
        }
        
        /** 通过索引得到按钮 */
        UIButton * button = self.titlesView.subviews[self.defaultButtonSubscripts];
        /** 点击对应的标题按钮 */
        [self titleButtonClick:button];
    }
    
}

/**
 根据索引加载子控制器到scrollView中

 @param index 索引
 */
- (void)setupChildViewControllerWithIndex:(NSUInteger)index {
    if (self.allViewControllers == nil) {
        return;/** 没有子控制器时不要执行下面的代码 */
    }
    /** 获取到索引对应的子控制器 */
    UIViewController * childVC = self.allViewControllers[index];
    /** 判断控制器是否被加载过 */
    if (childVC.isViewLoaded) {
        return;
    }/** 如果子控制器被加载过就返回,这个和下面的做一个就可以了 */

    /** 获取子控制器的视图 */
    UIView * childView = childVC.view;

    /** 判断视图是否被加载过,判断childView是否有父控件,如果有说明被加载过 */
    if (childView.superview) {
        /** 如果被加载过就返回不会重复加载同一空间,这个不做影响不大 */
        return;
    }
    if (childView.window) {return;}/** 这个和上面的相同 */
    /** 设置视图的frame */
    childView.frame = self.scrollView.bounds;
    /** 加载到滚动视图上 */
    [self.scrollView addSubview:childView];
}


@end
