//
//  QvXianViewController.m
//  TXCar
//
//  Created by jack on 15/10/12.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "QvXianViewController.h"
#import "KTActionSheet.h"
#import "RKDropdownAlert.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "SVProgressHUD.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobUser.h>
#import "User.h"
#import "Header.h"
#import "GUAAlertView.h"
#import "MyzhanghuViewController.h"
#import "tixianlishiViewController.h"
@interface QvXianViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *yincang;

@property (weak, nonatomic) IBOutlet UIImageView *tubiao;
@property (weak, nonatomic) IBOutlet UILabel *qwe;
@property (weak, nonatomic) IBOutlet UITextField *zhanghu;
@property (weak, nonatomic) IBOutlet UITextField *jine;
@property(nonatomic,assign)int i;
@property(nonatomic,copy)NSString * mima;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,assign)int panduan;
@end

@implementation QvXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"提现";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提现历史" style:UIBarButtonItemStylePlain target:self action:@selector(perFormAdd)];
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults  standardUserDefaults];
    _mima=[userDefaults objectForKey:@"password"];
    NSLog(@"%@",_mima);
    _i=1;
    [_zhanghu setBorderStyle:UITextBorderStyleNone];
    _zhanghu.clearsOnBeginEditing = YES;
    _zhanghu.placeholder = @"请输入支付宝或微信取现账户";
    _zhanghu.textColor=[UIColor blackColor];
    
    [_jine setBorderStyle:UITextBorderStyleNone];
    _jine.clearsOnBeginEditing = YES;
   
   
   
    _jine.textColor=[UIColor blackColor];
    
//    [_zhanghu addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
//    [_jine addTarget:self action:@selector(textFieldChanged1:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)textFieldChanged:(UITextField*)asd{
//    NSLog(@"%@",asd.text);
//}
//-(void)textFieldChanged1:(UITextField*)asd{
//    
//}


-(void)viewWillAppear:(BOOL)animated{
    NSString * userid=[[BmobUser getCurrentUser]objectId];
    
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"objectId" equalTo:userid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobUser *user in array) {
            
            NSString *str = [[user objectForKey:@"money"] stringValue];
            
            _panduan=[str intValue];
            
            _jine.placeholder=[NSString stringWithFormat:@"您的账户余额:%@元",str];
            
        }
        
    }];

}


- (IBAction)dianji:(UIButton *)sender {
    KTActionSheet * actionSheet2 = [[KTActionSheet alloc] initWithTitle:@"" itemTitles:@[@"微信",@"支付宝"]];
    actionSheet2.delegate = self;
    actionSheet2.tag = 100;
    NSLog(@"123123");
    __weak typeof(self) weakSelf = self;
    [actionSheet2 didFinishSelectIndex:^(NSInteger index, NSString *title) {
        if([title isEqual:@"微信"]){
            _tubiao.image=[UIImage imageNamed:@"tixian_tanchuweixin"];
            _yincang.hidden=YES;
            _type=@"wepay";
            _i=2;
        }
        if([title isEqual:@"支付宝"]){
            _tubiao.image=[UIImage imageNamed:@"tixian_tanchukuangzhi"];
            _yincang.hidden=YES;
             _type=@"alipay";
            _i=2;
        }
        weakSelf.qwe.text=title;
    }];

}
- (IBAction)dianji1:(UIButton *)sender {
    [_zhanghu resignFirstResponder];
    [_jine resignFirstResponder];
    
    if([_zhanghu.text isEqual:@""]){
        [RKDropdownAlert title:@"提示: 请输入取现账户" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    if([_jine.text isEqual:@""]){
        [RKDropdownAlert title:@"提示: 请输入取现金额" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    if(_i==1){
        [RKDropdownAlert title:@"提示: 请选择取现类型" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    
    if( [_jine.text intValue]>_panduan){
        [RKDropdownAlert title:@"提示: 请输入的取现金额大于您的账户余额" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }

    
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请输入同行车账户登录密码." message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [dialog textFieldAtIndex:0];
    [dialog show];

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        if(alertView.tag==111){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%d",KEFU_PHONE]]];
        }
    }
    
    
    UITextField *nameField = [alertView textFieldAtIndex:0];
    [nameField resignFirstResponder];
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        if([nameField.text isEqual:_mima]){
            [SVProgressHUD showWithStatus:@"请稍后"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
            
            NSDictionary *parameters = @{@"userId":[[BmobUser getCurrentUser]objectId],@"money":_jine.text,@"phone":[[BmobUser getCurrentUser]username],@"contact":[[BmobUser getCurrentUser]objectForKey:@"contact"],@"type":_type,@"account":_zhanghu.text};
            [manager POST:@"http://tonghangche.com/system/mobile/saveNewGetMoney"parameters:parameters
                  success:^(AFHTTPRequestOperation *operation,id responseObject) {
                      NSData *doubi = responseObject;
                      NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:doubi options:NSJSONReadingMutableLeaves error:nil];
                      NSString *weatherInfo = [weatherDic objectForKey:@"code"];
                     
                      if([weatherInfo intValue]==1){
                          
                      [self gengxinmaijiazhanghu:-[_jine.text intValue]];
                      
                     
                      }else {
                          [SVProgressHUD dismiss];
                           [RKDropdownAlert title:@"!提交失败:服务器异常!" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
                      }

   
                  }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
                      NSLog(@"~~~~~~~~~~~%@~~~~~~~~~~~~~",error);
                      [SVProgressHUD dismiss];
                      [RKDropdownAlert title:@"提交失败:服务器异常" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
                      
                  }
             
             ];

        }else{
            [RKDropdownAlert title:@"提交失败:密码错误(请退出后重新登录)" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
        }
        
        
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_zhanghu   resignFirstResponder];
    [_jine resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, 0);
    }];
}


-(void)perFormAdd{
    tixianlishiViewController *cac=[self.storyboard instantiateViewControllerWithIdentifier:@"qvxianlishi"];
    [self.navigationController pushViewController:cac animated:YES];
    
}

-(void)gengxinmaijiazhanghu:(int)asd{
    
    NSLog(@"%@",[[BmobUser getCurrentUser]username]);
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:[[BmobUser getCurrentUser]username],@"username",[NSString stringWithFormat:@"%d",asd],@"money", nil];
    
    [BmobCloud callFunctionInBackground:@"updateSalerMoney" withParameters:dic2 block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"error--------- %@",[error description]);
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"取现失败"];
        }
        NSLog(@"扣了当前用户20金");
        [self gengxinmingxi];
    }] ;
}


-(void)gengxinmingxi{
    BmobObject  *gameScore = [BmobObject objectWithClassName:@"AcountBean"];
  //]  User *user = [User objectWithoutDatatWithClassName:@"User" objectId:[BmobUser getCurrentUser];
  
    [gameScore setObject:[BmobUser getCurrentUser] forKey:@"aUser"];
    [gameScore setObject:[[BmobUser getCurrentUser]objectId] forKey:@"userId"];
    [gameScore setObject:[NSNumber numberWithInt:-1] forKey:@"type"];
    [gameScore setObject:[NSNumber numberWithInt:-[_jine.text intValue]] forKey:@"money"];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [SVProgressHUD dismiss];

            [self.delegate changeText:_jine.text];
        
          [self performSegueWithIdentifier:@"qvxian_lishi" sender:self];
            NSLog(@"这一步更新明细表的~取现金~");
        } else if (error){
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"取现失败"];
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
    
}
- (IBAction)huiqv:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)kefu:(UIButton *)sender {
    GUAAlertView *v = [GUAAlertView alertViewWithTitle:@"联系客服"
                       
                                               message:@"请加入该群反馈相关问题:\n\nQQ群:155305793"
                       
                                           buttonTitle:@"一键加群"
                       
                                   buttonTouchedAction:^{
                                       
                                       [self joinGroup:nil key:nil];
                                       NSLog(@"button touched");
                                       
                                   } dismissAction:^{
                                       
                                       NSLog(@"dismiss");
                                       
                                   }];
    [v show];
    

}

- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"155305793",@"73c08e8576e6d73e4a4317ab0b530e48bece5477cf73fc17052c7e939c49df17"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
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
