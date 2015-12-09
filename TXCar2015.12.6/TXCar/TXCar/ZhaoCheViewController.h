//
//  ZhaoCheViewController.h
//  TXCar
//
//  Created by jack on 15/9/17.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhaoCheViewController : UIViewController
@property (nonatomic, copy) NSString * car_type_search;
@property(nonatomic ,copy)NSString * selecte_city;
@property (nonatomic, copy) NSString * car_city_search;
-(void)setupRefresh;
@end
