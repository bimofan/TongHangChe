//
//  YuyueCarTableViewController.h
//  TXCar
//
//  Created by MacBooK Pro on 15/10/6.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarDetail.h"
@interface YuyueCarTableViewController : UITableViewController
@property(nonatomic,copy)NSString* contactName;
@property(nonatomic,copy)NSString* contactPhone;
@property(nonatomic,copy)NSString* facherenId;
@property(nonatomic,strong) CarDetail * models;
@end
