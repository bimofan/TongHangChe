//
//  CarRequestListViewController.m
//  TXCar
//
//  Created by jack on 15/9/28.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import "CarRequestListViewController.h"
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
#import "ZhaoCheDetailViewController.h"
@interface CarRequestListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview_car_request;
@property(nonatomic,copy)NSMutableArray * datasourse;
@property(nonatomic,copy)NSString * look_user_id;
@property(nonatomic,copy)NSMutableArray *collect_set;
@property (nonatomic,assign) int page;
@end

@implementation CarRequestListViewController
{
    CarDetail * model;
    BmobQuery   *bquery;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _datasourse=[[NSMutableArray alloc]init];
    _collect_set=[[NSMutableArray alloc]init];
    self.title=_type_title;
    [_tableview_car_request addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
    [_tableview_car_request addFooterWithTarget:self action:@selector(footerRereshing)];
//    [self setupRefresh];
    
    
    if ([_type_title isEqual:@"收藏车辆"]) {
      bquery = [BmobQuery queryWithClassName:@"CollectCar"];
        [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            for (BmobObject *obj in array) {
                NSString * carId=[obj objectForKey:@"carId"];
                [_collect_set addObject:carId];
            }
            [self setupRefresh];
           
        }];
    
    }else{
        [self setupRefresh];
    }
}

- (void)setupRefresh
{
    
    [_tableview_car_request headerBeginRefreshing];
}


- (void)headerBeginRefreshing
{
    [_datasourse removeAllObjects];
     [_datasourse removeAllObjects];
    bquery = [BmobQuery queryWithClassName:@"CarDetail"];
    bquery.limit = 10;
    [bquery orderByDescending:@"updatedAt"];
    if ([_type_title isEqual:@"审核中"])
    {
        [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
        [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:0]];
        
    }
    if ([_type_title isEqual:@"转让中"])
    {
        if([_yiyang isEqual:@"DOTA"]){
            [bquery whereKey:@"userId" equalTo:_useridd];
            [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:1]];
            
        }else{
            [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
            [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:1]];
        }
    }
    if ([_type_title isEqual:@"未通过"])
    {
        [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
        [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:2]];
    }
    if ([_type_title isEqual:@"已转出"])
    {
        if([_yiyang isEqual:@"LOL"]){
            [bquery whereKey:@"userId" equalTo:_useridd];
            [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:3]];
            
        }else{
            
            [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
            [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:3]];
        }
    }
    if ([_type_title isEqual:@"收藏车辆"])
    {
        [bquery whereKey:@"objectId" containedIn:_collect_set];
      //  [bquery whereKey:@"flag" greaterThan:[NSNumber numberWithInt:0]];
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
            carmodel.createdAt=[obj createdAt];
            [_datasourse addObject:carmodel];
        }
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableview_car_request reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableview_car_request headerEndRefreshing];
    });
    
}


-(void)footerRereshing{
     bquery = [BmobQuery queryWithClassName:@"CarDetail"];
    if ([_type_title isEqual:@"审核中"])
    {
        [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
        [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:0]];
        
    }
    if ([_type_title isEqual:@"转让中"])
    {
        if([_yiyang isEqual:@"DOTA"]){
            [bquery whereKey:@"userId" equalTo:_useridd];
            [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:1]];
            
        }else{
            [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
            [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:1]];
        }
    }
    if ([_type_title isEqual:@"未通过"])
    {
        [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
        [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:2]];
    }
    if ([_type_title isEqual:@"已转出"])
    {
        if([_yiyang isEqual:@"LOL"]){
            [bquery whereKey:@"userId" equalTo:_useridd];
            [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:3]];
            
        }else{
            
            [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
            [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:3]];
        }
    }
    if ([_type_title isEqual:@"收藏车辆"])
    {
        [bquery whereKey:@"objectId" containedIn:_collect_set];
        [bquery whereKey:@"flag" greaterThan:[NSNumber numberWithInt:0]];
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
        [_tableview_car_request reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableview_car_request footerEndRefreshing];
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
    if ([_type_title isEqual:@"审核中"]) {
        JGActionSheetSection *section_one = [JGActionSheetSection sectionWithTitle:@"正在审核车辆" message:@"请耐心等待管理人员对您发布的信息进行审核" buttonTitles:@[@"删除", @"查看详情"] buttonStyle:JGActionSheetButtonStyleDefault];
        [section_one setButtonStyle:JGActionSheetButtonStyleRed forButtonAtIndex:0];
        [section_one setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:1];
        JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:@[section_one, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:JGActionSheetButtonStyleCancel]]];
        [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            if(indexPath.section == 0 && indexPath.row == 0){
        BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"CarDetail"  objectId:[_datasourse[selected_index]objectId]];
                NSLog(@"语法可能有问题");
        [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        [RKDropdownAlert title:@"删除成功" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
                     //   [self queryCar_bmob];
                        [self setupRefresh];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"删除失败"];
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
            [sheet dismissAnimated:YES];
  
        }];
        [sheet showInView:self.view animated:YES];
    }
    if ([_type_title isEqual:@"未通过"]) {
        JGActionSheetSection *section_one = [JGActionSheetSection sectionWithTitle:@"未审核车辆" message:@"您发布的信息与条款存在不符" buttonTitles:@[@"删除", @"查看详情"] buttonStyle:JGActionSheetButtonStyleDefault];
        [section_one setButtonStyle:JGActionSheetButtonStyleRed forButtonAtIndex:0];
        [section_one setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:1];
        JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:@[section_one, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:JGActionSheetButtonStyleCancel]]];
        [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            if(indexPath.section == 0 && indexPath.row == 0){
                BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"CarDetail"  objectId:[_datasourse[selected_index]objectId]];
                NSLog(@"语法可能有问题");
                [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        [RKDropdownAlert title:@"删除成功" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
                         [self setupRefresh];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"删除失败"];
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
            [sheet dismissAnimated:YES];
            
        }];
        [sheet showInView:self.view animated:YES];
    }
    if ([_type_title isEqual:@"转让中"]) {
        JGActionSheetSection *section_one = [JGActionSheetSection sectionWithTitle:@"正在转让车辆" message:@"您可以对自己正在转让的车辆进行设置" buttonTitles:@[@"已转", @"查看详情"] buttonStyle:JGActionSheetButtonStyleDefault];
         [section_one setButtonStyle:JGActionSheetButtonStyleGreen forButtonAtIndex:0];
       
        [section_one setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:1];
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
            [sheet dismissAnimated:YES];
            
        }];
        [sheet showInView:self.view animated:YES];
    }

    if ([_type_title isEqual:@"已转出"]) {
        JGActionSheetSection *section_one = [JGActionSheetSection sectionWithTitle:@"已经转出车辆" message:@"您可以对自己转出的车辆进行设置" buttonTitles:@[@"转让",@"删除", @"查看详情"] buttonStyle:JGActionSheetButtonStyleDefault];
        [section_one setButtonStyle:JGActionSheetButtonStyleGreen forButtonAtIndex:0];
        [section_one setButtonStyle:JGActionSheetButtonStyleRed forButtonAtIndex:1];
        [section_one setButtonStyle:JGActionSheetButtonStyleBlue forButtonAtIndex:2];
        JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:@[section_one, [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"取消"] buttonStyle:JGActionSheetButtonStyleCancel]]];
        [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            if(indexPath.section == 0 && indexPath.row == 0){
                BmobObject *bmob_Object = [BmobObject objectWithoutDatatWithClassName:@"CarDetail"  objectId:[_datasourse[selected_index]objectId]];
                [bmob_Object setObject:[NSNumber numberWithFloat:[@"1" floatValue]] forKey:@"flag"];
                NSLog(@"语法可能有问题");
                [bmob_Object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        [RKDropdownAlert title:@"车辆已设为转让状态" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
                        [self setupRefresh];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"操作失败"];
                        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                    }
                }];
            }
            if(indexPath.section == 0 && indexPath.row == 1){
                BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"CarDetail"  objectId:[_datasourse[selected_index]objectId]];
                [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        [RKDropdownAlert title:@"删除成功" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
                         [self setupRefresh];
                    } else {
                        [SVProgressHUD showErrorWithStatus:@"删除失败"];
                        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                    }
                }];
            }
            
            if (indexPath.section == 0 && indexPath.row == 2) {
                ZhaoCheDetailViewController * view=[self.storyboard instantiateViewControllerWithIdentifier:@"car_detail_view"];
                view.title=@"车辆详情";
                view.carInfoID = [[_datasourse objectAtIndex:selected_index]objectId];
                [self.navigationController pushViewController:view animated:YES];
            }
            [sheet dismissAnimated:YES];
            
        }];
        [sheet showInView:self.view animated:YES];
    }
    if([_type_title isEqual:@"收藏车辆"]){
        ZhaoCheDetailViewController * view=[self.storyboard instantiateViewControllerWithIdentifier:@"car_detail_view"];
        view.title=@"车辆详情";
        view.carInfoID = [[_datasourse objectAtIndex:indexPath.row]objectId];
        [self.navigationController pushViewController:view animated:YES];
    }
  
}

//-(void)queryCar_bmob{
//    [_datasourse removeAllObjects];
//    [SVProgressHUD showErrorWithStatus:@"加载数据"];
//    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
//    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"CarDetail"];
// 
//    if ([_type_title isEqual:@"审核中"])
//    {
//        [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
//        [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:0]];
//
//    }
//    if ([_type_title isEqual:@"转让中"])
//    {
//        if([_yiyang isEqual:@"DOTA"]){
//            [bquery whereKey:@"userId" equalTo:_useridd];
//            [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:1]];
//        
//    }else{
//        [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
//        [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:1]];
//    }
//}
//    if ([_type_title isEqual:@"未通过"])
//    {
//        [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
//        [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:2]];
//    }
//    if ([_type_title isEqual:@"已转出"])
//    {
//        if([_yiyang isEqual:@"LOL"]){
//            [bquery whereKey:@"userId" equalTo:_useridd];
//            [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:3]];
//            
//        }else{
//
//        [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
//        [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:3]];
//    }
//    }
//    if ([_type_title isEqual:@"收藏车辆"])
//    {
//        [bquery whereKey:@"objectId" containedIn:_collect_set];
//        [bquery whereKey:@"flag" greaterThan:[NSNumber numberWithInt:0]];
//    }
//    [bquery orderByDescending:@"createdAt"];
//    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        for (BmobObject *obj in array) {
//            CarDetail * carmodel=[[CarDetail alloc]init];
//            carmodel.carInfo=[obj objectForKey:@"carInfo"];
//            carmodel.carPic=[obj objectForKey:@"carPic"];
//            carmodel.contactPhone=[obj objectForKey:@"contactPhone"];
//            carmodel.publishTime=[obj objectForKey:@"publishTime"];
//            carmodel.userId=[obj objectForKey:@"userId"];
//            carmodel.contactName=[obj objectForKey:@"contactName"];
//            carmodel.carColor=[obj objectForKey:@"carColor"];
//            carmodel.carLocation=[obj objectForKey:@"carLocation"];
//            carmodel.carNotes=[obj objectForKey:@"carNotes"];
//            carmodel.carPrice=[[obj objectForKey:@"carPrice"]floatValue];
//            carmodel.carYearCheck=[obj objectForKey:@"carYearCheck"];
//            carmodel.flag=(int)[obj objectForKey:@"flag"];
//            carmodel.carDistance=[[obj objectForKey:@"carDistance"]floatValue];
//            carmodel.objectId=[obj objectId];
//            carmodel.createdAt=[obj createdAt];
//            [_datasourse addObject:carmodel];
//        }
//        if(_datasourse.count==0){
//            [RKDropdownAlert title:@"没有查询到数据" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
//        }
//        [_tableview_car_request reloadData];
//        [SVProgressHUD dismiss];
//    }];
//
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)back_button_clicked:(UIBarButtonItem *)sender {
    
    
        [self dismissViewControllerAnimated:YES completion:nil];
   
}



@end
