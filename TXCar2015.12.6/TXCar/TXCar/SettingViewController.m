//
//  SettingViewController.m
//  TXCar
//
//  Created by jack on 15/9/23.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import "SettingViewController.h"
#import "SVProgressHUD.h"
#import "RKDropdownAlert.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobUser.h>
@interface SettingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview_setting;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableview_setting.delegate=self;
    _tableview_setting.dataSource=self;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10,15)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"navbar_return_normal.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismiss2) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    if(section == 0)
    {
        return 4;
    }
    else
    {
        return 1;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"setting_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        UILabel * label = (UILabel*)[cell viewWithTag:1];
        if( indexPath.row == 0 )
        {
            label.text = @"个人中心";
        }
        
        if( indexPath.row == 1 )
        {
            label.text = @"消息通知";
        }
        if( indexPath.row == 2 )
        {
            label.text = @"清理缓存";
        }
        
     
        if( indexPath.row == 3 )
        {
            label.text = @"关于我们";
        }
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"logout_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if(indexPath.section == 0)
    {
        return 46;
    }
    else
    {
        return 42;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0)
    {
        return 15;
    }
    else
    {
        return 5;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        
        [self.delegate login_out:@"已注销"];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults removeObjectForKey:@"password"];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(indexPath.section == 0 && indexPath.row == 3){
        UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://tonghangche.com/m/"]];
        NSURLRequest * request = [NSURLRequest requestWithURL:url];
        [webView loadRequest:request];
        [self.view addSubview:webView];
        
    }else if(indexPath.section == 0 && indexPath.row == 1){
        [SVProgressHUD showErrorWithStatus:@"暂无消息"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    }else if(indexPath.section == 0 && indexPath.row == 2){
        [SVProgressHUD showSuccessWithStatus:@"清理完成"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    }
    else if(indexPath.section == 0 && indexPath.row == 0){
        if([BmobUser getCurrentUser]==nil){
            [RKDropdownAlert title:@"提示:请登陆后操作" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
              return;
        }

        [self performSegueWithIdentifier:@"shezhi1" sender:self];
   }
        else{
        [SVProgressHUD showInfoWithStatus:@"功能未开放"];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    }
    

}

-(void)dismiss2{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)back_clicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
