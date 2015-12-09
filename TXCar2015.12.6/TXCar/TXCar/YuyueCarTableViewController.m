//
//  YuyueCarTableViewController.m
//  TXCar
//
//  Created by MacBooK Pro on 15/10/6.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import "YuyueCarTableViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobUser.h>
#import "UUDatePicker.h"
#import "Header.h"
#import "User.h"
#import "RKDropdownAlert.h"
#import "SVProgressHUD.h"
#import "RSKImageCropViewController.h"
#import "UzysAssetsPickerController.h"
#import "GUAAlertView.h"
#import "ZhifuCarTableViewController.h"
@interface YuyueCarTableViewController ()
{
    UITextField *SpecifiedTime;
}
@property (weak, nonatomic) IBOutlet UITextField *YMD;

@property (weak, nonatomic) IBOutlet UITextField *lianxiren;
@property (weak, nonatomic) IBOutlet UITextField *lianxidianhua;

@end

@implementation YuyueCarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"预约车辆";
    UUDatePicker *datePicker
    = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, 320, 200)
                             PickerStyle:1
                             didSelected:^(NSString *year,
                                           NSString *month,
                                           NSString *day,
                                           NSString *hour,
                                           NSString *minute,
                                           NSString *weekDay) {
                                 
                                 
                                 _YMD.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
                                 NSLog(@"%@",_YMD.text);
                             }];
    _YMD.inputView = datePicker;

    _lianxiren.text=[[BmobUser getCurrentUser]objectForKey:@"contact"];
    _lianxidianhua.text=[[BmobUser getCurrentUser]objectForKey:@"username"];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }else{
        return 4;
    }
    
}


- (IBAction)tijiaodingdan:(UIButton *)sender {
    if ([_lianxiren isEqual:@""]) {
        [RKDropdownAlert title:@"提示: 请选择填写联系人" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    if ([_lianxidianhua isEqual:@""]) {
        [RKDropdownAlert title:@"提示: 请选择填写联系人电话" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    if ([_YMD.text isEqual:@""]) {
        [RKDropdownAlert title:@"提示: 请选择填写看车时间" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    


    BmobObject *bmobject = [BmobObject objectWithClassName:@"ReserveCar"];
    [bmobject setObject:[NSNumber numberWithInt:RESERVE_SEE_CAR] forKey:@"state"];
    [bmobject setObject:_YMD.text forKey:@"sDate"];
     CarDetail *car = [CarDetail objectWithoutDatatWithClassName:@"CarDetail" objectId:_models.objectId];
        [bmobject setObject:car forKey:@"sCar"];
    User *user = [User objectWithoutDatatWithClassName:@"User" objectId:[[BmobUser getCurrentUser]objectForKey:@"objectId"]];
    [bmobject setObject:user forKey:@"sUser"];
    [bmobject setObject:_models.cUser forKey:@"carUser"];
//     [bmobject setObject:[[BmobUser getCurrentUser]objectForKey:@"objectId"] forKey:@"state"];
    [bmobject setObject:[[BmobUser getCurrentUser]objectForKey:@"contact"] forKey:@"sContact"];
    [bmobject setObject:[[BmobUser getCurrentUser]objectForKey:@"username"] forKey:@"sPhone"];
    [bmobject setObject:[[BmobUser getCurrentUser]objectForKey:@"objectId"] forKey:@"seeUserId"];
    [bmobject setObject:_facherenId forKey:@"carUserId"];
    
    [bmobject saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error){
        if (isSuccessful) {
            //添加成功后的动作
            NSLog(@"上传成功");
            ZhifuCarTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"zhifu_xinxi2"];
            detail.name=_models.carInfo;
            detail.cheId=_models.objectId;
            detail.contactName=_models.contactName;
                 detail.contactPhone=_models.contactPhone;
            detail.stateid=bmobject.objectId;
            //    NSLog(@"%@",_models.carInfo);
            //     NSLog(@"1%@", detail.name);
            detail.jiage=[NSString stringWithFormat:@"%.f",_models.carPrice];
            detail.chemingzi=_models.carInfo;
            [self.navigationController pushViewController:detail animated:YES];
//            
        } else if (error){
            //发生错误后的动作
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        return 10;
    }else if(indexPath.section==0&&indexPath.row==1){
        return 40;
    }else if(indexPath.section==1&&indexPath.row==0){
        return 10;
    }else if(indexPath.section==1&&indexPath.row==1){
        return 70;
    }else if(indexPath.section==1&&indexPath.row==2){
        return 55;
    }else{
        return [UIScreen mainScreen].bounds.size.height-185-64;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_YMD resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (IBAction)lainxikefu:(UIButton *)sender {
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

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//     if(buttonIndex==0){
//         if(alertView.tag==111){
//          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%d",KEFU_PHONE]]];   
//         }
//     }
//}



//加qq群
- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", @"155305793",@"73c08e8576e6d73e4a4317ab0b530e48bece5477cf73fc17052c7e939c49df17"];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}


@end
