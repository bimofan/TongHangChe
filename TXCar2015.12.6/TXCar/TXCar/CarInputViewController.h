//
//  CarInputViewController.h
//  TXCar
//
//  Created by jack on 15/9/22.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarDetail.h"
@interface CarInputViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableview_input;
@property(nonatomic,strong) CarDetail * model;
@property(nonatomic,copy)NSString * cainfo;
@property(nonatomic,copy)NSString * dihzi;
@property(nonatomic,copy)NSString * suozaidi;
@end
