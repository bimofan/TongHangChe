//
//  LoginViewController.m
//  TXCar
//
//  Created by jack on 15/9/23.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobUser.h>
#import "SVProgressHUD.h"
#import "RKDropdownAlert.h"
#import <BmobIM/BmobIM.h>
#import <BmobIM/BmobChat.h>
#import "Header.h"


@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *login_button;
@property (weak, nonatomic) IBOutlet UITextField *user_password;
@property (weak, nonatomic) IBOutlet UITextField *user_name;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _login_button.layer.cornerRadius=5.0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_user_name resignFirstResponder];
    [_user_password resignFirstResponder];
}

- (IBAction)user_password_return:(UITextField *)sender {
}

- (IBAction)user_name_return:(UITextField *)sender {
    [sender resignFirstResponder];
}
- (IBAction)login_clicked:(UIButton *)sender {
    [BmobUser loginInbackgroundWithAccount:_user_name.text andPassword:_user_password.text block:^(BmobUser *user, NSError *error) {
        if (user !=nil) {
            
          
                
        //这句一定要，重新绑定，不然收不到消息
        if ([[NSUserDefaults standardUserDefaults ] objectForKey:kDeviceTokenData])
        {
              
          [[BmobUserManager currentUserManager] checkAndBindDeviceToken:[[NSUserDefaults standardUserDefaults] objectForKey:kDeviceTokenData]];
                
            }
 
                
                
            
            
            
            [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [self.delegate login_to_my_value:@"已登录" andtelephone:_user_name.text];
           
            
    NSUserDefaults *userDefaults = [NSUserDefaults  standardUserDefaults];
            NSString* saveString = _user_password.text;
            [userDefaults setObject:saveString forKey:@"password"];
            //保存数据
            [userDefaults synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [RKDropdownAlert title:@"登录失败:用户名或者密码错误" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
        }
    }];
    
}

//-(void)login_to_my_value:(NSString*)login_state andtelephone:(NSString *)telephone{
//    login_state=@"已登录";
//    telephone=_user_name.text;
//}

- (IBAction)forget_password_clicked:(UIButton *)sender {
    [SVProgressHUD showInfoWithStatus:@"功能为开放"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    
}
- (IBAction)cancel_clicked:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
