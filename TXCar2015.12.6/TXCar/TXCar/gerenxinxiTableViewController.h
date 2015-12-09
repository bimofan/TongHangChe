//
//  gerenxinxiTableViewController.h
//  TXCar
//
//  Created by jack on 15/10/21.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarDetail.h"
@interface gerenxinxiTableViewController : UITableViewController
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * suozaidi;
@property(nonatomic,copy)NSString * riqi;
@property(nonatomic,copy)NSString * touxiang;
@property(nonatomic,copy)NSString * type_title;
@property(nonatomic,copy)NSString *yiyangde;
@property(nonatomic,strong) CarDetail * models;
@property(nonatomic,strong) BmobUser * model;
@property(nonatomic,assign) int tagg;
@end
