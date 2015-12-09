//
//  zhifuchenggongTableViewController.m
//  TXCar
//
//  Created by jack on 15/10/19.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "zhifuchenggongTableViewController.h"
#import "GoyuyueTableViewController.h"
#import "ZhaoCheDetailViewController.h"
#import "Header.h"
#import "GUAAlertView.h"
@interface zhifuchenggongTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *mingzi;
@property (weak, nonatomic) IBOutlet UILabel *jiage;

@end

@implementation zhifuchenggongTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   self.title=@"联系卖家";
    NSString * cccc=[_jiage1 stringByAppendingString:@"万元"];
    _mingzi.text=_name;
    _jiage.text=cccc;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10,15)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"navbar_return_normal.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

-(void)dismiss{
    ZhaoCheDetailViewController *detail =self.navigationController.viewControllers[2];
    
    [self.navigationController popToViewController:detail animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }else{
        return 5;
    }
}
- (IBAction)dadianhua:(UIButton *)sender {
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"提示\n\n是否打电话联系卖家?\n\n%@  电话:%@",_contactName,_contactPhone] message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认拨打", nil];
    alert.tag=1;
    [alert show];
}
- (IBAction)xiayibu:(UIButton *)sender {
    GoyuyueTableViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"zhifu_xinxi4"];
    detail.name=_name;
    detail.jiage1=_jiage1;
    [self.navigationController pushViewController:detail animated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_contactPhone]]];
        }
    if(buttonIndex==0){
        if(alertView.tag==111){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%d",KEFU_PHONE]]];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0&&indexPath.row==0) {
        return 10;
    }else if(indexPath.section==0&&indexPath.row==1){
        return 40;
    }else if(indexPath.section==1&&indexPath.row==0){
        return 10;
    }else if(indexPath.section==1&&indexPath.row==1){
        return 70;
    }else if(indexPath.section==1&&indexPath.row==2){
        return 55;
    }else if(indexPath.section==1&&indexPath.row==3){
        return 140;
    }else{
        return [UIScreen mainScreen].bounds.size.height-185-64-140;
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
