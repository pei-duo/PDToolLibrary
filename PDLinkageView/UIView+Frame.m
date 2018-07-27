//
//  UIView+Frame.m
//  PDBuDeJie
//
//  Created by  on 2018/6/8.
//  Copyright © 2018年 . All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

//通过继承UIView的类名来加载同名Xib文件
+ (instancetype)pd_viewFromXib {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

- (void)setPd_width:(CGFloat)pd_width{
    
    CGRect rect = self.frame;
    rect.size.width = pd_width;
    self.frame = rect;
}

- (CGFloat)pd_width{
    return self.frame.size.width;
}

- (void)setPd_height:(CGFloat)pd_height{
    
    CGRect rect = self.frame;
    rect.size.height = pd_height;
    self.frame = rect;
}

- (CGFloat)pd_height{
    return self.frame.size.height;
}

- (void)setPd_x:(CGFloat)pd_x{
    
    CGRect rect = self.frame;
    rect.origin.x = pd_x;
    self.frame = rect;
}

- (CGFloat)pd_x{
    return self.frame.origin.x;
}

- (void)setPd_y:(CGFloat)pd_y{
    
    CGRect rect = self.frame;
    rect.origin.y = pd_y;
    self.frame = rect;
}

- (CGFloat)pd_y{
    return self.frame.origin.y;
}

- (void)setPd_centerX:(CGFloat)pd_centerX{
    CGPoint center = self.center;
    center.x = pd_centerX;
    self.center = center;
}

- (CGFloat)pd_centerX{
    return self.center.x;
}

- (void)setPd_centerY:(CGFloat)pd_centerY{
    CGPoint center = self.center;
    center.y = pd_centerY;
    self.center = center;
}

- (CGFloat)pd_centerY{
    return self.center.y;
}

@end
