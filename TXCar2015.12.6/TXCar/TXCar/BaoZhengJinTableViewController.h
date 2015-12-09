//
//  BaoZhengJinTableViewController.h
//  TXCar
//
//  Created by jack on 15/10/28.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol baozhengjinDelegate<NSObject>
-(void)change:(NSString *)aaa;
@end
@interface BaoZhengJinTableViewController : UITableViewController
@property (nonatomic,retain) id<baozhengjinDelegate>delegate;
@end
