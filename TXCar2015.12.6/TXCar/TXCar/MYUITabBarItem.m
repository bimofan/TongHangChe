//
//  MYUITabBarItem.m
//  TXCar
//
//  Created by jack on 15/9/17.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import "MYUITabBarItem.h"

@implementation MYUITabBarItem
- (void)awakeFromNib {
    
// 设置指定状态标题的颜色
 [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
 [self setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];

}

@end
