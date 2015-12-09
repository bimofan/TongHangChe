//
//  ZaicarViewController.m
//  TXCar
//
//  Created by jack on 15/11/4.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "ZaicarViewController.h"
#import "CarDetail.h"
#import "WoDeViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobObject.h>
#import <BmobSDK/BmobUser.h>
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "MysettingViewController.h"
#import "SVProgressHUD.h"
#import "RKDropdownAlert.h"
#import "CarRequestListViewController.h"
#import "JGActionSheet.h"
#import "MJRefresh.h"
#import "JGActionSheet.h"
#import "ZhaoCheDetailViewController.h"
@interface ZaicarViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *car_tableview;
@property(nonatomic,copy)NSMutableArray * datasourse;
@property (nonatomic,assign) int page;
@end

@implementation ZaicarViewController
{
    CarDetail * model;
    BmobQuery   *bquery;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _datasourse=[[NSMutableArray alloc]init];
    self.title=@"在转车辆";
    [_car_tableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
    [_car_tableview addFooterWithTarget:self action:@selector(footerRereshing)];
    [self setupRefresh];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10,15)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"navbar_return_normal.png"] forState:UIControlStateNormal];
    //   [backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [backButton addTarget:self action:@selector(dismiss5) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismiss5{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupRefresh
{
    
    [_car_tableview headerBeginRefreshing];
}


- (void)headerBeginRefreshing
{
    [_datasourse removeAllObjects];
    [_datasourse removeAllObjects];
    bquery = [BmobQuery queryWithClassName:@"CarDetail"];
    bquery.limit = 10;
    [bquery orderByDescending:@"updatedAt"];
           if([_yiyang isEqual:@"DOTA"]){
            [bquery whereKey:@"userId" equalTo:_useridd];
            [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:1]];
            
        }else{
            [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
            [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:1]];
        }

        [bquery orderByDescending:@"updatedAt"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            CarDetail * carmodel=[[CarDetail alloc]init];
            carmodel.carInfo=[obj objectForKey:@"carInfo"];
            carmodel.carPic=[obj objectForKey:@"carPic"];
            carmodel.contactPhone=[obj objectForKey:@"contactPhone"];
            carmodel.publishTime=[obj objectForKey:@"publishTime"];
            carmodel.userId=[obj objectForKey:@"userId"];
            carmodel.contactName=[obj objectForKey:@"contactName"];
            carmodel.carColor=[obj objectForKey:@"carColor"];
            carmodel.carLocation=[obj objectForKey:@"carLocation"];
            carmodel.carNotes=[obj objectForKey:@"carNotes"];
            carmodel.carPrice=[[obj objectForKey:@"carPrice"]floatValue];
            carmodel.carYearCheck=[obj objectForKey:@"carYearCheck"];
            carmodel.flag=[[obj objectForKey:@"flag"]intValue];
            NSLog(@"``````%f",carmodel.flag);
            carmodel.carDistance=[[obj objectForKey:@"carDistance"]floatValue];
            carmodel.objectId=[obj objectId];
            carmodel.createdAt=[obj updatedAt];
            [_datasourse addObject:carmodel];
        }
        if(_datasourse.count==0){
            [RKDropdownAlert title:@"没有查询到数据" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        }

    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_car_tableview reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_car_tableview headerEndRefreshing];
    });
    
}


-(void)footerRereshing{
    bquery = [BmobQuery queryWithClassName:@"CarDetail"];
    
        if([_yiyang isEqual:@"DOTA"]){
            [bquery whereKey:@"userId" equalTo:_useridd];
            [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:1]];
            
        }else{
            [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
            [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:1]];
        }
    
    
    [bquery orderByDescending:@"updatedAt"];
    _page++;
    bquery.limit = 10;
    bquery.skip = 10*_page;
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *obj in array) {
            //打印playerName
            CarDetail * carmodel=[[CarDetail alloc]init];
            carmodel.carInfo=[obj objectForKey:@"carInfo"];
            carmodel.carPic=[obj objectForKey:@"carPic"];
            carmodel.contactPhone=[obj objectForKey:@"contactPhone"];
            carmodel.publishTime=[obj objectForKey:@"publishTime"];
            carmodel.userId=[obj objectForKey:@"userId"];
            carmodel.contactName=[obj objectForKey:@"contactName"];
            carmodel.carColor=[obj objectForKey:@"carColor"];
            carmodel.carLocation=[obj objectForKey:@"carLocation"];
            carmodel.carNotes=[obj objectForKey:@"carNotes"];
            carmodel.carPrice=[[obj objectForKey:@"carPrice"]floatValue];
            carmodel.carYearCheck=[obj objectForKey:@"carYearCheck"];
            carmodel.carDistance=[[obj objectForKey:@"carDistance"]floatValue];
            carmodel.flag=[[obj objectForKey:@"flag"]intValue];
            NSLog(@"%f!!!!!!!",carmodel.flag);
            carmodel.objectId=[obj objectId];
            carmodel.createdAt=[obj updatedAt];
            
            [_datasourse addObject:carmodel];
            
        }
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_car_tableview reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_car_tableview footerEndRefreshing];
    });
    
}









-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasourse.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"car_infomation_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    model=[_datasourse objectAtIndex:indexPath.row];
    
    
    UIImageView *image1 = (UIImageView*)[cell viewWithTag:1];
    NSURL *URL = [NSURL URLWithString:model.carPic];
    [image1 sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"loading-image"]];
    NSLog(@"-----%d",(int)model.flag);
    
    
    UIImageView *image22 = (UIImageView*)[cell viewWithTag:6];
    if(model.flag==4){
        [image22 setImage:[UIImage imageNamed:@"wode_yiyuding"]];
    }else if(model.flag==3){
        [image22 setImage:[UIImage imageNamed:@"wode_yizhuanche"]];
    }else{
        [image22 setImage:nil];
    }
    
    
    UILabel * lable1=(UILabel*)[cell viewWithTag:2];
    lable1.text=model.carInfo;
    
    UILabel * lable2=(UILabel*)[cell viewWithTag:3];
    NSString * bbb=[NSString stringWithFormat:@"%.00f",model.carDistance];
    NSString * bbbb=[bbb stringByAppendingString:@"万公里 /"];
    lable2.text=bbbb;
    
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"MM-dd"];
    NSString * create_date=[formatter stringFromDate:model.createdAt];
    NSString * aaaa=[create_date stringByAppendingString:model.carLocation];
    UILabel * lable4=(UILabel*)[cell viewWithTag:4];
    lable4.text=aaaa;
    
    UILabel * lable5=(UILabel*)[cell viewWithTag:5];
    NSString * ccc=[NSString stringWithFormat:@"%.f",model.carPrice];
    NSString * cccc=[ccc stringByAppendingString:@"万元"];
    lable5.text=cccc;
    
    UILabel * lable7=(UILabel*)[cell viewWithTag:8];
    NSString * ns=[model.carYearCheck substringToIndex:4];
    
    lable7.text=ns;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger selected_index=indexPath.row;
    
    
    JGActionSheetSection *section_one = [JGActionSheetSection sectionWithTitle:@"正在转让车辆" message:@"您可以对自己正在转让的车辆进行设置" buttonTitles:@[@"已转", @"查看详情",@"取消"] buttonStyle:JGActionSheetButtonStyleDefault];
    [section_one setButtonStyle:JGActionSheetButtonStyleGreen forButtonAtIndex:0];
    
    [section_one setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:1];
    [section_one setButtonStyle:JGActionSheetButtonStyleRed forButtonAtIndex:2];
    JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:@[section_one, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:JGActionSheetButtonStyleCancel]]];
    [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
        if(indexPath.section == 0 && indexPath.row == 0){
            BmobObject *bmob_Object = [BmobObject objectWithoutDatatWithClassName:@"CarDetail"  objectId:[_datasourse[selected_index]objectId]];
            [bmob_Object setObject:[NSNumber numberWithFloat:[@"3" floatValue]] forKey:@"flag"];
            NSLog(@"语法可能有问题");
            [bmob_Object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [RKDropdownAlert title:@"车辆已设为转出状态" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
                    [self setupRefresh];
                } else {
                    [SVProgressHUD showErrorWithStatus:@"操作失败"];
                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                }
            }];
        }
        
        
        if (indexPath.section == 0 && indexPath.row == 1) {
            ZhaoCheDetailViewController * view=[self.storyboard instantiateViewControllerWithIdentifier:@"car_detail_view"];
            view.title=@"车辆详情";
            view.carInfoID = [[_datasourse objectAtIndex:selected_index]objectId];
            [self.navigationController pushViewController:view animated:YES];
        }
        
        if (indexPath.section == 0 && indexPath.row == 2) {
        
        }
        
        [sheet dismissAnimated:YES];
        
    }];
    [sheet showInView:self.view animated:YES];
 
}



- (IBAction)huiqv:(UIBarButtonItem *)sender {
}

@end