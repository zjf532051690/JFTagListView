//
//  UIView+JFExtension.h
//  JFTagListView
//
//  Created by 张剑锋 on 15/11/30.
//  Copyright © 2015年 张剑锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JFExtension)

@property (nonatomic, assign) CGPoint jf_origin;

@property (nonatomic, assign) CGSize jf_size;

@property (nonatomic, assign) CGFloat jf_x, jf_y, jf_width, jf_height;

@property (nonatomic, assign) CGFloat jf_left, jf_right, jf_top, jf_bottom;

@property (nonatomic, assign) CGFloat jf_centerX;

@property (nonatomic, assign) CGFloat jf_centerY;

@end
