//
//  LIshichadangViewController.m
//  TXCar
//
//  Created by jack on 15/10/26.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "LIshichadangViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "UIImageView+WebCache.h"
#import "chadang.h"
#import <BmobSDK/Bmob.h>
#import "FDAlertView.h"
#import "SVProgressHUD.h"
#import "YMShowImageView.h"
#import <BmobSDK/BmobUser.h>
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "RKDropdownAlert.h"
@interface LIshichadangViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *lishi_tableview;
@property (nonatomic,copy)NSMutableArray * datasoure;
@property (nonatomic,copy)NSMutableArray * datasoureurl;
@property(nonatomic,assign)int i;
@end

@implementation LIshichadangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"查档历史";
//    UIView *view =[ [UIView alloc]init];
//    view.backgroundColor = [UIColor clearColor];
//    [_lishi_tableview setTableFooterView:view];
//    [_lishi_tableview setTableHeaderView:view];
    _datasoure=[[NSMutableArray alloc]init];
     _datasoureurl=[[NSMutableArray alloc]init];
   self.automaticallyAdjustsScrollViewInsets=NO;
    _i++;
    [SVProgressHUD showWithStatus:@"正在查询"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
       manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    //申明返回的结果是json类型
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    //manager.requestSerializer=[AFJSONRequestSerializer serializer];
      NSDictionary *parameters = @{@"userId":[[BmobUser getCurrentUser]objectId],@"pageNo":[NSString stringWithFormat:@"%d",_i]};
    [manager POST:@"http://tonghangche.com/system/mobile/queryInfoByUserId"parameters:parameters
          success:^(AFHTTPRequestOperation *operation,id responseObject) {
              
              NSString *sdsd=[responseObject objectForKey:@"data"];

              NSData *data =[sdsd dataUsingEncoding:NSUTF8StringEncoding];
              NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
              for (NSDictionary * ad in weatherDic) {
                  [_datasoure addObject:ad];
                 
              }
              [_lishi_tableview reloadData];
              [SVProgressHUD dismiss];
          }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
            
           NSLog(@"~~~~~~~~~~~%@~~~~~~~~~~~~~",error);
          }
     
     ];
 
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    
    return _datasoure.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
  
    return 58;
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
        lable12.text=@"信息提交已缴费";
    }
    if([[_datasoure[indexPath.row] objectForKey:@"state"]intValue]==2){
        lable12.text=@"查档成功";
    }
    if([[_datasoure[indexPath.row] objectForKey:@"state"]intValue] == 3){
        lable12.text=@"查档失败";
    }
    
    
    UILabel * lable1=(UILabel*)[cell viewWithTag:1];
    lable1.text=[[_datasoure objectAtIndex:indexPath.row] objectForKey:@"number"];

    
    UILabel * lable3=(UILabel*)[cell viewWithTag:2];
    lable3.text=[[_datasoure objectAtIndex:indexPath.row] objectForKey:@"createTime"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_datasoureurl removeAllObjects];
    
    if([[_datasoure[indexPath.row] objectForKey:@"state"]intValue] == 1){
        [RKDropdownAlert title:@"提示:正在为您查档请稍后" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
    }
    if([[_datasoure[indexPath.row] objectForKey:@"state"]intValue]==2){
        NSArray *array = [[[_datasoure objectAtIndex:indexPath.row]objectForKey:@"picUrl"] componentsSeparatedByString:@";"];
        for (NSString *aaa in array) {
            NSURL *bbb=[NSURL URLWithString:[NSString stringWithFormat:@"http://tonghangche.com/system/%@",aaa
                                             ]];http://tonghangche.com/system
            
            [_datasoureurl addObject:bbb];
        }
        
        [self showImageViewWithImageViews:_datasoureurl byClickWhich:9999];
        
    }
    if([[_datasoure[indexPath.row] objectForKey:@"state"]intValue] == 3){
        [RKDropdownAlert title:@"提示:查档失败,请联系客服!" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
    }

//    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
//  
//    imageInfo.imageURL =[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.114:8080/crmnew%@",[[_datasoure objectAtIndex:indexPath.row]objectForKey:@"picUrl"]]];
//    NSLog(@"%@>>>>>>>>>>>>>",[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.114:8080/crmnew%@",[[_datasoure objectAtIndex:indexPath.row]objectForKey:@"picUrl"]]]);
//    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
//                                           initWithImageInfo:imageInfo
//                                           mode:JTSImageViewControllerMode_Image
//                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
//    
//    
//    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
//    
    
}


- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:maskview];
    
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:self.view.bounds byClick:clickTag appendArray:imageViews];
    [ymImageV show:maskview didFinish:^(){
        
        [UIView animateWithDuration:0.5f animations:^{
            
            ymImageV.alpha = 0.0f;
            maskview.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            [ymImageV removeFromSuperview];
            [maskview removeFromSuperview];
        }];
        
    }];
    
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
