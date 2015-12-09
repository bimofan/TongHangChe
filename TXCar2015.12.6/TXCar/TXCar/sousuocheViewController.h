//
//  sousuocheViewController.h
//  TXCar
//
//  Created by jack on 15/11/9.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sousuocheViewController : UIViewController
@property (nonatomic, copy) NSString * car_type_search;
@property(nonatomic ,copy)NSString * selecte_city;
@property (nonatomic, copy) NSString * car_city_search;
-(void)setupRefresh;
@end
