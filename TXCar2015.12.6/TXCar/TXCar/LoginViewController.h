//
//  LoginViewController.h
//  TXCar
//
//  Created by jack on 15/9/23.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol LoginToMyDelegate
-(void)login_to_my_value:(NSString*)login_state andtelephone:(NSString *)telephone;
@end


@interface LoginViewController : UIViewController
@property (weak, nonatomic) id <LoginToMyDelegate> delegate;
@end
