//
//  UIView+Frame.h
//  PDBuDeJie
//
//  Created by  on 2018/6/8.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

/**
 宽
 */
@property CGFloat pd_width;

/**
 高
 */
@property CGFloat pd_height;

/**
 X轴
 */
@property CGFloat pd_x;

/**
 Y轴
 */
@property CGFloat pd_y;

/**
 中心X轴
 */
@property CGFloat pd_centerX;

/**
 中心Y轴
 */
@property CGFloat pd_centerY;

//通过继承UIView的类名来加载同名Xib文件
+ (instancetype)pd_viewFromXib ;

@end
