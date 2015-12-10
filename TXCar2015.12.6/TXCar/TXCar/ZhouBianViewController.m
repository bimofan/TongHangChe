//
//  ZhouBianViewController.m
//  TXCar
//
//  Created by jack on 15/9/17.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import "ZhouBianViewController.h"
#import "WXViewController.h"
#import "ContantHead.h"
#import "ChadangTableViewController.h"
#import "MenuViewController.h"
#import "YuyueViewController.h"
#import "YuyuemaiViewController.h"
#import "shixinViewController.h"
#import "WeiGuiViewController.h"

@interface ZhouBianViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *zhoubian_tableview;

@end

@implementation ZhouBianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _zhoubian_tableview.delegate=self;
    _zhoubian_tableview.dataSource=self;
    
       self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
   
    static NSString *CellIdentifier = @"tongxingshuo_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    return cell;
    }else  if (indexPath.section == 1 && indexPath.row == 0){
        static NSString *CellIdentifier = @"heimingdan_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"weizhang_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0){
        WXViewController *wxVc = [WXViewController new];
        wxVc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wxVc animated:YES];
    }else if (indexPath.section == 1){
      shixinViewController *oneC = [self.storyboard instantiateViewControllerWithIdentifier:@"shixin"];
 
//        YuyueViewController *oneC = [self.storyboard instantiateViewControllerWithIdentifier:@"yuyue_view"];
//        YuyuemaiViewController *one1 = [self.storyboard instantiateViewControllerWithIdentifier:@"yuyue_view1"];
//      cac = [[ppViewController alloc]initViewControllerWithTitleArray:@[@"失信",@"诉讼"] vcArray:@[oneC,one1]];
        [self.navigationController pushViewController:oneC animated:YES];
    }
    else if (indexPath.section == 2)
    {
        WeiGuiViewController *_weiguiVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WeiGuiViewController"];
        
        _weiguiVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:_weiguiVC animated:YES];
        
    }
}

@end
