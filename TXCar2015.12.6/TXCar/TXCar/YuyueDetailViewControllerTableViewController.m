//
//  YuyueDetailViewControllerTableViewController.m
//  TXCar
//
//  Created by jack on 15/10/14.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "YuyueDetailViewControllerTableViewController.h"
#import "UIImageView+WebCache.h"
#import "Header.h"
#import "GUAAlertView.h"
#import <BmobSDK/Bmob.h>
#import "FDAlertView.h"
#import <BmobSDK/BmobUser.h>
#import "SVProgressHUD.h"
#import "YuyueViewController.h"
#import "YuyuemaiViewController.h"
#import "pinglunTableViewController.h"
#import "ChatViewController.h"
#import "GUAAlertView.h"
@interface YuyueDetailViewControllerTableViewController ()<UIAlertViewDelegate,FDAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nana;
@property (weak, nonatomic) IBOutlet UILabel *zhuangtai;
@property (weak, nonatomic) IBOutlet UIImageView *tupian;
@property (weak, nonatomic) IBOutlet UILabel *cheming;
@property (weak, nonatomic) IBOutlet UILabel *gonglishu;
@property (weak, nonatomic) IBOutlet UILabel *shijian;
@property (weak, nonatomic) IBOutlet UILabel *jiage;
@property (weak, nonatomic) IBOutlet UILabel *dashijian;
@property (weak, nonatomic) IBOutlet UIImageView *tupian2;
@property (weak, nonatomic) IBOutlet UIButton *l1;
@property (weak, nonatomic) IBOutlet UIButton *l2;
@property (weak, nonatomic) IBOutlet UIButton *l3;
@property (weak, nonatomic) IBOutlet UIButton *querengouche;
@property (weak, nonatomic) IBOutlet UIButton *querendingdan;
@property (weak, nonatomic) IBOutlet UIButton *pinglun;


@property (weak, nonatomic) IBOutlet UIButton *zaixiangoutong;
@property (weak, nonatomic) IBOutlet UIButton *dianhuagoutong;

@property (weak, nonatomic) IBOutlet UILabel *kancheriqi;
@property (weak, nonatomic) IBOutlet UITextView *xiangqing;
@property (weak, nonatomic) IBOutlet UILabel *shijian3;

@end

@implementation YuyueDetailViewControllerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"订单详情";
//    NSLog(@"%@",[[[_model1 objectForKey:@"sCar"]objectForKey:@"cUser"]objectForKey:@"username"]);
//    NSLog(@"%@",[[_model1 objectForKey:@"sUser"]username]);
    _querendingdan.hidden=YES;
    _querengouche.hidden=YES;
    _pinglun.hidden=YES;
    if(_taggg==1){
    if ([[_model1 objectForKey:@"state"]intValue] == RESERVE_PAYED) {
        _xiangqing.text=@"您已经预付定金，并锁定了该车辆，卖家确认并交纳保证金后你们就可以进行协商看车了，为了尽快看车请您尽快和商家进行联系！";
    }
    if ([[_model1 objectForKey:@"state"]intValue] == RESERVE_SALER_SURE) {
        _xiangqing.text=@"卖家已确认订单，您可以和卖家协商进行线下看车了，请在看车时仔细查看车况，确认无误后请进入此页面进行确认订单！若有问题可取消订单，看车日期超出7天后若无操作，定金自动打入卖家账户！";
        _l3.hidden=YES;
        _querengouche.hidden=NO;
        
    }
    if ([[_model1 objectForKey:@"state"]intValue] == RESERVE_SUCCED) {
        _xiangqing.text=@"恭喜您已转车成功，您可以对卖家服务进行评价！感谢您信任同行车平台！";
    }
    if ([[_model1 objectForKey:@"state"]intValue] == RESERVE_BUYER_CANCLE_PAYED) {
        _xiangqing.text=@"您已取消了订单，您的定金1000元已经返还到您的同行车账户，请到账户中心查看！";
    }
    if ([[_model1 objectForKey:@"state"]intValue] == RESERVE_BUYER_CANCLE_SEE) {
        _xiangqing.text=@"您已取消了订单，您的定金（扣除200元手续费）已经返还到您的同行车账户，请到账户中心查看！";
    }
    if ([[_model1 objectForKey:@"state"]intValue] == RESERVE_SALER_CANCLE_SURE) {
        _xiangqing.text=@"非常抱歉！卖家取消了订单，您的定金1000已经返还到您的同行车账户，请到账户中心查看！";
    }
    if ([[_model1 objectForKey:@"state"]intValue] == RESERVE_SALER_CANCLE_SEE) {
        _xiangqing.text=@"非常抱歉！卖家取消了了订单，您的定金（扣除200元手续费）已经返还到您的同行车账户，请到账户中心查看！";
    }
    }else{
        if ([[_model1 objectForKey:@"state"]intValue] == RESERVE_PAYED) {
            _l3.hidden=YES;
            _querendingdan.hidden=NO;
            
            _xiangqing.text=[NSString stringWithFormat:@"买家已预付定金，请您及时确认订单，为了保证买家定金安全和您的信誉，您需要预付%d元保证金，待交易完毕后系统会自动返还！",RESERVE_ORDER_BAOZHENGJIN_MONEY];
        }
        if ([[_model1 objectForKey:@"state"]intValue] == RESERVE_SALER_SURE) {
            _xiangqing.text=@"您已确认订单，您可以和买家协商进行线下看车了，请在看车时待买家确认购车后务必让买家进行确认购车进行定金转账，买家预付定金将会直接打入您的账户！";
        }
        if ([[_model1 objectForKey:@"state"]intValue] == RESERVE_SUCCED) {
            _xiangqing.text=@"恭喜您已转车成功，对方的预付定金将抵扣相当金额的购车款，已打入您的账户！感谢您信任同行车平台！";
        }
        if ([[_model1 objectForKey:@"state"]intValue] == RESERVE_BUYER_CANCLE_PAYED) {
            _xiangqing.text=@"非常抱歉！买家取消了订单，您的保证金（扣除0元手续费）已经返还到您的同行车账户，请到账户中心查看！";
        }
        if ([[_model1 objectForKey:@"state"]intValue] == RESERVE_BUYER_CANCLE_SEE) {
            _xiangqing.text=@"非常抱歉！买家取消了订单，您的保证金（扣除200元手续费）已经返还到您的同行车账户，请到账户中心查看！";
        }
        if ([[_model1 objectForKey:@"state"]intValue] == RESERVE_SALER_CANCLE_SURE) {
            _xiangqing.text=@"您已取消了订单，您的保证金（扣除0元手续费）已经返还到您的同行车账户，请到账户中心查看！";
        }
        if ([[_model1 objectForKey:@"state"]intValue] == RESERVE_SALER_CANCLE_SEE) {
            _xiangqing.text=@"您已取消了订单，您的保证金（扣除200元手续费）已经返还到您的同行车账户，请到账户中心查看！";
        }

    }

    [_zaixiangoutong.layer setMasksToBounds:YES];
    [_zaixiangoutong.layer setCornerRadius:8.0]; //设置矩圆角半径
    [_zaixiangoutong.layer setBorderWidth:1.0];   //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 00.4, 00.3, 00.7, 00.3 });
    [_zaixiangoutong.layer setBorderColor:colorref];//边框颜色
    
    [_dianhuagoutong.layer setMasksToBounds:YES];
    [_dianhuagoutong.layer setCornerRadius:8.0]; //设置矩圆角半径
    [_dianhuagoutong.layer setBorderWidth:1.0];   //边框宽度
    CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref1 = CGColorCreate(colorSpace1,(CGFloat[]){ 00.4, 00.3, 00.7, 00.3 });
    [_dianhuagoutong.layer setBorderColor:colorref1];//边框颜色
    
    
    _kancheriqi.text=[NSString stringWithFormat:@"预约%@日看车",[_model1 objectForKey:@"sDate"]];
 //   NSLog(@"%d",_taggg);
    if(_taggg==1){
        _nana.text=[NSString stringWithFormat:@"卖车人:%@",[[_model1 objectForKey:@"sCar"]objectForKey:@"contactName"]];
        
    }else{
        NSLog(@"%@",[_model1 objectForKey:@"sContact"]);
         _nana.text=[NSString stringWithFormat:@"买车人:%@",[_model1 objectForKey:@"sContact"]];
    }
    if([[_model1 objectForKey:@"state"]intValue] == 2){
        _zhuangtai.text=@"已付定金,等待商家确认";
    }
    if([[_model1 objectForKey:@"state"]intValue]==3){
        _zhuangtai.text=@"卖家已确认";
    }
    if([[_model1 objectForKey:@"state"]intValue] == 4){
        _zhuangtai.text=@"转车成功";
    }
    if([[_model1 objectForKey:@"state"] intValue]==12){
      _zhuangtai.text=@"买家取消订单";
    }
    if([[_model1 objectForKey:@"state"] intValue]==13){
        _zhuangtai.text=@"买家取消看车";
    }
    if([[_model1 objectForKey:@"state"] intValue]==22){
        _zhuangtai.text=@"卖家取消订单";
    }
    if([[_model1 objectForKey:@"state"] intValue]==23){
       _zhuangtai.text=@"卖家取消看车";
    }


    NSURL *URL = [NSURL URLWithString:[[_model1 objectForKey:@"sCar"]objectForKey:@"carPic"]];
    [_tupian sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"loading-image"]];
    
    if ([[_model1 objectForKey:@"state"]intValue] == 4){
      
        _tupian2.image=[UIImage imageNamed:@"yufudingj"];
        
    }else if ([[_model1 objectForKey:@"state"]intValue] == 2){
        
        _tupian2.image=[UIImage imageNamed:@"yufudingjina"];
    }

    else if ([[_model1 objectForKey:@"state"]intValue] == 3){
 
        _tupian2.image=[UIImage imageNamed:@"yufudingji"];
    }
    else if ([[_model1 objectForKey:@"state"]intValue] == 12){
        
        _tupian2.image=[UIImage imageNamed:@"yufudingjina"];
    }else if ([[_model1 objectForKey:@"state"]intValue] == 13){
        _tupian2.image=[UIImage imageNamed:@"yufudingji"];
    }
    else if ([[_model1 objectForKey:@"state"]intValue] == 22){
        
        _tupian2.image=[UIImage imageNamed:@"yufudingjina"];
    }else if ([[_model1 objectForKey:@"state"]intValue] == 23){
        _tupian2.image=[UIImage imageNamed:@"yufudingji"];
    }
    
 
    _cheming.text=[[_model1 objectForKey:@"sCar"]objectForKey:@"carInfo"];

    
    
    NSString * bbb=[NSString stringWithFormat:@"%@",[[_model1 objectForKey:@"sCar"]objectForKey:@"carDistance"]];
    NSString * bbbb=[bbb stringByAppendingString:@"万公里 /"];
    _gonglishu.text=bbbb;
    
    
    
    NSString * create_date=[NSString stringWithFormat:@"%@", [[_model1 objectForKey:@"sCar"] updatedAt]];
    NSString * create_date1=[create_date substringWithRange:NSMakeRange(5, 5)];
    
    NSString * aaaa=[create_date1 stringByAppendingString:[[_model1 objectForKey:@"sCar"]objectForKey:@"carLocation"]];
    _dashijian.text=aaaa;
    
    NSString * ccc=[NSString stringWithFormat:@"%@",[[_model1 objectForKey:@"sCar"]objectForKey:@"carPrice" ]];
    NSString * cccc=[ccc stringByAppendingString:@"万元"];
    _jiage.text=cccc;
    
    NSString * ns=[[[_model1 objectForKey:@"sCar"]objectForKey:@"carYearCheck"] substringToIndex:4];
    _shijian.text=ns;
    
    
    if ([[_model1 objectForKey:@"state"]intValue] == 4) {

        _l1.layer.cornerRadius = 8;
        _l1.layer.masksToBounds = YES;
        _l1.hidden=YES;
        
       
       _l2.layer.cornerRadius = 8;
        _l2.layer.masksToBounds = YES;
        _l2.hidden=YES;
      
        _l3.layer.cornerRadius = 8;
        _l3.layer.masksToBounds = YES;
        _l3.hidden=NO;
        if(_taggg==1){
            _pinglun.hidden=NO;
        }else{
        _pinglun.hidden=YES;
        }
    }else if ([[_model1 objectForKey:@"state"]intValue] == 12){
        
        
        _l1.layer.cornerRadius = 8;
        _l1.layer.masksToBounds = YES;
        _l1.hidden=YES;
        _l2.layer.cornerRadius = 8;
        _l2.layer.masksToBounds = YES;
        _l2.hidden=YES;
        _l3.layer.cornerRadius = 8;
        _l3.layer.masksToBounds = YES;
        _l3.hidden=NO;
        if(_taggg==1){
            _pinglun.hidden=NO;
        }else{
            _pinglun.hidden=YES;
        }

    }
    else if ([[_model1 objectForKey:@"state"]intValue] == 13){
        
        
        _l1.layer.cornerRadius = 8;
        _l1.layer.masksToBounds = YES;
        _l1.hidden=YES;
        _l2.layer.cornerRadius = 8;
        _l2.layer.masksToBounds = YES;
        _l2.hidden=YES;
        _l3.layer.cornerRadius = 8;
        _l3.layer.masksToBounds = YES;
        _l3.hidden=NO;
        if(_taggg==1){
            _pinglun.hidden=NO;
        }else{
            _pinglun.hidden=YES;
        }

    }else if ([[_model1 objectForKey:@"state"]intValue] == 22){
        
        
        
        _l1.layer.cornerRadius = 8;
        _l1.layer.masksToBounds = YES;
        _l1.hidden=YES;
        _l2.layer.cornerRadius = 8;
        _l2.layer.masksToBounds = YES;
        _l2.hidden=YES;
        _l3.layer.cornerRadius = 8;
        _l3.layer.masksToBounds = YES;
        _l3.hidden=NO;
        
    }
    else if ([[_model1 objectForKey:@"state"]intValue] == 23){
        
        
        
        _l1.layer.cornerRadius = 8;
        _l1.layer.masksToBounds = YES;
        _l1.hidden=YES;
        _l2.layer.cornerRadius = 8;
        _l2.layer.masksToBounds = YES;
        _l2.hidden=YES;
        _l3.layer.cornerRadius = 8;
        _l3.layer.masksToBounds = YES;
        _l3.hidden=NO;
        
    }else if([[_model1 objectForKey:@"state"]intValue] == 2){
        
        _l1.layer.cornerRadius = 8;
        _l1.layer.masksToBounds = YES;
        _l1.hidden=NO;
        _l2.layer.cornerRadius = 8;
        _l2.layer.masksToBounds = YES;
        _l2.hidden=NO;
        _l3.layer.cornerRadius = 8;
        _l3.layer.masksToBounds = YES;
        _l3.hidden=NO;
    }else if([[_model1 objectForKey:@"state"]intValue] == 3){
        
        _l1.layer.cornerRadius = 8;
        _l1.layer.masksToBounds = YES;
        _l1.hidden=NO;
        _l2.layer.cornerRadius = 8;
        _l2.layer.masksToBounds = YES;
        _l2.hidden=NO;
        _l3.layer.cornerRadius = 8;
        _l3.layer.masksToBounds = YES;
        _l3.hidden=NO;
    }
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated{
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"ReserveCar"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:[_model1 objectId] block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                //得到playerName和cheatMode
                if([[object objectForKey:@"commentId"]length]>0){
                    _pinglun.hidden=YES;
                }
            }
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (IBAction)lainxiTA:(UIButton *)sender {
    if(_taggg==1){
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"拨打电话:%@",[[_model1  objectForKey:@"sCar"]objectForKey:@"contactName"]] message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认拨打", nil];
        alert.tag=1;
        [alert show];
    }else{
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"拨打电话:%@",[_model1 objectForKey:@"sContact"]] message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认拨打", nil];
        alert.tag=1;
        [alert show];
    }

    
}

- (IBAction)dadianhua1:(UIButton *)sender {
    if(_taggg==1){
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"拨打电话:%@",[[_model1  objectForKey:@"sCar"]objectForKey:@"contactName"]] message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认拨打", nil];
    alert.tag=1;
    [alert show];
    }else{
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"拨打电话:%@",[_model1 objectForKey:@"sContact"]] message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认拨打", nil];
        alert.tag=1;
        [alert show];
    }
}

-(void)gengxinmaijiazhanghu:(int)asd
{
     NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:[[_model1 objectForKey:@"sUser"]username],@"username",[NSString stringWithFormat:@"%d",asd],@"money", nil];
 
    [BmobCloud callFunctionInBackground:@"updateSalerMoney" withParameters:dic2 block:^(id object, NSError *error) {
        if (error) {
            
            NSLog(@"error--------- %@",[error description]);
             return ;
        }
        NSLog(@"这步给这个账户返还了1000定金");
        [self gengxinSTATE];
    }] ;

}


-(void)gengxinmaijiazhanghu1:(int)asd
{
    NSLog(@"!!!!!!!%@",[[_model1 objectForKey:@"carUser"]username]);
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:[[_model1 objectForKey:@"carUser"]username],@"username",[NSString stringWithFormat:@"%d",asd],@"money", nil];
    
    [BmobCloud callFunctionInBackground:@"updateSalerMoney" withParameters:dic2 block:^(id object, NSError *error) {
        if (error) {
            return ;
        }
          NSLog(@"这步更新了另一个退得800块钱");
        [self gengxinSTATE];
    }] ;
    
}

-(void)gengxinmaijiazhanghu2:(int)asd
{
    NSLog(@"$$$$$$$%@",[[_model1 objectForKey:@"sUser"]username]);
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:[[_model1 objectForKey:@"sUser"]username],@"username",[NSString stringWithFormat:@"%d",asd],@"money", nil];
    
    [BmobCloud callFunctionInBackground:@"updateSalerMoney" withParameters:dic2 block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"error--------- %@",[error description]);
        }else{
        NSLog(@"这步更新了退得800块钱");
          [self gengxinmaijiazhanghu1:800];
        }
    }] ;
    
}
//更新卖家的去人订单的钱
-(void)gengxinquerendingdan:(int)asd{
    
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:[[_model1 objectForKey:@"carUser"]username],@"username",[NSString stringWithFormat:@"%d",asd],@"money", nil];
    
    [BmobCloud callFunctionInBackground:@"updateSalerMoney" withParameters:dic2 block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"error--------- %@",[error description]);
            return ;
        }else{
        NSLog(@"这步更新了卖家保证金-1000块钱");
        [self querendingdanmingxi];
        }
     }] ;
}
//确认购车
-(void)gengxinmaijiazhanghu1600:(int)asd
{
    NSLog(@"%@",[[_model1 objectForKey:@"carUser"]objectForKey:@"username"]);
     NSLog(@"%@",[[_model1 objectForKey:@"carUser"]username]);
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:[[_model1 objectForKey:@"carUser"]username],@"username",[NSString stringWithFormat:@"%d",asd],@"money", nil];
    
    [BmobCloud callFunctionInBackground:@"updateSalerMoney" withParameters:dic2 block:^(id object, NSError *error) {
        if (error) {
            return ;
        }else{
        NSLog(@"这步更新了另一个退得1600块钱");
        [self gengxinSTATE4];
        }
    }] ;
    
}




//更新卖家确认订单的明细
-(void)querendingdanmingxi{
BmobObject  *gameScore = [BmobObject objectWithClassName:@"AcountBean"];
User *user = [User objectWithoutDatatWithClassName:@"User" objectId:[[BmobUser getCurrentUser]objectForKey:@"objectId"]];
[gameScore setObject:user forKey:@"aUser"];
[gameScore setObject:[[BmobUser getCurrentUser]objectId] forKey:@"userId"];

[gameScore setObject:[NSNumber numberWithInt:-1000] forKey:@"money"];
[gameScore setObject:[NSNumber numberWithInt:FLAG_ORDER_PAY_BAOZHENGJIN] forKey:@"type"];
[gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
    if (isSuccessful) {
        NSLog(@"这一步更新明细表的~缴纳保证金~");
        
        //4修改flag状态
        [self gengxinSTATE3];
    } else if (error){
        
        NSLog(@"%@",error);
    } else {
        NSLog(@"Unknow error");
    }
}];
}
//state改为3
-(void)gengxinSTATE3{
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"ReserveCar"  objectId:[_model1 objectId]];
    
            [bmobObject setObject:[NSNumber numberWithInt:3] forKey:@"state"];
    
    [bmobObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"这一步更新了state的值为3");
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            if(_taggg==1){
                YuyuemaiViewController * a=[[YuyuemaiViewController alloc]init];
                [a setupRefresh];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                YuyueViewController * b=[[YuyueViewController alloc]init];
                [b setupRefresh];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else if (error){
            NSLog(@"%@staet",error);
        } else {
            NSLog(@"UnKnow error");
        }
    }];

}

-(void)gengxinSTATE4{
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"ReserveCar"  objectId:[_model1 objectId]];
 
            [bmobObject setObject:[NSNumber numberWithInt:4] forKey:@"state"];

    [bmobObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [self querengouchemingxi];
        } else if (error){
            NSLog(@"%@tate",error);
        } else {
            NSLog(@"UnKnow error");
        }
    }];
}

//更新买家确认购车的明细
-(void)querengouchemingxi{
    NSLog(@"111%@",[[_model1 objectForKey:@"carUser"]objectForKey:@"objectId"]);
     NSLog(@"222%@",[[_model1 objectForKey:@"carUser"]objectId]);
    
    
    BmobObject  *gameScore = [BmobObject objectWithClassName:@"AcountBean"];
    User *user = [User objectWithoutDatatWithClassName:@"_User" objectId:[[_model1 objectForKey:@"carUser"]objectId]];
    [gameScore setObject:user forKey:@"aUser"];
    [gameScore setObject:[[_model1 objectForKey:@"carUser"]objectId] forKey:@"userId"];
    [gameScore setObject:[NSNumber numberWithInt:1600] forKey:@"money"];
    [gameScore setObject:[NSNumber numberWithInt:FLAG_ORDER_AND_BAOZHENG] forKey:@"type"];
    
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"这一步更新明细表的~1600的事~");
            [self flag4];
        } else if (error){
            
            NSLog(@"%@明细的事",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
}


//更新明细表1000
-(void)gengxinmaijiazhanghumingxi{
    //更新的是第二部的取消退全部定金
    if (_taggg==1) {
    BmobObject  *gameScore = [BmobObject objectWithClassName:@"AcountBean"];
     User *user = [User objectWithoutDatatWithClassName:@"User" objectId:[[BmobUser getCurrentUser]objectForKey:@"objectId"]];
    [gameScore setObject:user forKey:@"aUser"];
    [gameScore setObject:[[BmobUser getCurrentUser]objectId] forKey:@"userId"];
        
         [gameScore setObject:[NSNumber numberWithInt:1000] forKey:@"money"];
             [gameScore setObject:[NSNumber numberWithInt:FLAG_ORDER_BACK_ALL] forKey:@"type"];
     [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"这一步更新明细表的~定金全部退还~");
          
            //4修改flag状态
            [self gengxinFLAG];
        } else if (error){
            
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
    }else{
        BmobObject  *gameScore = [BmobObject objectWithClassName:@"AcountBean"];
        User *user = [User objectWithoutDatatWithClassName:@"User" objectId:[_model1 objectForKey:@"seeUserId"]];
        [gameScore setObject:user forKey:@"aUser"];
        [gameScore setObject:[_model1 objectForKey:@"seeUserId"] forKey:@"userId"];
        
        [gameScore setObject:[NSNumber numberWithInt:1000] forKey:@"money"];
        [gameScore setObject:[NSNumber numberWithInt:FLAG_ORDER_BACK_ALL] forKey:@"type"];
        [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"这一步更新明细表的~定金全部退还~");
                
                //4修改flag状态
                [self gengxinFLAG];
            } else if (error){
                
                NSLog(@"%@",error);
            } else {
                NSLog(@"Unknow error");
            }
        }];

    }
}
//更新明细表800
-(void)gengxinmaijiazhanghumingxi800{
    BmobObject  *gameScore = [BmobObject objectWithClassName:@"AcountBean"];
    User *user = [User objectWithoutDatatWithClassName:@"User" objectId:[_model1 objectForKey:@"seeUserId"]];
    [gameScore setObject:user forKey:@"aUser"];
    [gameScore setObject:[_model1 objectForKey:@"seeUserId"] forKey:@"userId"];
    [gameScore setObject:[NSNumber numberWithInt:FLAG_ORDER_BACK_MINUS] forKey:@"type"];
    [gameScore setObject:[NSNumber numberWithInt:800] forKey:@"money"];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [self gengxi1nmaijiazhanghumingxi800];
                 NSLog(@"这一步更新明细表的~定金返还(已扣除200手续费)~");
        } else if (error){
            
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
}
//我卖的车,我交的保证金
-(void)gengxi1nmaijiazhanghumingxi800{
    BmobObject  *gameScore = [BmobObject objectWithClassName:@"AcountBean"];
    User *user = [User objectWithoutDatatWithClassName:@"User" objectId:[_model1 objectForKey:@"carUserId"]];
    [gameScore setObject:user forKey:@"aUser"];
    [gameScore setObject:[_model1 objectForKey:@"carUserId"] forKey:@"userId"];
    [gameScore setObject:[NSNumber numberWithInt:FLAG_BAOZHENGJIN_BACK_MINUS] forKey:@"type"];
    [gameScore setObject:[NSNumber numberWithInt:800] forKey:@"money"];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"这一步更新明细表的~保证金返还(已扣除200手续费)");
            [self gengxinFLAG];
        } else if (error){
            
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
    
}


//if([[_model1 objectForKey:@"state"]intValue] == 2){
//    _zhuangtai.text=@"已付定金,等待商家确认";
//}
//if([[_model1 objectForKey:@"state"]intValue]==3){
//    _zhuangtai.text=@"卖家已确认";
//}
//if([[_model1 objectForKey:@"state"]intValue] == 4){
//    _zhuangtai.text=@"转车成功";
//}
//if([[_model1 objectForKey:@"state"] intValue]==12){
//    _zhuangtai.text=@"买家取消订单";
//}
//if([[_model1 objectForKey:@"state"] intValue]==13){
//    _zhuangtai.text=@"买家取消看车";
//}
//if([[_model1 objectForKey:@"state"] intValue]==22){
//    _zhuangtai.text=@"卖家取消订单";
//}
//if([[_model1 objectForKey:@"state"] intValue]==23){
//    _zhuangtai.text=@"卖家取消看车";
//}
//更新state
-(void)gengxinSTATE{
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"ReserveCar"  objectId:[_model1 objectId]];
    if([[_model1 objectForKey:@"state"]intValue]==2){
        if(_taggg==1){
    [bmobObject setObject:[NSNumber numberWithInt:12] forKey:@"state"];
        }
        if (_taggg==2) {
            [bmobObject setObject:[NSNumber numberWithInt:22] forKey:@"state"];

        }
    }
    if([[_model1 objectForKey:@"state"]intValue]==3){
        if(_taggg==1){
            [bmobObject setObject:[NSNumber numberWithInt:13] forKey:@"state"];
        }
        if (_taggg==2) {
            [bmobObject setObject:[NSNumber numberWithInt:23] forKey:@"state"];
            
        }
    }
    [bmobObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"这一步更新了state");
            if([[_model1 objectForKey:@"state"]intValue]==2 ){
                
            [self gengxinmaijiazhanghumingxi];
                }else{
                    [self gengxinmaijiazhanghumingxi800];
                    
                }
            
         //   [self performSegueWithIdentifier:@"shuaxinhuiqv" sender:self];
        } else if (error){
            NSLog(@"%@",error);
        } else {
            NSLog(@"UnKnow error");
        }
    }];

    
}

//更新flag
-(void)gengxinFLAG{
  //  BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"ReserveCar"  objectId:[_model1 objectId]];
    BmobObject *bmobObject1 = [BmobObject objectWithoutDatatWithClassName:@"CarDetail"  objectId:[[_model1 objectForKey:@"sCar"]objectId]];
  //  NSLog(@"%%%%%%%%%@",[[_model1 objectForKey:@"sCar"]objectId]);
    [bmobObject1 setObject:[NSNumber numberWithInt:1] forKey:@"flag"];
    
    [bmobObject1 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
          NSLog(@"这一步更新了flag得状态");
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            if(_taggg==1){
               
            YuyuemaiViewController * a=[[YuyuemaiViewController alloc]init];
            [a setupRefresh];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
            YuyueViewController * b=[[YuyueViewController alloc]init];
            [b setupRefresh];
            
            [self.navigationController popViewControllerAnimated:YES];
            }
           
            

        } else if (error){
            NSLog(@"%@!!!!!!!!!",error);
        } else {
            NSLog(@"UnKnow error");
        }
    }];

}

-(void)flag4{
    //  BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"ReserveCar"  objectId:[_model1 objectId]];
    BmobObject *bmobObject1 = [BmobObject objectWithoutDatatWithClassName:@"CarDetail"  objectId:[[_model1 objectForKey:@"sCar"]objectId]];
    //  NSLog(@"%%%%%%%%%@",[[_model1 objectForKey:@"sCar"]objectId]);
    [bmobObject1 setObject:[NSNumber numberWithInt:4] forKey:@"flag"];
    
    [bmobObject1 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"这一步更新了flag得状态");
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
            [self performSegueWithIdentifier:@"shuaxinhuiqv" sender:self];
            
            
            
        } else if (error){
            NSLog(@"%@!!!!!!!!!",error);
        } else {
            NSLog(@"UnKnow error");
        }
    }];
    
}

-(void)gengxinmai1jiazhanghu{
    
}

-(void)gengxinmaijia1mingxi{
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"ReserveCar"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery getObjectInBackgroundWithId:[_model1 objectId] block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                NSLog(@"%d1111",[[_model1 objectForKey:@"state"]intValue]);
                 NSLog(@"%d222222",[[object objectForKey:@"state"]intValue]);
                if([[_model1 objectForKey:@"state"]intValue]!=[[object objectForKey:@"state"]intValue]){
                    [SVProgressHUD showSuccessWithStatus:@"订单状态已改变,请刷新列表"];
                    [self.navigationController popViewControllerAnimated:YES];
                    return ;
                }else{
                if([[_model1 objectForKey:@"state"]intValue]==2){
                    if(_taggg==1){
                        if(alertView.tag==2){
                            if(buttonIndex==1){
                                [SVProgressHUD showWithStatus:@"请等待"];
                                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                NSLog(@"这是买家交完定金后买家取消的");
                                [self gengxinmaijiazhanghu:1000];
                                
                                
                            }
                        }
                    }
                    if(_taggg==2){
                        if(alertView.tag==2){
                            if(buttonIndex==1){
                                
                                [SVProgressHUD showWithStatus:@"请等待"];
                                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                [self gengxinmaijiazhanghu:1000];
                                
                                
                            }
                        }
                    }
                }
                //取消订单
                if([[_model1 objectForKey:@"state"]intValue]==3){
                    if(_taggg==1){
                        if(alertView.tag==2){
                            if(buttonIndex==1){
                                
                                [SVProgressHUD showWithStatus:@"请等待"];
                                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                [self gengxinmaijiazhanghu2:800];
                                
                            }
                        }
                    }
                    if(_taggg==2){
                        if(alertView.tag==2){
                            if(buttonIndex==1){
                                [SVProgressHUD showWithStatus:@"请等待"];
                                [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                [self gengxinmaijiazhanghu2:800];
                                
                            }
                        }
                    }
                }
                
                
                //确认订单
                if(alertView.tag==3){
                    if (buttonIndex==1) {
                        
                        
                        NSString * userid=[[BmobUser getCurrentUser]objectId];
                        BmobQuery *query = [BmobUser query];
                        [query whereKey:@"objectId" equalTo:userid];
                        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                            for (BmobUser *user in array) {
                                NSString *str = [[user objectForKey:@"money"] stringValue];
                                if([str intValue]<1000){
                                    [self qvchongzhi];
                                }else{
                                    [SVProgressHUD showWithStatus:@"请等待"];
                                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                                    [self gengxinquerendingdan:-1000];
                                    
                                }
                            }
                        }];
                        
                        
                        
                        
                    }
                }
                
                //去充值页面
                if(alertView.tag==4){
                    if (buttonIndex==1) {
                        [self performSegueWithIdentifier:@"qvchongzhi" sender:self];
                    }
                }
                
                //确认购车
                
                if(alertView.tag==5){
                    if(buttonIndex==1) {
                        [SVProgressHUD showWithStatus:@"请等待"];
                        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                        [self gengxinmaijiazhanghu1600:1600];
                        
                    }
                }
                
                
                
                if(buttonIndex==0){
                    if(alertView.tag==111){
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%d",KEFU_PHONE]]];
                    }
                }
                
                
                
                
                //下面的打电话
                if(alertView.tag==1){
                    if (buttonIndex==1) {
                        if (_taggg==1) {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[[_model1 objectForKey:@"sCar"]objectForKey:@"contactPhone"]]]];
                        }else{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[[_model1 objectForKey:@"sUser"]objectForKey:@"username"]]]];
                        }
                    }
                    
                    }
                }

            }
        }
    }];
    
    
    
   
    }
- (IBAction)kanchexinxi:(UIButton *)sender {
    if (_taggg==1) {
    GUAAlertView *v = [GUAAlertView alertViewWithTitle:@"交易信息"
                                               message:[NSString stringWithFormat:@"车主姓名:%@\n\n预定看车时间:%@\n\n车主电话:%@",[[_model1 objectForKey:@"sCar"]objectForKey:@"contactName"],[_model1 objectForKey:@"sDate"],[[_model1 objectForKey:@"sCar"]objectForKey:@"contactPhone"]]
                                           buttonTitle:@"确定"
                                   buttonTouchedAction:^{
                                       NSLog(@"button touched");
                                   } dismissAction:^{
                                       NSLog(@"dismiss");
                                   }];
    
    [v show]; 
    }else{
        GUAAlertView *v = [GUAAlertView alertViewWithTitle:@"交易信息"
                                                   message:[NSString stringWithFormat:@"看车人:%@\n\n看车时间:%@\n\n看车人电话:%@",[_model1 objectForKey:@"sContact"],[_model1 objectForKey:@"sDate"],[[_model1 objectForKey:@"sUser"]username]]
                                               buttonTitle:@"确定"
                                       buttonTouchedAction:^{
                                           NSLog(@"button touched");
                                       } dismissAction:^{
                                           NSLog(@"dismiss");
                                       }];
        
        [v show]; 

        
    }
    
}

- (IBAction)yuexiaoyuyue:(UIButton *)sender {
    if([[_model1 objectForKey:@"state"]intValue]==2){
        if(_taggg==1){
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"提示" icon:nil message:@"您的定金将全部返还到您的同行车账户,确认取消订单?" delegate:self buttonTitles:@"取消", @"确定", nil];
    alert.tag=2;
    [alert show];
        }else{
            FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"提示" icon:nil message:@"买家定金将全部返还到买家的同行车账户,确认取消订单?" delegate:self buttonTitles:@"取消", @"确定", nil];
            alert.tag=2;
            [alert show];
            
        }
    }
    if([[_model1 objectForKey:@"state"]intValue]==3){
        if(_taggg==1){
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"提示" icon:nil message:@"您的定金将将扣除200元后返还到您的同行车账户,确认取消订单?" delegate:self buttonTitles:@"取消", @"确定", nil];
        alert.tag=2;
        [alert show];
        }else{
            FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"提示" icon:nil message:@"您的保证金将扣除200元后返还到您的同行车账户,确认取消订单?" delegate:self buttonTitles:@"取消", @"确定", nil];
            alert.tag=2;
            [alert show];
        }
    }

}

- (IBAction)lianximaijia:(UIButton *)sender {
}
- (IBAction)qvrengouche:(UIButton *)sender {
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"提示" icon:nil message:@"是否确认购车?\n\n确认后定金将抵押购车款打入卖家账户!" delegate:self buttonTitles:@"取消", @"确定", nil];
    alert.tag=5;
    [alert show];
    
}
- (IBAction)qvrendingdan:(UIButton *)sender {
        
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"提示" icon:nil message:@"为了保障买家定金安全和车辆信息属实，您需要缴纳1000元保证金，待交易完毕后返还到您的账户，是否确认订单？\n 注意：买方定金中的600元将转入您的账户，同时抵扣1000元购车款，请注意查收!" delegate:self buttonTitles:@"取消", @"确定", nil];
        alert.tag=3;
        [alert show];
}

-(void)qvchongzhi{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"提示" icon:nil message:@"您的账户不足1000元,无法缴纳保证金并确认订单,请进入账户中心充值!" delegate:self buttonTitles:@"取消", @"去充值", nil];
    alert.tag=4;
    [alert show];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        return 208;
    }else if(indexPath.section==1&&indexPath.row==0){
        return 80;
    }else if(indexPath.section==2&&indexPath.row==0){
        return 74;
    }else if(indexPath.section==3&&indexPath.row==0){
        return 28;
    }else{
        return [UIScreen mainScreen].bounds.size.height-208-150-28-64-45-20-10;
    }
    
}

- (IBAction)pinglun:(UIButton *)sender {
    
    pinglunTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"pinglun_tableview"];
    detail.model11=_model1;
    [self.navigationController pushViewController:detail animated:YES];
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
- (IBAction)zaixiangoutong:(UIButton *)sender {
    if(_taggg==1){
        NSLog(@"1111");
    User *chatUser = [_model1 objectForKey:@"carUser"];
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];

    [infoDic setObject:chatUser.objectId forKey:@"uid"];
    [infoDic setObject:chatUser.username forKey:@"name"];
    //             [infoDic setObject:chatUser.username forKey:@"nick"];
    
    NSString *avatar = [chatUser objectForKey:@"avatar"];
    NSString *nick = [chatUser objectForKey:@"nick"];
    
    if (avatar) {
        
        [infoDic setObject:avatar forKey:@"avatar"];
    }
    
    if (nick) {
        
        [infoDic setObject:nick forKey:@"nick"];
    }
    
    ChatViewController *cvc = [[ChatViewController alloc] initWithUserDictionary:infoDic];
    [self.navigationController pushViewController:cvc animated:YES];
    }else{
        User *chatUser = [_model1 objectForKey:@"sUser"];
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
        
        [infoDic setObject:chatUser.objectId forKey:@"uid"];
        [infoDic setObject:chatUser.username forKey:@"name"];
        NSLog(@"%@",chatUser.username);
        //             [infoDic setObject:chatUser.username forKey:@"nick"];
        
        NSString *avatar = [chatUser objectForKey:@"avatar"];
        NSString *nick = [chatUser objectForKey:@"nick"];
        
        if (avatar) {
            
            [infoDic setObject:avatar forKey:@"avatar"];
        }
        
        if (nick) {
            
            [infoDic setObject:nick forKey:@"nick"];
        }
        
        ChatViewController *cvc = [[ChatViewController alloc] initWithUserDictionary:infoDic];
        [self.navigationController pushViewController:cvc animated:YES];

    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
