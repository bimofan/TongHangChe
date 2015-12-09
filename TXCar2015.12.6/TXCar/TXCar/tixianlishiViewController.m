//
//  tixianlishiViewController.m
//  TXCar
//
//  Created by jack on 15/10/27.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "tixianlishiViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "UIImageView+WebCache.h"
#import "chadang.h"
#import <BmobSDK/Bmob.h>
#import "FDAlertView.h"
#import "SVProgressHUD.h"

#import <BmobSDK/BmobUser.h>
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
@interface tixianlishiViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *qvxianlishi;
@property (nonatomic,copy)NSMutableArray * datasoure;
@property(nonatomic,assign)int i;
@end

@implementation tixianlishiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"提现历史";
    _datasoure=[[NSMutableArray alloc]init];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _i++;
    [SVProgressHUD showWithStatus:@"正在查询"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    //申明返回的结果是json类型
    //   manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    //申明请求的数据是json类型
    //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    NSDictionary *parameters = @{@"userId":[[BmobUser getCurrentUser]objectId],@"pageNo":[NSString stringWithFormat:@"%d",_i]};
    [manager POST:@"http://tonghangche.com/system/mobile/queryGetMoneyByUserId"parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              
              NSString *sdsd=[responseObject objectForKey:@"data"];
              //  NSLog(@"~~~~~~~~~~~~~~~%@",sdsd);
              NSData *data =[sdsd dataUsingEncoding:NSUTF8StringEncoding];
              NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
              for (NSDictionary * ad in weatherDic) {
                  [_datasoure addObject:ad];
              }
              [_qvxianlishi reloadData];
              [SVProgressHUD dismiss];
              
          }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
              [SVProgressHUD dismiss];

              NSLog(@"~~~~~~~~~~~%@~~~~~~~~~~~~~",error);
          }
     
     ];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
       return _datasoure.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    return 58;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    
  
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    
    UILabel * lable12=(UILabel*)[cell viewWithTag:3];
    if([[_datasoure[indexPath.row] objectForKey:@"state"]intValue] == 1){
        lable12.text=@"已提交,待转账";
    }
    if([[_datasoure[indexPath.row] objectForKey:@"state"]intValue]==2){
        lable12.text=@"转账成功";
    }
    if([[_datasoure[indexPath.row] objectForKey:@"state"]intValue] == 3){
        lable12.text=@"提现失败";
    }
   
    UILabel * lable1=(UILabel*)[cell viewWithTag:1];
    lable1.text=[NSString stringWithFormat:@"%@元",[[_datasoure objectAtIndex:indexPath.row] objectForKey:@"money"]];
  
    UILabel * lable3=(UILabel*)[cell viewWithTag:2];
    lable3.text=[[_datasoure objectAtIndex:indexPath.row] objectForKey:@"createTime"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

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
