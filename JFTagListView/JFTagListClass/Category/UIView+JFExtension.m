//
//  UIView+JFExtension.m
//  JFTagListView
//
//  Created by 张剑锋 on 15/11/30.
//  Copyright © 2015年 张剑锋. All rights reserved.
//

#import "UIView+JFExtension.h"

@implementation UIView (JFExtension)

-(CGPoint)jf_origin{
    return self.frame.origin;
}

-(void)setJf_origin:(CGPoint)jf_origin{
    CGRect frame = self.frame;
    frame.origin = jf_origin;
    self.frame = frame;
}

-(CGSize)jf_size{
    return self.frame.size;
}

-(void)setJf_size:(CGSize)jf_size{
    CGRect frame = self.frame;
    frame.size = jf_size;
    self.frame = frame;
}

-(CGFloat)jf_x{
    return CGRectGetMinX(self.frame);
}

-(void)setJf_x:(CGFloat)jf_x{
    CGRect frame = self.frame;
    frame.origin.x = jf_x;
    self.frame = frame;
}

-(CGFloat)jf_y{
    return CGRectGetMinY(self.frame);
}

-(void)setJf_y:(CGFloat)jf_y{
    CGRect frame = self.frame;
    frame.origin.y = jf_y;
    self.frame = frame;
}

-(CGFloat)jf_width{
    return CGRectGetWidth(self.frame);
}

-(void)setJf_width:(CGFloat)jf_width{
    CGRect frame = self.frame;
    frame.size.width = jf_width;
    self.frame = frame;
}

-(CGFloat)jf_height{
    return CGRectGetHeight(self.frame);
}

-(void)setJf_height:(CGFloat)jf_height{
    CGRect frame = self.frame;
    frame.size.height = jf_height;
    self.frame = frame;
}

-(CGFloat)jf_left{
    return CGRectGetMinX(self.frame);
}

-(void)setJf_left:(CGFloat)jf_left{
    CGRect frame = self.frame;
    frame.origin.x = jf_left;
    frame.size.width = MAX(self.jf_right-jf_left, 0);
    self.frame = frame;
}

-(CGFloat)jf_right{
    return CGRectGetMaxX(self.frame);
}

-(void)setJf_right:(CGFloat)jf_right{
    CGRect frame = self.frame;
    frame.size.width = MAX(jf_right-self.jf_left, 0);
    self.frame = frame;
}

-(CGFloat)jf_top{
    return CGRectGetMinY(self.frame);
}

-(void)setJf_top:(CGFloat)jf_top{
    CGRect frame = self.frame;
    frame.origin.y = jf_top;
    frame.size.height = MAX(self.jf_bottom-jf_top, 0);
    self.frame = frame;
}

-(CGFloat)jf_bottom{
    return CGRectGetMaxY(self.frame);
}

-(void)setJf_bottom:(CGFloat)jf_bottom{
    CGRect frame = self.frame;
    frame.size.height = MAX(jf_bottom-self.jf_top, 0);
    self.frame = frame;
}

-(CGFloat)jf_centerX{
    return self.center.x;
}

-(void)setJf_centerX:(CGFloat)jf_centerX{
    CGPoint center = self.center;
    center.x = jf_centerX;
    self.center = center;
}

-(CGFloat)jf_centerY{
    return self.center.y;
}

-(void)setJf_centerY:(CGFloat)jf_centerY{
    CGPoint center = self.center;
    center.y = jf_centerY;
    self.center = center;
}


@end
