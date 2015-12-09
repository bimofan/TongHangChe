//
//  YuyuemaiViewController.m
//  TXCar
//
//  Created by jack on 15/10/15.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "YuyuemaiViewController.h"
#import <BmobSDK/Bmob.h>
#import "ReserveCar.h"
#import "CarDetail.h"
#import "RKDropdownAlert.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "Header.h"
#import "YuyueDetailViewControllerTableViewController.h"
@interface YuyuemaiViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *yuyue_tableview;
@property (nonatomic,assign) int page;
@end

@implementation YuyuemaiViewController
{
    ReserveCar * model;
    NSMutableArray * datasource;
    BmobQuery   *bquery;
    NSMutableArray * datasource1;
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"预约车辆";
    datasource=[[NSMutableArray alloc]init];
    _yuyue_tableview.delegate=self;
    _yuyue_tableview.dataSource=self;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    
    [_yuyue_tableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
    [_yuyue_tableview addFooterWithTarget:self action:@selector(footerRereshing)];
    [self setupRefresh];
 
  
}

-(void)viewWillAppear:(BOOL)animated{
    [self setupRefresh];
    
}


- (void)setupRefresh
{
    
    [_yuyue_tableview headerBeginRefreshing];
}

-(void)headerBeginRefreshing{
    
    
   
    bquery = [BmobQuery queryWithClassName:@"ReserveCar"];
    bquery.limit = 10;
    [bquery whereKey:@"carUserId" equalTo:[[BmobUser getCurrentUser]objectId]];
    [bquery includeKey:@"sCar,sUser,carUser"];
    [bquery whereKey:@"state" greaterThan:[NSNumber numberWithInt:1]];
    [bquery orderByDescending:@"updatedAt"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
         [datasource removeAllObjects];
        for (BmobObject *obj in array) {
            [datasource addObject:obj];
        }
        if(datasource.count==0){
            [RKDropdownAlert title:@"没有查询到数据" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
        }
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_yuyue_tableview reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_yuyue_tableview headerEndRefreshing];
    });
}

-(void)footerRereshing{
    bquery = [BmobQuery queryWithClassName:@"ReserveCar"];
    _page++;
    bquery.limit = 10;
    bquery.skip = 10*_page;
    [bquery whereKey:@"carUserId" equalTo:[[BmobUser getCurrentUser]objectId]];
    [bquery includeKey:@"sCar,sUser"];
    [bquery whereKey:@"state" greaterThan:[NSNumber numberWithInt:1]];
    [bquery orderByDescending:@"updatedAt"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            [datasource addObject:obj];
        }
        
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_yuyue_tableview reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_yuyue_tableview footerEndRefreshing];
    });
    
}












- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return datasource.count;;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0){
        return 5;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 164;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    
    model=[datasource objectAtIndex:indexPath.section];

    UIImageView *image1 = (UIImageView*)[cell viewWithTag:1];
    NSURL *URL = [NSURL URLWithString:[[model objectForKey:@"sCar"]objectForKey:@"carPic"]];
    [image1 sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"loading-image"]];
    
    if ([[model objectForKey:@"state"]intValue] == 4){
        UIImageView *image2 = (UIImageView*)[cell viewWithTag:13];
        image2.image=[UIImage imageNamed:@"yufudingj"];
        
    }
    else if ([[model objectForKey:@"state"]intValue] == 2){
        UIImageView *image2 = (UIImageView*)[cell viewWithTag:13];
        image2.image=[UIImage imageNamed:@"yufudingjina"];
    }else if ([[model objectForKey:@"state"]intValue] == 3){
        UIImageView *image2 = (UIImageView*)[cell viewWithTag:13];
        image2.image=[UIImage imageNamed:@"yufudingji"];
    }else  if ([[model objectForKey:@"state"]intValue] == 12){
        UIImageView *image2 = (UIImageView*)[cell viewWithTag:13];
        
        image2.image=[UIImage imageNamed:@"yufudingjina"];
    }else if ([[model objectForKey:@"state"]intValue] == 13){
        UIImageView *image2 = (UIImageView*)[cell viewWithTag:13];
        
        image2.image=[UIImage imageNamed:@"yufudingji"];
    }
    else if ([[model objectForKey:@"state"]intValue] == 22){
        UIImageView *image2 = (UIImageView*)[cell viewWithTag:13];
        
        
        image2.image=[UIImage imageNamed:@"yufudingjina"];
    }else if ([[model objectForKey:@"state"]intValue] == 23){
        UIImageView *image2 = (UIImageView*)[cell viewWithTag:13];
        
        image2.image=[UIImage imageNamed:@"yufudingji"];
    }


    UILabel * lable12=(UILabel*)[cell viewWithTag:11];
    if([[model objectForKey:@"state"]intValue] == RESERVE_PAYED){
        lable12.text=@"已付定金,等待商家确认";
    }
    if([[model objectForKey:@"state"]intValue]==3){
        lable12.text=@"卖家已确认";
    }
    if([[model objectForKey:@"state"]intValue] == RESERVE_SUCCED){
        lable12.text=@"转车成功";
    }
    if([[model objectForKey:@"state"] intValue]==12){
        lable12.text=@"买家取消订单";
    }
    if([[model objectForKey:@"state"] intValue]==13){
        lable12.text=@"买家取消看车";
    }
    if([[model objectForKey:@"state"] intValue]==22){
        lable12.text=@"卖家取消确认订单";
    }
    if([[model objectForKey:@"state"] intValue]==23){
        lable12.text=@"卖家取消看车";
    }
    UILabel * lable1=(UILabel*)[cell viewWithTag:2];
    lable1.text=[[model objectForKey:@"sCar"]objectForKey:@"carInfo"];
    
    
    UILabel * lable11=(UILabel*)[cell viewWithTag:10];
    lable11.text=[NSString stringWithFormat:@"买车人:%@",[model objectForKey:@"sContact"]];
    
    UILabel * lable2=(UILabel*)[cell viewWithTag:3];
    NSString * bbb=[NSString stringWithFormat:@"%@",[[model objectForKey:@"sCar"]objectForKey:@"carDistance"]];
    NSString * bbbb=[bbb stringByAppendingString:@"万公里 /"];
    lable2.text=bbbb;
    
    
    
    NSString * create_date=[NSString stringWithFormat:@"%@", [[model objectForKey:@"sCar"] updatedAt]];
    NSString * create_date1=[create_date substringWithRange:NSMakeRange(5, 5)];
    
    NSString * aaaa=[create_date1 stringByAppendingString:[[model objectForKey:@"sCar"]objectForKey:@"carLocation"]];
    UILabel * lable4=(UILabel*)[cell viewWithTag:4];
    lable4.text=aaaa;
    
    UILabel * lable5=(UILabel*)[cell viewWithTag:5];
    NSString * ccc=[NSString stringWithFormat:@"%@",[[model objectForKey:@"sCar"]objectForKey:@"carPrice" ]];
    NSString * cccc=[ccc stringByAppendingString:@"万元"];
    lable5.text=cccc;
    
    UILabel * lable7=(UILabel*)[cell viewWithTag:8];
    NSString * ns=[[[model objectForKey:@"sCar"]objectForKey:@"carYearCheck"] substringToIndex:4];
    
    lable7.text=ns;
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    YuyueDetailViewControllerTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"yuyue_detail"];
    detail.taggg=2;
    detail.model1 = [datasource objectAtIndex:indexPath.section];
    detail.model2= [datasource1 objectAtIndex:indexPath.section];

    [self.navigationController pushViewController:detail animated:YES];
    
    
    
}
@end
