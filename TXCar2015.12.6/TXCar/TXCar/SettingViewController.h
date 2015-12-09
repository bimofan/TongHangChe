//
//  SettingViewController.h
//  TXCar
//
//  Created by jack on 15/9/23.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginOutDelegate
-(void)login_out:(NSString*)login_state;
@end
@interface SettingViewController : UIViewController
@property (weak, nonatomic) id <LoginOutDelegate> delegate;
@end
