//
//  BaoZhengJinTableViewController.m
//  TXCar
//
//  Created by jack on 15/10/28.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "BaoZhengJinTableViewController.h"
#import <BmobSDK/Bmob.h>
#import "FDAlertView.h"
#import <BmobSDK/BmobUser.h>
#import "MyzhanghuViewController.h"
#import "Header.h"
#import "User.h"
#import "SVProgressHUD.h"
#import "RKDropdownAlert.h"
@interface BaoZhengJinTableViewController ()<FDAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *jiaonabaozhengjin;
@property (strong, nonatomic) IBOutlet UITableView *baozhengjin_tableview;
@property(nonatomic,copy)NSString * money;
@end

@implementation BaoZhengJinTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"信誉保证金";
   
     NSString * userid=[[BmobUser getCurrentUser]objectId];
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"objectId" equalTo:userid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobUser *user in array) {
            NSLog(@"!!!%@",[user objectForKey:@"hasPayFund"]);

            if([[user objectForKey:@"hasPayFund"]intValue]==1){
                _jiaonabaozhengjin.hidden=YES;
            }
 
            
            
            NSString *str = [[user objectForKey:@"money"] stringValue];
            
            _money=[NSString stringWithFormat:@"%@",str];
            
        }
        
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (IBAction)jiaona:(UIButton *)sender {
    if([_money intValue]<1000){
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"保证金" icon:nil message:@"您好,您的账户余额不足支付定金,请充值"  delegate:self buttonTitles:@"取消", @"去充值", nil];
        alert.tag=2;
        [alert show];
    }else{
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"保证金" icon:nil message:[NSString stringWithFormat:@"您的账户余额%@元,是否支付1000元保证金?",_money]  delegate:self buttonTitles:@"取消", @"确定", nil];
        alert.tag=1;
        [alert show];
    }

}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==2){
        if (buttonIndex==1) {
            MyzhanghuViewController *detail1 = [self.storyboard instantiateViewControllerWithIdentifier:@"chongzhi_sbId"];
            [self.navigationController pushViewController:detail1 animated:YES];
        }
    }
    if(alertView.tag==1){
        if (buttonIndex==1) {
            [SVProgressHUD showWithStatus:@"正在支付"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [self gengxinmaijiazhanghu:-1000];
        }
    }
}


-(void)gengxinmaijiazhanghu:(int)asd{
    
    
    NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:[[BmobUser getCurrentUser]username],@"username",[NSString stringWithFormat:@"%d",asd],@"money", nil];
    
    [BmobCloud callFunctionInBackground:@"updateSalerMoney" withParameters:dic2 block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"error--------- %@",[error description]);
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"查档失败"];
        }
        NSLog(@"扣了当前用户1000保证金");
        [self gengxinmingxi];
    }] ;
}



-(void)gengxinmingxi{
    BmobObject  *gameScore = [BmobObject objectWithClassName:@"AcountBean"];
    User *user = [User objectWithoutDatatWithClassName:@"User" objectId:[[BmobUser getCurrentUser]objectId]];
    [gameScore setObject:user forKey:@"aUser"];
    [gameScore setObject:[[BmobUser getCurrentUser]objectId] forKey:@"userId"];
    [gameScore setObject:[NSNumber numberWithInt:FLAG_ORDER_PAY_BAOZHANG] forKey:@"type"];
    [gameScore setObject:[NSNumber numberWithInt:-1000] forKey:@"money"];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
//            [SVProgressHUD dismiss];
//            [self.delegate change];
         //   [self.navigationController popViewControllerAnimated:YES];
            [self gengxinBOOL];
            NSLog(@"这一步更新明细表的~1000信誉金~");
        } else if (error){
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"服务器失败,请联系客服"];
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
    
}

-(void)gengxinBOOL{
//    BmobUser *bUser = [BmobUser getCurrentUser];
//    NSLog(@"%@",bUser);
//    [bUser setObject:[NSNumber numberWithBool:YES] forKey:@"hasPayFund"];
//    [bUser setObject:[NSNumber numberWithInt:1000] forKey:@"fundMoney"];
//
//    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//        [SVProgressHUD dismiss];
//        
//        [self.delegate change:@"ad"];
//        [self.navigationController popViewControllerAnimated:YES];
//        NSLog(@"%@",bUser.objectId);
//        NSLog(@"这一步更改了bool根1000~");
//        NSLog(@"error %@",[error description]);
//    }];
    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"_User"  objectId:[[BmobUser getCurrentUser] objectId]];
    [bmobObject setObject:[NSNumber numberWithBool:YES] forKey:@"hasPayFund"];
    [bmobObject setObject:[NSNumber numberWithInt:1000] forKey:@"fundMoney"];
    [bmobObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            [SVProgressHUD dismiss];
            
                    [self.delegate change:@"ad"];
                    [self.navigationController popViewControllerAnimated:YES];

            
        } else if (error){
            NSLog(@"%@",error);
        } else {
            NSLog(@"UnKnow error");
        }
    }];
    
}
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
