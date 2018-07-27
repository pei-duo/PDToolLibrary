//
//  PDLinkageView.h
//  联动视图
//
//  Created by 裴铎 on 2018/7/26.
//  Copyright © 2018年 裴铎. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDLinkageView : UIView
/** 标题视图 */
@property (nonatomic, strong) UIView * titlesView;
/** 用来承载所有子控制器的滚动视图 */
@property (nonatomic)UIScrollView * scrollView;
/** 存放子控制器对象的数组,内部的元素个数必须和标题数组内的一致 */
@property (nonatomic, strong) NSArray <UIViewController *> * allViewControllers;


/**
 联动视图的初始化方法

 @param frame 联动视图的尺寸
 @param viewController 父控制器,联动视图上的所有子控制器的父控制器
 @param titleArray 标题数组,传入的元素个数必须 >= 2
 @param index 联动视图默认显示的标题按钮下标
 @return 联动视图
 */
- (instancetype)initWithFrame:(CGRect)frame
               viewController:(UIViewController *)viewController
                   titleArray:(NSArray *)titleArray
           defaultButtonIndex:(NSUInteger)index;
@end
