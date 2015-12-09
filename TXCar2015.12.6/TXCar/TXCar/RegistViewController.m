//
//  RegistViewController.m
//  TXCar
//
//  Created by MacBooK Pro on 15/9/27.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import "RegistViewController.h"
#import "UIImageView+WebCache.h"
#import "RKDropdownAlert.h"
#import <SMS_SDK/SMS_SDK.h>
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobUser.h>
#import "MZTimerLabel.h"
@interface RegistViewController ()<MZTimerLabelDelegate>

@property (weak, nonatomic) IBOutlet UIButton *recommand_button;
@property (weak, nonatomic) IBOutlet UIButton *protocol_button;
@property (weak, nonatomic) IBOutlet UIButton *check_code_button;
@property (weak, nonatomic) IBOutlet UITextField *telephone_textfield;
@property (weak, nonatomic) IBOutlet UITextField *heck_code_textfield;
@property (weak, nonatomic) IBOutlet UITextField *connect_people_textfield;

@property (weak, nonatomic) IBOutlet UITextField *password_textfield;
@property (weak, nonatomic) IBOutlet UITextField *password_confirm_textfield;
@property (weak, nonatomic) IBOutlet UIView *tuijianren;
@property (weak, nonatomic) IBOutlet UITextField *tuijianrenshoujihao;


@property(nonatomic) BOOL recommand_button_state;
@property(nonatomic) BOOL protocol_button_state;
@end

@implementation RegistViewController
{
    UILabel *timer_show;//倒计时label
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人注册";
    NSLog(@"1");
   
    _check_code_button.layer.cornerRadius=5.0;
    [_recommand_button addTarget:self action:@selector(recommand_clicked) forControlEvents:UIControlEventTouchUpInside];
    [_protocol_button addTarget:self action:@selector(protocol_cliked) forControlEvents:UIControlEventTouchUpInside];
    
    [_check_code_button setTitle:@"发送验证码" forState:UIControlStateNormal];
    UIBarButtonItem *submit_btn = [[UIBarButtonItem alloc]initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(regist_clicked:)];
    self.navigationItem.rightBarButtonItem =submit_btn;
    _tuijianren.hidden=YES;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_tuijianrenshoujihao resignFirstResponder];
}
-(void)recommand_clicked{
    if (_recommand_button_state==NO) {
        [_recommand_button setImage:[UIImage imageNamed:@"check_true.png"] forState:normal];
        _recommand_button_state=YES;
         _tuijianren.hidden=NO;
        return;
    }
    if (_recommand_button_state==YES) {
        [_recommand_button setImage:[UIImage imageNamed:@"check_false.png"] forState:normal];
         _recommand_button_state=NO;
        _tuijianren.hidden=YES;
        return;
    }
}

-(void)protocol_cliked{
    if (_protocol_button_state==NO) {
        [_protocol_button  setImage:[UIImage imageNamed:@"check_true.png"] forState:normal];
        _protocol_button_state=YES;
        return;
    }
    if (_protocol_button_state==YES) {
        [_protocol_button setImage:[UIImage imageNamed:@"check_false.png"] forState:normal];
        _protocol_button_state=NO;
        return;
    }
}

- (IBAction)connect_user_begin_edit:(UITextField *)sender {
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, -160);
    } completion:nil];
    [_telephone_textfield resignFirstResponder];
   // [_connect_people_textfield resignFirstResponder];
    [_password_confirm_textfield resignFirstResponder];
    [_password_textfield resignFirstResponder];
    [_heck_code_textfield resignFirstResponder];

}
- (IBAction)connect_user_end_edit:(UITextField *)sender {
    
    [_telephone_textfield resignFirstResponder];
   // [_connect_people_textfield resignFirstResponder];
    [_password_confirm_textfield resignFirstResponder];
    [_password_textfield resignFirstResponder];
    [_heck_code_textfield resignFirstResponder];
    
}

- (IBAction)password_begin_edit:(UITextField *)sender {
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, -160);
    } completion:nil];
    [_telephone_textfield resignFirstResponder];
    [_connect_people_textfield resignFirstResponder];
    [_password_confirm_textfield resignFirstResponder];
    [_password_textfield resignFirstResponder];
    [_heck_code_textfield resignFirstResponder];

    
}

- (IBAction)password_end_edit:(UITextField *)sender {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];
  
}
- (IBAction)first_password_begin_edit:(UITextField *)sender {
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, -100);
    } completion:nil];
    [_telephone_textfield resignFirstResponder];
    [_connect_people_textfield resignFirstResponder];
   // [_password_confirm_textfield resignFirstResponder];
    [_password_textfield resignFirstResponder];
    [_heck_code_textfield resignFirstResponder];

}
- (IBAction)first_password_end_edit:(UITextField *)sender {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];
   // [sender resignFirstResponder];
}

- (IBAction)shoujihao:(UITextField *)sender {
    
    [_connect_people_textfield resignFirstResponder];
    [_password_confirm_textfield resignFirstResponder];
    [_password_textfield resignFirstResponder];
    [_heck_code_textfield resignFirstResponder];
}

- (IBAction)shoujihao1:(UITextField *)sender {
    
    [_connect_people_textfield resignFirstResponder];
    [_password_confirm_textfield resignFirstResponder];
    [_password_textfield resignFirstResponder];
    [_heck_code_textfield resignFirstResponder];
}

- (IBAction)yanzhengma:(UITextField *)sender {
    [_telephone_textfield resignFirstResponder];
    [_connect_people_textfield resignFirstResponder];
    [_password_confirm_textfield resignFirstResponder];
    [_password_textfield resignFirstResponder];
    [_heck_code_textfield resignFirstResponder];
}

- (IBAction)yanzhengma1:(UITextField *)sender {
    [_telephone_textfield resignFirstResponder];
    [_connect_people_textfield resignFirstResponder];
    [_password_confirm_textfield resignFirstResponder];
    [_password_textfield resignFirstResponder];
    [_heck_code_textfield resignFirstResponder];
}








- (IBAction)check_code_clicked:(UIButton *)sender {
    [_check_code_button setTitle:nil forState:UIControlStateNormal];//把按钮原先的名字消掉
    timer_show = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 30)];//UILabel设置成和UIButton一样的尺寸和位置
    [_check_code_button addSubview:timer_show];//把timer_show添加到_dynamicCode_btn按钮上
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timer_show andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:30];//倒计时时间60s
    timer_cutDown.timeFormat = @"倒计时 ss";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = [UIColor whiteColor];//倒计时字体颜色
    timer_cutDown.timeLabel.font = [UIFont systemFontOfSize:13.0];//倒计时字体大小
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    _check_code_button.userInteractionEnabled = NO;//按钮禁止点击
    [timer_cutDown start];//开始计时
    
    [_telephone_textfield resignFirstResponder];
    [SMS_SDK getVerificationCodeBySMSWithPhone:_telephone_textfield.text zone:@"86" result:^(SMS_SDKError *error) {
       
        if (error) {
            if (error.errorCode==518) {
                [RKDropdownAlert title:@"提示: 手机号格式不正确" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
            }else if (error.errorCode==523){
                [RKDropdownAlert title:@"提示: 请求验证的手机号已经被验证" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
            }else if (error.errorCode==524){
                [RKDropdownAlert title:@"提示: 客户端请求发送短信验证过于频繁" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
            }else{
                [RKDropdownAlert title:@"提示: 发生未知错误" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
            }

        } else {
         
            NSLog(@"获取验证码成功");
          //  NSLog(@"错误吗：%zi,错误描述：%@",error.errorCode,error.errorDescription);
        }
    }];
    
}

- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    [_check_code_button setTitle:@"发送验证码" forState:UIControlStateNormal];//倒计时结束后按钮名称改为"发送验证码"
    [timer_show removeFromSuperview];//移除倒计时模块
    _check_code_button.userInteractionEnabled = YES;//按钮可以点击
}

- (IBAction)tap_screen:(UITapGestureRecognizer *)sender {
    [_telephone_textfield resignFirstResponder];
    [_connect_people_textfield resignFirstResponder];
    [_password_confirm_textfield resignFirstResponder];
    [_password_textfield resignFirstResponder];
    [_heck_code_textfield resignFirstResponder];
}


-(void)regist_clicked:(UIBarButtonItem *)sender{
     NSLog(@"%@",_tuijianrenshoujihao.text);
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];
    [_telephone_textfield resignFirstResponder];
    [_connect_people_textfield resignFirstResponder];
    [_password_confirm_textfield resignFirstResponder];
    [_password_textfield resignFirstResponder];
    [_heck_code_textfield resignFirstResponder];
    if ([_telephone_textfield.text isEqual:@""]) {
         [RKDropdownAlert title:@"提示: 请输入电话好码" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    if ([_connect_people_textfield.text isEqual:@""]){
        [RKDropdownAlert title:@"提示: 请输入联系人" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
        
    }
    if ([_password_textfield.text isEqual:@""]){
        [RKDropdownAlert title:@"提示: 请输入密码" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
        
    }
    if ([_password_confirm_textfield.text isEqual:@""]){
        [RKDropdownAlert title:@"提示: 请输入确认密码" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
        
    }
    if (![_password_confirm_textfield.text isEqual:_password_textfield.text]) {
        
       
        [RKDropdownAlert title:@"提示: 两次输入的密码不一致" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
        
    }
    if (_protocol_button_state==NO) {
        [RKDropdownAlert title:@"提示: 请先阅读二手车协议" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    if ( _recommand_button_state==YES) {
        if (_tuijianrenshoujihao.text==nil) {
            
        [RKDropdownAlert title:@"提示: 请填写推荐人电话" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    }

    if ([_heck_code_textfield.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding]!=4) {
        [RKDropdownAlert title:@"提示: 验证码格式错误" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    else{
        [SMS_SDK commitVerifyCode:self.heck_code_textfield.text result:^(enum SMS_ResponseState state) {
//            self.verfyCode.text这里传的是获取到的验证码，可以把获取到的验证码填写在文本框里面，然后获取到文本框里面的值传进参数里
            if (state==1) {
                NSLog(@"%@",self.telephone_textfield.text);
                BmobUser *bUser = [[BmobUser alloc] init];
                [bUser setUserName:self.telephone_textfield.text];
//                [bUser setObject:self.telephone_textfield.text forKey:@"username"];
               
                [bUser setPassword:self.password_confirm_textfield.text];
                [bUser setObject:self.connect_people_textfield.text forKey:@"contact"];
                [bUser setObject:[NSNumber numberWithBool:0] forKey:@"isAdmin"];
                [bUser setObject:@"" forKey:@"sign"];
                [bUser setObject:_tuijianrenshoujihao.text forKey:@"invationName"];
                [bUser setObject:@"IOS" forKey:@"from"];
                [bUser setObject:[NSNumber numberWithInt:0] forKey:@"rateServe"];
                [bUser setObject:[NSNumber numberWithInt:0] forKey:@"rateDes"];
                [bUser setObject:[NSNumber numberWithInt:0] forKey:@"rateMain"];
                [bUser setObject:[NSNumber numberWithInt:0] forKey:@"commentNum"];
                [bUser setObject:[NSNumber numberWithInt:0] forKey:@"fundMoney"];
                [bUser setObject:[NSNumber numberWithBool:0] forKey:@"hasLock"];
                [bUser setObject:[NSNumber numberWithBool:0] forKey:@"hasPayFund"];
                 [bUser setObject:[NSNumber numberWithInt:0] forKey:@"money"];

                
                [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
                    if (isSuccessful){
                        [RKDropdownAlert title:@"恭喜: 您已经注册成功" backgroundColor:[UIColor greenColor] textColor:[UIColor whiteColor] time:1];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        NSLog(@"%@",error);
                        [RKDropdownAlert title:@"注册失败:手机号已经被注册!" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
                        
                    }
                }];
                NSLog(@"验证成功");
            } else if (state==0){
                [RKDropdownAlert title:@"验证失败" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
                NSLog(@"验证失败");
            }
        }];
        
    }
        
}
@end
