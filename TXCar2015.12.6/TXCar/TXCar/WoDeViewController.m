//
//  WoDeViewController.m
//  TXCar
//
//  Created by jack on 15/9/17.
//  Copyright (c) 2015年 BH. All rights reserved.
//
#import "RecentViewController.h"
#import "ChatViewController.h"
#import "WoDeViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobUser.h>
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "MysettingViewController.h"
#import "SVProgressHUD.h"
#import "RKDropdownAlert.h"
#import "UIImageView+WebCache.h"
#import "CarRequestListViewController.h"
#import "Pingpp.h"
#import "page1ViewController.h"
#import "MenuViewController.h"
#import "PageviewViewController.h"
#import "MingxiViewController.h"
#import "YuyueViewController.h"
#import "YuyuemaiViewController.h"
#import "RecentChatListTVC.h"
#import "ZaicarViewController.h"
#import "YicarViewController.h"
#import "ShencarViewController.h"
#import "WeicarViewController.h"
#import "MyzhanghuViewController.h"
@interface WoDeViewController ()<UITableViewDataSource,UITableViewDelegate,LoginToMyDelegate,LoginOutDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview_my;
@property (weak, nonatomic) IBOutlet UILabel *zhanghao;
@property (weak, nonatomic) IBOutlet UIButton *denglu;
@property (weak, nonatomic) IBOutlet UIImageView *touxiang;
@property(nonatomic,copy)NSString * type_title;

@end

@implementation WoDeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableview_my.delegate=self;
    _tableview_my.dataSource=self;
    
    _denglu.layer.cornerRadius=5;
    _zhanghao.hidden=YES;
    _touxiang.layer.masksToBounds=YES;
    [Pingpp enableBtn:PingppBtnAlipay|PingppBtnWx];
    

//    LoginViewController * login=[[LoginViewController alloc]init];
//    login.delegate=self;
//    
//    SettingViewController * tuichu=[[SettingViewController alloc]init];
//    tuichu.delegate=self;
    
    UITapGestureRecognizer *tap_image=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_image)];
    tap_image.numberOfTapsRequired = 1;
    _touxiang.userInteractionEnabled = YES;
    [_touxiang addGestureRecognizer:tap_image];
    
  
    UIBarButtonItem *submit_btn = [[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(Setting)];
    self.navigationItem.rightBarButtonItem =submit_btn;
    
    [self login_check];
    
}

-(void)viewWillAppear:(BOOL)animated{
   
      // NSLog(@"%@",[BmobUser getCurrentUser]);
    if ([BmobUser getCurrentUser]!=nil) {
        
        
        NSString * imageuser=[[BmobUser getCurrentUser]objectForKey:@"avatar"];
        NSURL *URL = [NSURL URLWithString:imageuser];
        [_touxiang sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"gerenshezhi_touxiang"]];
    }else{
     //   NSLog(@"1");
        _touxiang.image=[UIImage imageNamed:@"gerenshezhi_touxiang"];
    }
     [_tableview_my reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



-(void)login_check{
   
    BmobUser *bmob_user = [BmobUser getCurrentUser];
    if (bmob_user !=nil) {
        _denglu.hidden=YES;
        _zhanghao.text=[bmob_user objectForKey:@"username"];
        _zhanghao.hidden=NO;
        
    }else{
        _denglu.hidden=NO;
        _zhanghao.hidden=YES;
    }
}





-(void)login_to_my_value:(NSString *)login_state andtelephone:(NSString *)telephone{
    if ([login_state isEqual:@"已登录"]) {
        _denglu.hidden=YES;
        _zhanghao.text=telephone;
        _zhanghao.hidden=NO;
        [_tableview_my reloadData];
    }
}


-(void)login_out:(NSString *)login_state{
    if([login_state isEqual: @"已注销"]){
        _denglu.hidden=NO;
        _zhanghao.hidden=YES;
        [BmobUser logout];
        [SVProgressHUD showInfoWithStatus:@"用户已注销"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
        [_tableview_my reloadData];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section)
    {
            
        case 0:
            return 4;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        default:
            return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 3)
    {
        
        return 10;
        
        
    }
    else if(indexPath.section == 1 && indexPath.row == 1)
        
    {
        
        return 10;
    }else if(indexPath.section == 2 && indexPath.row == 1)
        
    {
        
        return 1;
    }
    
    else
    {
        return 55;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0)
    {
        return 10;
    }
    if(section == 1)
    {
        return 0;
    }
    
    if(section == 2)
    {
        return 0;
    }
    
    else{
        return 0;
    }
    
}



//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if(section == 0)
//    {
//        return nil;
//    }
//    if(section == 1)
//    {
//        return nil;
//    }
//    
// 
//        UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
//        myView.backgroundColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:1];
//        UIImageView* bao = [[UIImageView alloc] initWithFrame:CGRectMake(13,2,40,43)];
//        
//        bao.image = [UIImage imageNamed: @"wode_zhuanche"];
//        [myView addSubview:bao];
//        
//        UILabel* mylabel = [[ UILabel alloc] initWithFrame:CGRectMake(60, 12, 200, 26)];
//        mylabel.text = @"我的转车";
//        mylabel.font = [UIFont systemFontOfSize:17];
//        mylabel.textColor = [UIColor colorWithRed:41/255 green:47/255 blue:51/255 alpha:1];
//        [myView addSubview:mylabel];
//        
//        UIView * myView1= [[UIView alloc] initWithFrame:CGRectMake(0,49,self.view.frame.size.width,1)];
//        myView1.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0  blue: 217/255.0 alpha: 1];
//        [myView  addSubview:myView1];
//        
//        
//        return myView;
//    
//    
//
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
         static NSString *CellIdentifier = @"shoucangche_cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        
        return cell;
    }
    else if(indexPath.section == 0 && indexPath.row == 1)
    {
       static NSString *CellIdentifier = @"zhanghu_cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
    else     if   (indexPath.section == 0 && indexPath.row == 2) {
        static NSString *CellIdentifier = @"goutong_cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        BOOL hadNewMessage = [[NSUserDefaults standardUserDefaults ] boolForKey:@"HadRecieveNewMessage"];
        
        if (hadNewMessage) {
            
            UIView *image1 = (UIView*)[cell viewWithTag:1];
            image1.hidden=NO;
            

        }
        else
        {
            UIView *image1 = (UIView*)[cell viewWithTag:1];
            image1.hidden=YES;
            

        }
        
            return cell;
        
    }
    else     if   (indexPath.section == 0 && indexPath.row == 3) {
       static NSString *CellIdentifier = @"one_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
    else if(indexPath.section == 1 && indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"yuyueing_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
 
    else if(indexPath.section == 1 && indexPath.row == 1)
    {
       static NSString *CellIdentifier = @"two_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
    else if(indexPath.section == 2 && indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"zhuanche_cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
    else if(indexPath.section == 2 && indexPath.row == 1)
    {
        static NSString *CellIdentifier = @"weitongguo_cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
    else if(indexPath.section == 2 && indexPath.row == 2)
    {
       static NSString *CellIdentifier = @"yizhuanche_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"weitianwan_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    if([BmobUser getCurrentUser]==nil){
    [RKDropdownAlert title:@"提示:请登陆后操作" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
        [self performSegueWithIdentifier:@"login_segue" sender:self];
        return;
    }

    if(indexPath.section == 0 && indexPath.row == 0){
        _type_title=@"收藏车辆";
        [self performSegueWithIdentifier:@"car_request_segue" sender:self];
    }
    if(indexPath.section == 0 && indexPath.row == 1){
        _type_title=@"我的账户";
        [self performSegueWithIdentifier:@"wodezhanghu" sender:self];
    }
    if(indexPath.section == 0 && indexPath.row == 2){
        
        RecentChatListTVC *recentChat = [[RecentChatListTVC alloc]initWithStyle:UITableViewStylePlain];
        
        recentChat.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:recentChat animated:YES];
        
        _type_title=@"我的沟通";
 
        [[NSUserDefaults standardUserDefaults]setInteger:NO forKey:@"HadRecieveNewMessage"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
//        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
//        
//        [infoDic setObject:@"71bd4bb1c0" forKey:@"uid"];
//        [infoDic setObject:@"18663886602" forKey:@"name"];
//        
//        
//        ChatViewController *cvc = [[ChatViewController alloc] initWithUserDictionary:infoDic];
//        [self.navigationController pushViewController:cvc animated:YES];

        
        
        
        
        
        
        
        
//        RecentViewController * bubu=[[RecentViewController alloc]init];
//        [self.navigationController pushViewController:bubu animated:YES];
    }
    if(indexPath.section == 1 && indexPath.row == 0){
        _type_title=@"正在预约";
       
        YuyueViewController *oneC = [self.storyboard instantiateViewControllerWithIdentifier:@"yuyue_view"];
            YuyuemaiViewController *one1 = [self.storyboard instantiateViewControllerWithIdentifier:@"yuyue_view1"];
             PageviewViewController *whh = [[PageviewViewController alloc]initViewControllerWithTitleArray:@[@"我买的车",@"我卖的车"] vcArray:@[oneC,one1]];
        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
        [self.navigationController pushViewController:whh animated:YES];
    }
    if(indexPath.section == 2 && indexPath.row == 0){
        ZaicarViewController *one1 = [self.storyboard instantiateViewControllerWithIdentifier:@"zaizhuan"];
        YicarViewController *one2 = [self.storyboard instantiateViewControllerWithIdentifier:@"yizhuan"];
        ShencarViewController *one3 = [self.storyboard instantiateViewControllerWithIdentifier:@"shenhe"];
        WeicarViewController *one4 = [self.storyboard instantiateViewControllerWithIdentifier:@"weitongguo"];
        page1ViewController *whh = [[page1ViewController alloc]initViewControllerWithTitleArray:@[@"在转车",@"已转出",@"审核中",@"未通过"] vcArray:@[one1,one2,one3,one4]];
        
        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
        [self.navigationController pushViewController:whh animated:YES];
        
    }


}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqual:@"login_segue"]){
        UINavigationController * navi=segue.destinationViewController;
        LoginViewController * view=navi.viewControllers[0];
        view.delegate=self;
    }
    if([segue.identifier isEqual:@"setting_segue"]){
        SettingViewController * view=segue.destinationViewController;
        view.delegate=self;
    }
    if([segue.identifier isEqual:@"wodezhanghu"]){
         UINavigationController *navi=segue.destinationViewController;
    }
    
    if([segue.identifier isEqual:@"car_request_segue"]){
        UINavigationController *navi=segue.destinationViewController;
        CarRequestListViewController * view=navi.viewControllers.firstObject;
        view.type_title=_type_title;
    }
    
}

-(void)Setting{
    [self   performSegueWithIdentifier:@"setting_segue" sender: self];
}

- (IBAction)denglujiemian:(UIButton *)sender {
     [self   performSegueWithIdentifier:@"login_segue" sender: self];
}

-(void)tap_image {
    if([BmobUser getCurrentUser]==nil){
       [self   performSegueWithIdentifier:@"login_segue" sender: self];

    }else{

   
    MysettingViewController *detail1 = [self.storyboard instantiateViewControllerWithIdentifier:@"my_massage"];
    [self.navigationController pushViewController:detail1 animated:YES];
}
}


@end
