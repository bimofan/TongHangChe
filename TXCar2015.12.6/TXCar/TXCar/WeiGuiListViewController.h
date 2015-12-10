//
//  WeiGuiListViewController.h
//  TXCar
//
//  Created by ZhuHaikun on 15/12/10.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiguiCell.h"

@interface WeiGuiListViewController : UITableViewController

@property (nonatomic) NSDictionary *param;
@property (nonatomic) NSString *titleStr;

@property (weak, nonatomic) IBOutlet UILabel *headLabel;

@property (weak, nonatomic) IBOutlet UIView *headerView;


@end
