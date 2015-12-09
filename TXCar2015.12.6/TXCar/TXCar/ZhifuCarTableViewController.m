//
//  ZhifuCarTableViewController.m
//  TXCar
//
//  Created by jack on 15/10/10.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "ZhifuCarTableViewController.h"
#import <BmobSDK/Bmob.h>
#import "FDAlertView.h"
#import <BmobSDK/BmobUser.h>
#import "MyzhanghuViewController.h"
#import <BmobIM/BmobIM.h>
#import <BmobIM/BmobDB.h>
#import <BmobIM/BmobChatManager.h>
#import "Header.h"
#import <BmobSDK/BmobUser.h>
#import "User.h"
#import "GUAAlertView.h"
#import "ChatViewController.h"
#import "ZhaoCheDetailViewController.h"
#import "zhifuchenggongTableViewController.h"
@interface ZhifuCarTableViewController ()<FDAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *carname;
@property (weak, nonatomic) IBOutlet UILabel *carpage;
@property (weak, nonatomic) IBOutlet UILabel *cardingjin;
@property (weak, nonatomic) IBOutlet UIButton *querenzhifu;
@property (weak, nonatomic) IBOutlet UIButton *zhifuchenggong;
@property(nonatomic,copy)NSString * money;
@property(nonatomic,copy)NSMutableAttributedString * str;

@property(nonatomic,copy) BmobChatUser  *chatUser;

@end

@implementation ZhifuCarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title=@"支付定金";
    NSLog(@"%@",_chemingzi);
    
    _carname.text=_name;
    NSString * cccc=[_jiage stringByAppendingString:@"万元"];
    _carpage.text=cccc;
    _cardingjin.text=@"1000元";
    NSString * userid=[[BmobUser getCurrentUser]objectId];
    _zhifuchenggong.hidden=YES;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10,15)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"navbar_return_normal.png"] forState:UIControlStateNormal];
 //   [backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [backButton addTarget:self action:@selector(dismiss1) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    
    
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"objectId" equalTo:userid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobUser *user in array) {
            
            NSString *str = [[user objectForKey:@"money"] stringValue];
            
            _money=[NSString stringWithFormat:@"%@",str];
            
        }

    }];
    
    
    
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"CarDetail"];
    //查找GameScore表里面id为0c6db13c的数据
    [bquery includeKey:@"cUser"];
    [bquery getObjectInBackgroundWithId:_cheId block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            //表里有id为0c6db13c的数据
            if (object) {
                //得到playerName和cheatMode
                _chatUser = [[BmobChatUser alloc] init];
                _chatUser.objectId = [[object objectForKey:@"cUser"]objectId] ;
                _chatUser.username = [[object objectForKey:@"cUser"] username];
                _chatUser.avatar   = [[object objectForKey:@"cUser"] objectForKey:@"avatar"];
                _chatUser.nick = [[object objectForKey:@"cUser"] objectForKey:@"contact"];
                
            }
        }
    }];
    
    
    
    
    
    
//    NSString *contentStr = [NSString stringWithFormat:@"您的账户余额%@元,是否支付?",_money];
//    _str = [[NSMutableAttributedString alloc]initWithString:contentStr];
//    
//    [_str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(5, _money.length)];
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
    }else if(indexPath.section==1&&indexPath.row==3){
        return 140;
    }else{
        return [UIScreen mainScreen].bounds.size.height-185-64-140;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }else{
        return 5;
    }
}

- (IBAction)querenzhifu:(UIButton *)sender {
    if([_money intValue]<1000){
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"预付定金" icon:nil message:@"您好,您的账户余额不足支付定金,请充值"  delegate:self buttonTitles:@"取消", @"去充值", nil];
        alert.tag=2;
        [alert show];
    }else{
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"预付定金" icon:nil message:[NSString stringWithFormat:@"您的账户余额%@元,是否支付?",_money]  delegate:self buttonTitles:@"取消", @"确定", nil];
    alert.tag=1;
    [alert show];
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        if(alertView.tag==111){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%d",KEFU_PHONE]]];
        }
    }

    if(alertView.tag==2){
        if (buttonIndex==1) {
        MyzhanghuViewController *detail1 = [self.storyboard instantiateViewControllerWithIdentifier:@"chongzhi_sbId"];
        [self.navigationController pushViewController:detail1 animated:YES];
        }
    }
    if(alertView.tag==1){
        if (buttonIndex==1) {
         [self gengxinmaijiazhanghu:-1000];
        }
    }
}

-(void)gengxinmaijiazhanghu:(int)asd
{
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"ReserveCar"  objectId:_stateid];
    [bmobObject setObject:[NSNumber numberWithInt:2] forKey:@"state"];
    [bmobObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //修改成功后的动作
            
        } else if (error){
            NSLog(@"%@",error);
        } else {
            NSLog(@"UnKnow error");
        }
    }];
    
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:[[BmobUser getCurrentUser]username],@"username",[NSString stringWithFormat:@"%d",asd],@"money", nil];
    
    [BmobCloud callFunctionInBackground:@"updateSalerMoney" withParameters:dic2 block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"error--------- %@",[error description]);
        }
        NSLog(@"这步给这个账户扣了1000定金");
        [self gengxinmaijiazhanghumingxi];
    }] ;
    
}

-(void)gengxinmaijiazhanghumingxi{
    BmobObject  *gameScore = [BmobObject objectWithClassName:@"AcountBean"];
    User *user = [User objectWithoutDatatWithClassName:@"User" objectId:[[BmobUser getCurrentUser]objectId]];
    [gameScore setObject:user forKey:@"aUser"];
    [gameScore setObject:[[BmobUser getCurrentUser]objectId] forKey:@"userId"];
    [gameScore setObject:[NSNumber numberWithInt:FLAG_ORDER_PAY_DINGJIN] forKey:@"type"];
    [gameScore setObject:[NSNumber numberWithInt:-1000] forKey:@"money"];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [self gengxinFLAG];
            NSLog(@"这一步更新明细表的~支付定金~");
        } else if (error){
            
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
}

-(void)gengxinFLAG{
    //  BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"ReserveCar"  objectId:[_model1 objectId]];
    BmobObject *bmobObject1 = [BmobObject objectWithoutDatatWithClassName:@"CarDetail"  objectId:_cheId];
    //  NSLog(@"%%%%%%%%%@",[[_model1 objectForKey:@"sCar"]objectId]);
    [bmobObject1 setObject:[NSNumber numberWithInt:4] forKey:@"flag"];
    
    [bmobObject1 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"这一步更新了flag得状态");
            _querenzhifu.hidden=YES;
            _zhifuchenggong.hidden=NO;
            NSLog(@"%@",[NSString stringWithFormat:@"您好，我已预定了您的%@,请到订单中心查看并确认吧！合作愉快！",_chemingzi]);
        // [self performSegueWithIdentifier:@"shuaxinhuiqv" sender:self];
          
            [self sendMessageWithContent:[NSString stringWithFormat:@"您好，我已预定了您的%@,请到订单中心查看并确认吧！合作愉快！",_chemingzi] type:1];
            
        } else if (error){
            NSLog(@"%@!!!!!!!!!",error);
        } else {
            NSLog(@"UnKnow error");
        }
    }];
    
}
- (IBAction)zhifuchenggong:(UIButton *)sender {
     zhifuchenggongTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"zhifu_xinxi3"];
    detail.name=_name;
    detail.jiage1=_jiage;
    detail.contactName=_contactName;
    detail.contactPhone=_contactPhone;
    
    [self.navigationController pushViewController:detail animated:YES];
    
}

-(void)dismiss1{
    ZhaoCheDetailViewController *detail =self.navigationController.viewControllers[0];
    
    [self.navigationController popToViewController:detail animated:YES];
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


//发送消息(文本/位置)
-(void)sendMessageWithContent:(NSString *)content type:(NSInteger)type{
    NSLog(@"%@",_chatUser.objectId);
    BmobMsg *msg             = [BmobMsg createAMessageWithType:type statue:STATUS_SEND_SUCCESS content:content targetId:_chatUser.objectId];
    
    msg.belongNick = [_chatUser objectForKey:@"contact"];
    msg.belongUsername = _chatUser.username;
  
  
    msg.status = STATUS_SEND_SUCCESS;
    [[BmobChatManager currentInstance] sendMessageWithUser:_chatUser
                                                   message:msg
     
                                                     block:^(BOOL isSuccessful, NSError *error) {
                                                     }];
    
    
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

//- (void)dismiss1 {
//    ZhaoCheDetailViewController *detail =self.navigationController.viewControllers[0];
//    
//    [self.navigationController popToViewController:detail animated:YES];
//    
//}
/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

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
