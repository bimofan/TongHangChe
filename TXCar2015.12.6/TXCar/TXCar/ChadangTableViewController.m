//
//  ChadangTableViewController.m
//  TXCar
//
//  Created by jack on 15/10/26.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "ChadangTableViewController.h"
#import <BmobSDK/Bmob.h>
#import "FDAlertView.h"
#import <BmobSDK/BmobUser.h>
#import "MyzhanghuViewController.h"
#import "Header.h"
#import "GUAAlertView.h"
#import "User.h"
#import "RKDropdownAlert.h"
#import "SVProgressHUD.h"
#import "RKDropdownAlert.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "LIshichadangViewController.h"
@interface ChadangTableViewController ()<FDAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *chepaihao;
@property (weak, nonatomic) IBOutlet UITextField *lianxidianhua;
@property(nonatomic,copy)NSString * money;
@property(nonatomic,copy)NSMutableArray * datasoure;
@property (weak, nonatomic) IBOutlet UITextField *lianxiren;
@end

@implementation ChadangTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.title = @"查档";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"历史" style:UIBarButtonItemStylePlain target:self action:@selector(perFormAdd1)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"历史" style:UIBarButtonItemStylePlain target:self action:@selector(perFormAdd1)];
    
    
    
    _lianxiren.text=[[BmobUser getCurrentUser]objectForKey:@"contact"];
    _lianxidianhua.text=[[BmobUser getCurrentUser]objectForKey:@"username"];
    NSString * userid=[[BmobUser getCurrentUser]objectId];
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"objectId" equalTo:userid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobUser *user in array) {
            
            NSString *str = [[user objectForKey:@"money"] stringValue];
            
            _money=[NSString stringWithFormat:@"%@",str];
            
        }
        
    }];

    
}

-(void)perFormAdd1{
    LIshichadangViewController *cac=[self.storyboard instantiateViewControllerWithIdentifier:@"lishichadang"];
    [self.navigationController pushViewController:cac animated:YES];

}



- (IBAction)queren:(UIButton *)sender {
    
    if([_chepaihao.text isEqual:@""]){
        [RKDropdownAlert title:@"提示: 请输入车牌号" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    if([_lianxiren.text isEqual:@""]){
        [RKDropdownAlert title:@"提示: 请输入联系人" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    if([_lianxidianhua.text isEqual:@""]){
        [RKDropdownAlert title:@"提示: 请输入联系人电话" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }

    
    
    
    
    
    
    
    
    
    [_chepaihao resignFirstResponder];
    if([_money intValue]<20){
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"预付定金" icon:nil message:@"您好,您的账户余额不足支付定金,请充值"  delegate:self buttonTitles:@"取消", @"去充值", nil];
        alert.tag=2;
        [alert show];
    }else{
        FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"预付定金" icon:nil message:[NSString stringWithFormat:@"您的账户余额%@元,是否支付10元查档手续费?",_money]  delegate:self buttonTitles:@"取消", @"确定", nil];
        alert.tag=1;
        [alert show];
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_chepaihao resignFirstResponder];
    [_lianxidianhua resignFirstResponder];
    [_lianxiren resignFirstResponder];
   
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, 0);
    }];
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
            [SVProgressHUD showWithStatus:@"正在查档"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [self post];
        }
    }
    if(buttonIndex==0){
        if(alertView.tag==111){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%d",KEFU_PHONE]]];
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
    NSLog(@"扣了当前用户10金");
    [self gengxinmingxi];
}] ;
}

-(void)gengxinmingxi{
    BmobObject  *gameScore = [BmobObject objectWithClassName:@"AcountBean"];
    User *user = [User objectWithoutDatatWithClassName:@"User" objectId:[[BmobUser getCurrentUser]objectId]];
    [gameScore setObject:user forKey:@"aUser"];
    [gameScore setObject:[[BmobUser getCurrentUser]objectId] forKey:@"userId"];
    [gameScore setObject:[NSNumber numberWithInt:FLAG_ORDER_PAY_CHADANG] forKey:@"type"];
    [gameScore setObject:[NSNumber numberWithInt:-10] forKey:@"money"];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
           [SVProgressHUD dismiss];
            [self performSegueWithIdentifier:@"chadanglishi_" sender:self];
            NSLog(@"这一步更新明细表的~10金~");
        } else if (error){
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"查档失败"];
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)post{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//    //申明返回的结果是json类型
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    //申明请求的数据是json类型
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"contact":_lianxiren.text,@"phone":_lianxidianhua.text,@"number":_chepaihao.text,@"userId":[[BmobUser getCurrentUser]objectId],@"from":@"IOS"};
     [manager POST:@"http://tonghangche.com/system/mobile/saveInfo"parameters:parameters
              success:^(AFHTTPRequestOperation *operation,id responseObject) {
                  if([[responseObject objectForKey:@"code"] intValue]==1){
                      [RKDropdownAlert title:@"提交成功" backgroundColor:[UIColor greenColor] textColor:[UIColor whiteColor] time:1];
                  [self gengxinmaijiazhanghu:-10];
                  }
             
         }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
             [RKDropdownAlert title:@"提交失败" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
             NSLog(@"失败Error: %@", error);
             [SVProgressHUD dismiss];
             [SVProgressHUD showSuccessWithStatus:@"发布成功"];
         }
      ];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        return 10;
    }else if(indexPath.section==0&&indexPath.row==1){
        return 100;
    }else if(indexPath.section==0&&indexPath.row==2){
        return 55;
    }
    else{
        return [UIScreen mainScreen].bounds.size.height-135-64-20;
    }
    
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
