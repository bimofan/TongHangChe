//
//  ZhaoCheDetailViewController.m
//  TXCar
//
//  Created by jack on 15/9/19.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import "ZhaoCheDetailViewController.h"
#import <BmobSDK/Bmob.h>
#import "CarDetail.h"
#import "FDAlertView.h"
#import "CarImg.h"
#import "UIImageView+WebCache.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobUser.h>
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "MysettingViewController.h"
#import "SVProgressHUD.h"
#import "RKDropdownAlert.h"
#import "CarRequestListViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "YuyueCarTableViewController.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"
#import "gerenxinxiTableViewController.h"
#import "ChatViewController.h"
#import "YMShowImageView.h"
#import "ContantHead.h"
#define kImageTag 9999
@interface ZhaoCheDetailViewController ()<UITableViewDelegate,UITableViewDataSource,FDAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview_car_detail;
@property (nonatomic,copy)NSMutableArray * car_image_list;
@property (nonatomic,copy)NSMutableArray * car_image_view;
@property (nonatomic) BOOL is_collected ;
@property (nonatomic,strong) UIBarButtonItem *collect_btn;
@property (nonatomic,strong) UIBarButtonItem *share_btn;
@property (nonatomic,strong)NSString * delete_id;
@property (nonatomic,strong)NSString * delete_id1;
@end

@implementation ZhaoCheDetailViewController
{
    NSMutableArray * datasource;
    NSMutableArray * datasource1;
    BmobQuery   *bquery;
    CarDetail * carmodel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _is_collected=NO;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10,15)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"navbar_return_normal.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismiss9) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIImageView * image22=[[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 200, 300)];
    [image22 setImage:[UIImage imageNamed:@"xiangqingye_yizhuanche"]] ;
    [_tableview_car_detail bringSubviewToFront:image22];
    
    _tableview_car_detail.dataSource = self;
    _tableview_car_detail.delegate = self;
    datasource=[[NSMutableArray alloc]init];
    _car_image_list=[[NSMutableArray alloc]init];
    _car_image_view=[[NSMutableArray alloc]init];
    
    _collect_btn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Collection" ] style:UIBarButtonItemStylePlain target:self action:@selector(shoucang:)];
    
    _share_btn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Share" ] style:UIBarButtonItemStylePlain target:self action:@selector(fenxiang)];
    NSArray *rightBtns=[NSArray arrayWithObjects:_collect_btn,_share_btn,nil];
    self.navigationItem.rightBarButtonItems =rightBtns;
    
    
    if (_is_collected==NO) {
        _collect_btn.image=[UIImage imageNamed:@"Collection"];
    }
    if (_is_collected==YES) {
        _collect_btn.image=[UIImage imageNamed:@"xiangqingye_shoucang"];
    }
    
    
    
    //    bquery = [BmobQuery queryWithClassName:@"CarDetail"];
    //    [bquery includeKey:@"cUser"];
    //    [bquery getObjectInBackgroundWithId:_carInfoID block:^(BmobObject *object,NSError *error){
    //        if (error){
    //            //进行错误处理
    //        }else{
    //            if (object) {
    //                carmodel=[[CarDetail alloc]init];
    //                carmodel.carInfo=[object objectForKey:@"carInfo"];
    //                carmodel.carPic=[object objectForKey:@"carPic"];
    //                carmodel.contactPhone=[object objectForKey:@"contactPhone"];
    //                carmodel.publishTime=[object objectForKey:@"publishTime"];
    //                carmodel.userId=[object objectForKey:@"userId"];
    //                carmodel.contactName=[object objectForKey:@"contactName"];
    //                carmodel.carColor=[object objectForKey:@"carColor"];
    //                carmodel.carLocation=[object objectForKey:@"carLocation"];
    //                carmodel.carNotes=[object objectForKey:@"carNotes"];
    //                carmodel.flag=[[object objectForKey:@"flag"]floatValue];
    //                carmodel.carPrice=[[object objectForKey:@"carPrice"]floatValue];
    //                carmodel.carYearCheck=[object objectForKey:@"carYearCheck"];
    //                carmodel.carDistance=[[object objectForKey:@"carDistance"]floatValue];
    //                carmodel.userId=[object objectForKey:@"userId"];
    //                carmodel.cUser=[object objectForKey:@"cUser"];
    //                carmodel.objectId=[object objectId];
    //                carmodel.createdAt=[object createdAt];
    //                [datasource addObject:carmodel];
    //
    //
    //
    //            }
    //
    //        }
    //
    //    }];
    
}







-(void)viewWillAppear:(BOOL)animated{
    bquery = [BmobQuery queryWithClassName:@"CarDetail"];
    [bquery includeKey:@"cUser"];
    [bquery getObjectInBackgroundWithId:_carInfoID block:^(BmobObject *object,NSError *error){
        if (error){
            //进行错误处理
        }else{
            if (object) {
                carmodel=[[CarDetail alloc]init];
                carmodel.carInfo=[object objectForKey:@"carInfo"];
                carmodel.carPic=[object objectForKey:@"carPic"];
                carmodel.contactPhone=[object objectForKey:@"contactPhone"];
                carmodel.publishTime=[object objectForKey:@"publishTime"];
                carmodel.userId=[object objectForKey:@"userId"];
                carmodel.contactName=[object objectForKey:@"contactName"];
                carmodel.carColor=[object objectForKey:@"carColor"];
                carmodel.carLocation=[object objectForKey:@"carLocation"];
                carmodel.carNotes=[object objectForKey:@"carNotes"];
                carmodel.flag=[[object objectForKey:@"flag"]floatValue];
                carmodel.carPrice=[[object objectForKey:@"carPrice"]floatValue];
                carmodel.carYearCheck=[object objectForKey:@"carYearCheck"];
                carmodel.carDistance=[[object objectForKey:@"carDistance"]floatValue];
                carmodel.userId=[object objectForKey:@"userId"];
                carmodel.cUser=[object objectForKey:@"cUser"];
                carmodel.objectId=[object objectId];
                carmodel.createdAt=[object updatedAt];
                _fff=carmodel.flag;
                [datasource addObject:carmodel];
            }
            //  [_tableview_car_detail reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self query_car_image];
                [self query_car_collect];
                
                
            });
            
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)fenxiang{
    
    NSArray* imageArray = @[[UIImage imageNamed:@"60-60-0"]];
    // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"来自同行车APP %@_%@万公里_ %@万元\n更多详情:",carmodel.carInfo,[NSString stringWithFormat:@"%.00f",carmodel.carDistance],[NSString stringWithFormat:@"%.f",carmodel.carPrice]]
                                         images:imageArray
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"http://tonghangche.com/h5/car_detail.html?objectId=%@",carmodel.objectId]]
                                          title:[NSString stringWithFormat:@"%@_%@_%@万公里_%@万元",carmodel.carInfo,carmodel.carYearCheck,[NSString stringWithFormat:@"%.00f",carmodel.carDistance],[NSString stringWithFormat:@"%.f",carmodel.carPrice]]
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:@[
                                        
                                         @(SSDKPlatformTypeWechat),
                                         @(SSDKPlatformTypeQQ),
                                         ]
         
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                       
                   }];
        
    }
}

-(void)shoucang:(UIBarButtonItem*)sender{
    if([BmobUser getCurrentUser]==nil){
        [RKDropdownAlert title:@"提示:请登陆后操作" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
        [self performSegueWithIdentifier:@"cardetail_to_login_segue" sender:self];
        return;
    }else{
        _is_collected=!_is_collected;
        if (_is_collected==NO) {
            [SVProgressHUD showErrorWithStatus:@"请稍后"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            BmobQuery *  bquery1 = [BmobQuery queryWithClassName:@"CollectCar"];
            
            [bquery1 whereKey:@"carId" equalTo:carmodel.objectId];
            [bquery1 whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
            [bquery1 findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                for (BmobObject *obj in array) {
                    
                    _delete_id=obj.objectId;
                }
                
                BmobObject *bmob_obj = [BmobObject objectWithoutDatatWithClassName:@"CollectCar"  objectId:_delete_id];
                
                [bmob_obj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        [SVProgressHUD dismiss];
                        [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
                        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                        sender.image=[UIImage imageNamed:@"Collection"];
                        
                    }else{
                        [SVProgressHUD dismiss];
                        [SVProgressHUD showInfoWithStatus:@"取消收藏失败 "];
                        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                        _is_collected=YES;
                    }
                }];
            }];
        }
        if (_is_collected==YES) {
            [SVProgressHUD showErrorWithStatus:@"请稍后"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            BmobObject  *bhbh = [BmobObject objectWithClassName:@"CollectCar"];
            [bhbh setObject:carmodel.carInfo forKey:@"carInfo"];
            [bhbh setObject:carmodel.contactPhone forKey:@"contactPhone"];
            [bhbh setObject:carmodel.carColor forKey:@"carColor"];
            [bhbh setObject:carmodel.carLocation forKey:@"carLocation"];
            [bhbh setObject:carmodel.carInfo forKey:@"carInfo"];
            [bhbh setObject:[NSNumber numberWithInt:carmodel.flag] forKey:@"flag"];
            [bhbh setObject:[BmobUser getCurrentUser].objectId forKey:@"userId"];
            [bhbh setObject:carmodel.objectId forKey:@"carId"];
            [bhbh setObject:carmodel.carNotes forKey:@"carNotes"];
            [bhbh setObject:[NSNumber numberWithFloat:carmodel.carPrice] forKey:@"carPrice"];
            [bhbh setObject:carmodel.contactPhone forKey:@"contactName"];
            [bhbh setObject:[NSNumber numberWithFloat:carmodel.carDistance] forKey:@"carDistance"];
            [bhbh setObject:carmodel.carYearCheck forKey:@"carYearCheck"];
            [bhbh setObject:[NSNumber numberWithInt:0] forKey:@"publishTime"];
            
            [bhbh saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                    sender.image=[UIImage imageNamed:@"xiangqingye_shoucang"];
                }else{
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:@"收藏失败"];
                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                    _is_collected=NO;
                }
            }];
        }
    }
}

-(void)query_car_collect{
    BmobQuery *  bquery2 = [BmobQuery queryWithClassName:@"CollectCar"];
    [bquery2 whereKey:@"carId" equalTo:carmodel.objectId];
    if([BmobUser getCurrentUser]!=nil){
        [bquery2 whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
    }else{
        return;
    }
    [bquery2 findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject * obj in array) {
            _delete_id1=obj.objectId;
        }
        if (_delete_id1 !=nil) {
            _is_collected=YES;
            _collect_btn.image=[UIImage imageNamed:@"xiangqingye_shoucang"];
            
        }
    }];
}

-(void)query_car_image
{
    bquery = [BmobQuery queryWithClassName:@"CarImg"];
    [bquery whereKey:@"carId" equalTo:_carInfoID];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            
            CarImg * item = [[CarImg alloc]init];
            
            item.carId = [obj objectForKey:@"carId"];
            item.imgName = [obj objectForKey:@"imgName"];
            item.url = [obj objectForKey:@"url"];
            
            [_car_image_list addObject:item];
            
            
        }
        //        for (NSString * asd in _car_image_list) {
        //            NSLog(@"%@",asd);
        //        }
        
        [_tableview_car_detail reloadData];
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section)
    {
        case 0:
            return 3;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 1;
            break;
        default:
            return 0;
            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
    {
        return nil;
    }
    
    
    
    if(section == 1)
    {
        if([[carmodel.cUser objectForKey:@"hasPayFund"]intValue]==0){
            UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
            myView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0  blue: 248/255.0 alpha: 1];
            
            UIImageView* bao = [[UIImageView alloc] initWithFrame:CGRectMake(21,13,40,43)];
            
            bao.image = [UIImage imageNamed:@"weijiao_baozhengjn"];
            [myView addSubview:bao];
            
            UILabel* mylabel = [[ UILabel alloc] initWithFrame:CGRectMake(75, 10, 200, 26)];
            mylabel.text = @"商家未缴纳信誉保证金";
            
            mylabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
            
            [myView addSubview:mylabel];
            
            UIImageView* duigou = [[UIImageView alloc] initWithFrame:CGRectMake(75,40,13,13)];
            
            duigou.image = [UIImage imageNamed:@"weijiao_fuhao"];
            [myView addSubview:duigou];
            
            UIImageView* duigou1 = [[UIImageView alloc] initWithFrame:CGRectMake(190,40,13,13)];
            
            duigou1.image = [UIImage imageNamed:@"weijiao_fuhao"];
            [myView addSubview:duigou1];
            
            
            UILabel* mylabel1 = [[ UILabel alloc] initWithFrame:CGRectMake(93, 35, 80, 20)];
            mylabel1.text = @"保障买家定金";
            
            mylabel1.textColor =[UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1.0];
            
            mylabel1.font = [UIFont systemFontOfSize:12];
            
            UILabel* mylabel2 = [[ UILabel alloc] initWithFrame:CGRectMake(208, 35, 80, 20)];
            mylabel2.text = @"保证卖家信誉";
            mylabel2.font = [UIFont systemFontOfSize:12];
            mylabel2.textColor = [UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1.0];
            
            //             mylabel1.font = UIFont?(name: nil, size:11)
            
            
            UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(handleSingleFingerEvent)];
            singleFingerOne.numberOfTouchesRequired = 1; //手指数
            singleFingerOne.numberOfTapsRequired = 1; //tap次数
            
            
            [myView addGestureRecognizer:singleFingerOne];
            
            
            [myView addSubview:mylabel1];
            [myView addSubview:mylabel2];
            
            return myView;
        }else{
            UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
            myView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0  blue: 248/255.0 alpha: 1];
            
            UIImageView* bao = [[UIImageView alloc] initWithFrame:CGRectMake(21,13,40,43)];
            
            bao.image = [UIImage imageNamed:@"xiangqingye_baozheng"];
            [myView addSubview:bao];
            
            UILabel* mylabel = [[ UILabel alloc] initWithFrame:CGRectMake(75, 10, 200, 26)];
            mylabel.text = @"商家已缴纳信誉保证金";
            
            mylabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
            
            [myView addSubview:mylabel];
            
            UIImageView* duigou = [[UIImageView alloc] initWithFrame:CGRectMake(75,40,13,13)];
            
            duigou.image = [UIImage imageNamed:@"xiangqingye_duihao"];
            [myView addSubview:duigou];
            
            UIImageView* duigou1 = [[UIImageView alloc] initWithFrame:CGRectMake(190,40,13,13)];
            
            duigou1.image = [UIImage imageNamed:@"xiangqingye_duihao"];
            [myView addSubview:duigou1];
            
            
            UILabel* mylabel1 = [[ UILabel alloc] initWithFrame:CGRectMake(93, 35, 80, 20)];
            mylabel1.text = @"保障买家定金";
            
            mylabel1.textColor =[UIColor colorWithRed:39/255.0 green:151/255.0 blue:1/255.0 alpha:1.0];
            
            mylabel1.font = [UIFont systemFontOfSize:12];
            
            UILabel* mylabel2 = [[ UILabel alloc] initWithFrame:CGRectMake(208, 35, 80, 20)];
            mylabel2.text = @"保证卖家信誉";
            mylabel2.font = [UIFont systemFontOfSize:12];
            mylabel2.textColor = [UIColor colorWithRed:39/255.0 green:151/255.0 blue:1/255.0 alpha:1.0];
            
            //             mylabel1.font = UIFont?(name: nil, size:11)
            
            
            UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(handleSingleFingerEvent)];
            singleFingerOne.numberOfTouchesRequired = 1; //手指数
            singleFingerOne.numberOfTapsRequired = 1; //tap次数
            //  singleFingerOne.delegate = self;
            
            [myView addGestureRecognizer:singleFingerOne];
            
            
            [myView addSubview:mylabel1];
            [myView addSubview:mylabel2];
            
            return myView;
            
        }
    }
    else if(section == 2)
    {
        UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
        myView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0  blue: 248/255.0 alpha: 1];
        
        UIImageView* duigou1 = [[UIImageView alloc] initWithFrame:CGRectMake(15,7,10,15)];
        duigou1.image = [UIImage imageNamed: @"xiangqingye_shutiao"];
        [myView addSubview:duigou1];
        
        
        UILabel* mylabel1 = [[ UILabel alloc] initWithFrame:CGRectMake(45, 6, 120, 18)];
        mylabel1.text = @"车辆基本信息";
        mylabel1.textColor = [UIColor colorWithRed:90/255 green:90/255 blue:90/255 alpha:1];
        [myView addSubview:mylabel1];
        
        return myView;
    }
    else if(section == 3)
    {
        UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
        myView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0  blue: 248/255.0 alpha: 1];
        
        UIImageView* duigou1 = [[UIImageView alloc] initWithFrame:CGRectMake(15,7,10,15)];
        duigou1.image = [UIImage imageNamed: @"xiangqingye_shutiao"];
        [myView addSubview:duigou1];
        
        UILabel* mylabel1 = [[ UILabel alloc] initWithFrame:CGRectMake(45, 6, 120, 18)];
        mylabel1.text = @"卖家描述";
        mylabel1.textColor = [UIColor colorWithRed:90/255 green:90/255 blue:90/255 alpha:1];
        [myView addSubview:mylabel1];
        
        return myView;
        
    }
    
    else{
        UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
        myView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0  blue: 248/255.0 alpha: 1];
        
        UIImageView* duigou1 = [[UIImageView alloc] initWithFrame:CGRectMake(15,7,10,15)];
        duigou1.image = [UIImage imageNamed: @"xiangqingye_shutiao"];
        [myView addSubview:duigou1];
        
        UILabel* mylabel1 = [[ UILabel alloc] initWithFrame:CGRectMake(45, 6, 120, 18)];
        mylabel1.text = @"卖家信息";
        mylabel1.textColor = [UIColor colorWithRed:90/255 green:90/255 blue:90/255 alpha:1];
        [myView addSubview:mylabel1];
        
        return myView;
        
    }
}

-(void)handleSingleFingerEvent{
    [self performSegueWithIdentifier:@"jiaoqian1" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
    {
        return 0.01;
    }
    if(section == 1)
    {
        return 70;
    }
    
    if(section == 2)
    {
        return 30;
    }
    if(section == 3)
    {
        return 30;
    }
    
    if(section == 4)
    {
        return 30;
    }
    else{
        return 0;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0){
            return 240;
        }else if (indexPath.row == 1){
            return 40;
        }else
        {
            return 25;
        }
        
    }
    else if(indexPath.section == 1)
        
    {
        return 13;
    }
    
    else if(indexPath.section == 2)
    {
        return 151;
    }
    else if(indexPath.section == 3)
    {
        return 125;
    }
    else
    {
        return 50;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *CellIdentifier = @"car_detail_one_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell==nil) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            UIView * view1=(UIView*)[cell viewWithTag:1];
            //            var view1 = cell?.viewWithTag(1)
            UIScrollView * scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, view1.bounds.size.width, view1.bounds.size.height)];
            //            var scroll = UIScrollView(frame: CGRectMake(0, 0, view1!.bounds.width, view1!.bounds.height))
            scroll.pagingEnabled=YES;
            //            scroll.pagingEnabled = true
            scroll.scrollEnabled =YES;
            //            scroll.scrollEnabled = true
            scroll.showsHorizontalScrollIndicator=YES;
            //            scroll.showsHorizontalScrollIndicator = true
            scroll.contentSize=CGSizeMake(view1.bounds.size.width*_car_image_list.count, view1.bounds.size.height);
            //            scroll.contentSize = CGSize(width: view1!.bounds.width * CGFloat(self.car_image_list.count), height: view1!.bounds.height)
            
            [view1 addSubview:scroll];
            
            
            //            view1?.addSubview(scroll)
            for(int i = 0 ; i < _car_image_list.count ; i++)
            {
                
                
                UIImageView* image_view = [[UIImageView alloc] initWithFrame:CGRectMake(i * view1.bounds.size.width, 0, view1.bounds.size.width, view1.bounds.size.height)];
                CarImg * uurrll=[ _car_image_list objectAtIndex:i];
                NSURL *URL = [NSURL URLWithString:uurrll.url];
                [image_view sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"loading-image"]];
                
                image_view.contentMode=UIViewContentModeScaleAspectFill;
                
                UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView1:)];
                image_view.backgroundColor = [UIColor clearColor];
                image_view.tag = kImageTag + i;
                
                
                
                //              UITapGestureRecognizer *tap_image = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_image1:)];
                //
                //                tap_image.numberOfTapsRequired = 1;
                //                 image_view.tag = 100 + i;
                image_view.userInteractionEnabled = YES;
                //                [image_view addGestureRecognizer:tap_image];
                [image_view addGestureRecognizer:tap];
                [_car_image_view addObject:URL];
                [scroll addSubview:image_view];
                
                
            }
            
            
            UIImageView *iii=(UIImageView*)[cell viewWithTag:20];
            if (_fff==4) {
                iii.hidden=NO;
                iii.image=[UIImage imageNamed:@"xiangqingye_yiyuding"];
            }else if(_fff==3){
                iii.hidden=NO;
                iii.image=[UIImage imageNamed:@"xiangqingye_yizhuanche"];
            }else{
                NSLog(@"3");
                iii.hidden=YES;
            }
            
            
            UILabel * lable3=(UILabel*)[cell viewWithTag:3];
            lable3.text=carmodel.carInfo;
            return cell;
            
        }
        else  if(indexPath.row == 1){
            
            static NSString *CellIdentifier = @"car_detail_two_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell==nil) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            UILabel * lable4=(UILabel*)[cell viewWithTag:4];
            NSString * ccc=[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:carmodel.carPrice]];
            NSString * cccc=[ccc stringByAppendingString:@"万元"];
            if([ccc intValue]==0){
                lable4.text=@"电议";
            }else{
                lable4.text=cccc;
            }

            return cell;
            
        }
        else {
            
            static NSString *CellIdentifier = @"car_detail_san_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell==nil) {
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            
            UILabel * lable5=(UILabel*)[cell viewWithTag:5];
            NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
            [formatter setLocale:[NSLocale currentLocale]];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString * create_date=[formatter stringFromDate:carmodel.createdAt];
            lable5.text = create_date;
            return  cell;
        }
        //
        //                var label6 = cell?.viewWithTag(6) as! UILabel
        //
        //                label6.text = ""
        //
        //                if(self.car_detail_info.isPriceTalk == true)
        //                {
        //                    label6.text = "电议"
        //                }
        //
        //                if(self.car_detail_info.flag == 3)
        //                {
        //                    label6.text = "已转出"
        //                }
        
        
        
    }
    else if(indexPath.section == 1 )
    {
        static NSString *CellIdentifier = @"tebieduo";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        return cell;
    }
    
    
    
    else if(indexPath.section == 2)
    {
        
        
        static NSString *CellIdentifier = @"car_detail_si_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        //        UILabel * lable4=(UILabel*)[cell viewWithTag:4];
        //        NSString * ccc=[NSString stringWithFormat:@"%.f",carmodel.carPrice];
        //        NSString * cccc=[ccc stringByAppendingString:@"万元"];
        //        lable4.text = cccc;
        
        UILabel * lable1=(UILabel*)[cell viewWithTag:1];
        lable1.text = carmodel.carLocation;
        
        UILabel * lable2=(UILabel*)[cell viewWithTag:2];
        NSString * bbb=[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:carmodel.carDistance]];
        NSString * bbbb=[bbb stringByAppendingString:@" 万公里"];
        lable2.text = bbbb;
        
        UILabel * lable3=(UILabel*)[cell viewWithTag:3];
        lable3.text = carmodel.carColor;
        
        UILabel * lable4=(UILabel*)[cell viewWithTag:4];
        lable4.text = carmodel.carYearCheck;
        
        return cell;
        
    }
    
    else if(indexPath.section == 3)
    {
        static NSString *CellIdentifier = @"car_user_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UITextView * text_view=(UITextView*)[cell viewWithTag:1];
        
        text_view.text =carmodel.carNotes;
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"car_button_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIImageView * tu1=( UIImageView*)[cell viewWithTag:111];
        if([[carmodel.cUser objectForKey:@"rateDes"] intValue]/[[carmodel.cUser objectForKey:@"commentNum"]intValue]==1){
            tu1.image=[UIImage imageNamed:@"pingjia_xingxing"];
        }else
            if([[carmodel.cUser objectForKey:@"rateDes"] intValue]/[[carmodel.cUser objectForKey:@"commentNum"]intValue]==2){
                tu1.image=[UIImage imageNamed:@"pingjia_xingxing2"];
            }else
                if([[carmodel.cUser objectForKey:@"rateDes"] intValue]/[[carmodel.cUser objectForKey:@"commentNum"]intValue]==3){
                    tu1.image=[UIImage imageNamed:@"pingjia_xingxing3"];
                }else
                    if([[carmodel.cUser objectForKey:@"rateDes"]intValue]/[[carmodel.cUser objectForKey:@"commentNum"]intValue]==4){
                        tu1.image=[UIImage imageNamed:@"pingjia_xingxing4"];
                    }else
                        if([[carmodel.cUser objectForKey:@"rateDes"] intValue]/[[carmodel.cUser objectForKey:@"commentNum"]intValue]==5){
                            tu1.image=[UIImage imageNamed:@"pingjia_xingxing5"];
                        }else{
                            tu1.image=[UIImage imageNamed:@"pingjia_xingxing5"];
                        }

        if([[carmodel.cUser objectForKey:@"hasPayFund"]intValue]==0){
             UIImageView * tu2=( UIImageView*)[cell viewWithTag:112];
            tu2.hidden=YES;
        }
        
        UILabel * contact_label=(UILabel*)[cell viewWithTag:8];
        contact_label.text =carmodel.contactName;
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        if([BmobUser getCurrentUser]==nil){
            [RKDropdownAlert title:@"提示:请登陆后操作" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
            [self performSegueWithIdentifier:@"cardetail_to_login_segue" sender:self];
            return;
        }
        if(carmodel.flag==4){
            [RKDropdownAlert title:@"提示:车辆已经被预定" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
            return;
        }
        
        if([[carmodel.cUser objectId] isEqual:[[BmobUser getCurrentUser]objectId]]){
            [RKDropdownAlert title:@"提示:不能预定自己发布的车辆" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
            return;
            
        }
        
        
        
        if(carmodel.flag==3){
            [RKDropdownAlert title:@"提示:车辆已经转出" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
            return;
        }
        YuyueCarTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"zhifu_xinxi"];
        detail.facherenId=carmodel.userId;
        detail.models=carmodel;
        [self.navigationController pushViewController:detail animated:YES];
        
    }
    
    if (indexPath.section == 4 && indexPath.row == 0) {
        if([BmobUser getCurrentUser]==nil){
            [RKDropdownAlert title:@"提示:请登陆后操作" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
            [self performSegueWithIdentifier:@"cardetail_to_login_segue" sender:self];
            return;
        }
        gerenxinxiTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"gerenxinxi1"];
        detail.models=carmodel;
        [self.navigationController pushViewController:detail animated:YES];
        
    }
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

- (void)tapImageView1:(UITapGestureRecognizer *)tapGes{
    
    [self showImageViewWithImageViews:_car_image_view byClickWhich:tapGes.view.tag];
    
}


//-(void)tap_image1:(UITapGestureRecognizer *)sender{
//        NSInteger i=sender.view.tag;
//        JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
//    imageInfo.imageURL =_car_image_view[i-100];
//    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
//                                           initWithImageInfo:imageInfo
//                                           mode:JTSImageViewControllerMode_Image
//                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
//
//
//    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
//
//}
- (IBAction)fudingjin:(UIButton *)sender {
    if([BmobUser getCurrentUser]==nil){
        [RKDropdownAlert title:@"提示:请登陆后操作" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
        [self performSegueWithIdentifier:@"cardetail_to_login_segue" sender:self];
        return;
    }
    YuyueCarTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"zhifu_xinxi"];
    detail.facherenId=carmodel.userId;
    detail.models=carmodel;
    [self.navigationController pushViewController:detail animated:YES];
}
- (IBAction)dadianhua:(UIButton *)sender {
    if([BmobUser getCurrentUser]==nil){
        [RKDropdownAlert title:@"提示:请登陆后操作" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
        [self performSegueWithIdentifier:@"cardetail_to_login_segue" sender:self];
        return;
    }
    FDAlertView *alert = [[FDAlertView alloc] initWithTitle:@"提示" icon:nil message:@"是否打电话给TA?" delegate:self buttonTitles:@"取消", @"确定", nil];
    alert.tag=1;
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",carmodel.contactPhone]]];
    }
}

#pragma mark -  在线沟通
- (IBAction)chatAction:(id)sender {
    
    if([BmobUser getCurrentUser]==nil){
        [RKDropdownAlert title:@"提示:请登陆后操作" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
        [self performSegueWithIdentifier:@"cardetail_to_login_segue" sender:self];
        return;
    }
    
    
    User *chatUser = carmodel.cUser;
    
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    
    [infoDic setObject:chatUser.objectId forKey:@"uid"];
    [infoDic setObject:chatUser.username forKey:@"name"];
    //    [infoDic setObject:chatUser.username forKey:@"nick"];
    
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

-(void)dismiss9{
    if (_asd==1) {
        
    [self dismissViewControllerAnimated:YES completion:nil];
    }else{
    [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)huiqv:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
