//
//  ChongZhiViewController.m
//  TXCar
//
//  Created by jack on 15/10/12.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "ChongZhiViewController.h"
#import "Pingpp.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobUser.h>
#import "Header.h"
#import "ReserveCar.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#define kServerUrl @"http://tonghangche.com/system/mobile/pay"
@interface ChongZhiViewController ()
@property (weak, nonatomic) IBOutlet UITextField *chongjinjine;
@property(nonatomic,assign)int jine;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSArray * contents;
@end

@implementation ChongZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [Pingpp enableBtn:PingppBtnAlipay|PingppBtnWx];
    UITapGestureRecognizer *blankTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleBlankTap:)];
    [self.view addGestureRecognizer:blankTap];
     [_chongjinjine setBorderStyle:UITextBorderStyleNone];
     _chongjinjine.clearsOnBeginEditing = YES;
    _chongjinjine.placeholder = @"请输入充值金额";
    _chongjinjine.textColor=[UIColor blackColor];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleBlankTap:(UITapGestureRecognizer *)recognizer {
    if ([self chongjinjine]) {
        [[self chongjinjine] resignFirstResponder];
    }
}



- (IBAction)dianji:(UIButton *)sender {
    NSDate *date1 = [NSDate date];
    //然后您需要定义一个NSDataFormat的对象
    NSDateFormatter * dateFormat = [[NSDateFormatter alloc]init];
    //然后设置这个类的dataFormate属性为一个字符串，系统就可以因此自动识别年月日时间
    dateFormat.dateFormat = @"yyyyMMddHHmm";
    //之后定义一个字符串，使用stringFromDate方法将日期转换为字符串
    NSString * dateToString = [dateFormat stringFromDate:date1];
    //打印结果就是当前日期了
   AppDelegate * app=[[UIApplication sharedApplication]delegate];
    app.qianqianqian=_chongjinjine.text;
    NSLog(@"dateToString:%@",dateToString);
    _orderNo = [NSString stringWithFormat:@"%@%@",dateToString,[[BmobUser getCurrentUser]username]];
    
    [Pingpp enableBtn:PingppBtnAlipay|PingppBtnWx];

    [Pingpp payWithOrderNo:_orderNo
                    amount: [_chongjinjine.text intValue]*100
                   display:@[
                             @[
                                 @"商品", @[@"账户充值"]
                                 ]
                           
                             ]
     
                 serverURL:kServerUrl
      appURLScheme:@"wx95f441be59f7752f"
         completionHandler:^(NSString *result, PingppError *error) {

         }];
    
}

//
//- (BOOL)application:(UIApplication *)application   openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    [Pingpp handleOpenURL:url withCompletion:nil];
//    return YES;
//}



//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    NSLog(@"333333%@",url);
//    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
//        if ([result isEqualToString:@"success"]) {
//            NSLog(@"祝福成功");
//            [SVProgressHUD showWithStatus:@"请稍后"];
//            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
//            
//            NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:[[BmobUser getCurrentUser]username],@"username",[NSString stringWithFormat:@"%@",_chongjinjine.text],@"money", nil];
//            
//            [BmobCloud callFunctionInBackground:@"updateSalerMoney" withParameters:dic2 block:^(id object, NSError *error) {
//                if (error) {
//                    NSLog(@"error--------- %@",[error description]);
//                }
//                NSLog(@"充值了这么多钱%@",_chongjinjine.text);
//                [self querendingdanmingxi];
//            }] ;
// 
//        } else {
//            // 支付失败或取消
//            [SVProgressHUD showInfoWithStatus:@"充值失败"];
//            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
//            NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
//        }
//    }];
//    return  YES;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self setChongjinjine:nil];
    if ([[textField text] length] == 0) {
        [textField setText:@"0"];
    }
    
}

-(void)querendingdanmingxi{
    BmobObject  *gameScore = [BmobObject objectWithClassName:@"AcountBean"];
    User *user = [User objectWithoutDatatWithClassName:@"User" objectId:[[BmobUser getCurrentUser]objectForKey:@"objectId"]];
    [gameScore setObject:user forKey:@"aUser"];
    [gameScore setObject:[[BmobUser getCurrentUser]objectId] forKey:@"userId"];
    
    [gameScore setObject:[NSNumber numberWithInt:(int)_chongjinjine.text] forKey:@"money"];
    [gameScore setObject:[NSNumber numberWithInt:FLAG_PAY] forKey:@"type"];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"这一步更新明细表的~充值多少钱~");
            [SVProgressHUD dismiss];
            [self.navigationController popViewControllerAnimated:YES];
        } else if (error){
            
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
}






- (IBAction)huiqv:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)kufu:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否联系客服?" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",@"取消", nil];
    alert.tag=111;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        if(alertView.tag==111){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%d",KEFU_PHONE]]];
        }
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
