//
//  gerenxinxiTableViewController.m
//  TXCar
//
//  Created by jack on 15/10/21.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "gerenxinxiTableViewController.h"
#import "UIImageView+WebCache.h"
#import "CarRequestListViewController.h"
#import "pinglunViewController.h"
#import "ChatViewController.h"
#import "ZaicarViewController.h"
#import "YicarViewController.h"
@interface gerenxinxiTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *touxiang1;
@property (weak, nonatomic) IBOutlet UILabel *mingzi1;

@property (weak, nonatomic) IBOutlet UILabel *riqi1;
@property (weak, nonatomic) IBOutlet UILabel *haopinglv;
@property (weak, nonatomic) IBOutlet UIImageView *xiangfudu;
@property (weak, nonatomic) IBOutlet UIImageView *fuwutaidu;
@property (weak, nonatomic) IBOutlet UIImageView *xiaotupian;
@property (weak, nonatomic) IBOutlet UILabel *xiaotupianTITLE;

@end

@implementation gerenxinxiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(_tagg==1){
        NSString * userid=[[BmobUser getCurrentUser]objectId];
        BmobQuery *query = [BmobUser query];
        [query whereKey:@"objectId" equalTo:userid];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            for (BmobUser *user in array) {
                
                if([[user objectForKey:@"hasPayFund"]intValue]==1){
                    _xiaotupian.image=[UIImage imageNamed:@"shouye_baozhang"];
                    _xiaotupianTITLE.text=@"已缴纳保证金";
                    _xiaotupianTITLE.textColor=[UIColor colorWithRed:39/255.0 green:151/255.0 blue:1/255.0 alpha:1];
                    
                }

                
                
                
                NSString * imageuser=[user objectForKey:@"avatar"];
                NSURL *URL = [NSURL URLWithString:imageuser];
                [_touxiang1 sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"gerenshezhi_touxiang"]];
                _mingzi1.text=[user objectForKey:@"contact"];
             
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString *strDate = [dateFormatter stringFromDate:user.createdAt];
                _riqi1.text=strDate;
                _haopinglv.text=[NSString stringWithFormat:@"%d％",(int)[user objectForKey:@"rateMain"]*20/(int)[user objectForKey:@"commentNum"]];
                if([[_models.cUser objectForKey:@"rateDes"] intValue]/[[_models.cUser objectForKey:@"commentNum"]intValue]==1){
                    _xiangfudu.image=[UIImage imageNamed:@"pingjia_xingxing"];
                }else
                    if([[_models.cUser objectForKey:@"rateDes"] intValue]/[[_models.cUser objectForKey:@"commentNum"]intValue]==2){
                        _xiangfudu.image=[UIImage imageNamed:@"pingjia_xingxing2"];
                    }else
                        if([[_models.cUser objectForKey:@"rateDes"] intValue]/[[_models.cUser objectForKey:@"commentNum"]intValue]==3){
                            _xiangfudu.image=[UIImage imageNamed:@"pingjia_xingxing3"];
                        }else
                            if([[_models.cUser objectForKey:@"rateDes"]intValue]/[[_models.cUser objectForKey:@"commentNum"]intValue]==4){
                                _xiangfudu.image=[UIImage imageNamed:@"pingjia_xingxing4"];
                            }else
                                if([[_models.cUser objectForKey:@"rateDes"] intValue]/[[_models.cUser objectForKey:@"commentNum"]intValue]==5){
                                    _xiangfudu.image=[UIImage imageNamed:@"pingjia_xingxing5"];
                                }else{
                                    _xiangfudu.image=[UIImage imageNamed:@"pingjia_xingxing5"];
                                }
                
               
                if([[_models.cUser objectForKey:@"rateServe"] intValue]/5==1){
                    _fuwutaidu.image=[UIImage imageNamed:@"pingjia_xingxing"];
                }else
                    if([[_models.cUser objectForKey:@"rateServe"] intValue]/5==2){
                        _fuwutaidu.image=[UIImage imageNamed:@"pingjia_xingxing2"];
                    }else
                        if([[_models.cUser objectForKey:@"rateServe"] intValue]/5==3){
                            _fuwutaidu.image=[UIImage imageNamed:@"pingjia_xingxing3"];
                        }else
                            if([[_models.cUser objectForKey:@"rateServe"]intValue]/5==4){
                                _fuwutaidu.image=[UIImage imageNamed:@"pingjia_xingxing4"];
                            }else
                                if([[_models.cUser objectForKey:@"rateServe"] intValue]/5==5){
                                    _fuwutaidu.image=[UIImage imageNamed:@"pingjia_xingxing5"];
                                }else{
                                    _fuwutaidu.image=[UIImage imageNamed:@"pingjia_xingxing5"];
                                }
                
                
            }
            
        }];

        
        
            }
    else
    {
        
        if([[_models.cUser objectForKey:@"hasPayFund"]intValue]==1){
            _xiaotupian.image=[UIImage imageNamed:@"shouye_baozhang"];
            _xiaotupianTITLE.text=@"已缴纳保证金";
            _xiaotupianTITLE.textColor=[UIColor colorWithRed:39/255.0 green:151/255.0 blue:1/255.0 alpha:1];
            
        }

        
        
    NSString * imageuser=[_models.cUser objectForKey:@"avatar"];
    NSURL *URL = [NSURL URLWithString:imageuser];
    [_touxiang1 sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"gerenshezhi_touxiang"]];
    self.title=@"商家详情";
    NSLog(@"%d",_tagg);
    _mingzi1.text=_models.contactName;
    _riqi1.text=(NSString*)_models.cUser.createdAt;
        _haopinglv.text=[NSString stringWithFormat:@"%d％",[[_models.cUser objectForKey:@"rateMain"] intValue
                                                           ]*20/[[_models.cUser objectForKey:@"commentNum"]intValue]];
        NSLog(@"%d",[[_models.cUser objectForKey:@"rateDes"] intValue]);
        if([[_models.cUser objectForKey:@"rateDes"] intValue]/[[_models.cUser objectForKey:@"commentNum"]intValue]==1){
            _xiangfudu.image=[UIImage imageNamed:@"pingjia_xingxing"];
        }else
        if([[_models.cUser objectForKey:@"rateDes"] intValue]/[[_models.cUser objectForKey:@"commentNum"]intValue]==2){
            _xiangfudu.image=[UIImage imageNamed:@"pingjia_xingxing2"];
        }else
        if([[_models.cUser objectForKey:@"rateDes"] intValue]/[[_models.cUser objectForKey:@"commentNum"]intValue]==3){
            _xiangfudu.image=[UIImage imageNamed:@"pingjia_xingxing3"];
        }else
        if([[_models.cUser objectForKey:@"rateDes"]intValue]/[[_models.cUser objectForKey:@"commentNum"]intValue]==4){
            _xiangfudu.image=[UIImage imageNamed:@"pingjia_xingxing4"];
        }else
        if([[_models.cUser objectForKey:@"rateDes"] intValue]/[[_models.cUser objectForKey:@"commentNum"]intValue]==5){
            _xiangfudu.image=[UIImage imageNamed:@"pingjia_xingxing5"];
        }else{
            _xiangfudu.image=[UIImage imageNamed:@"pingjia_xingxing5"];
        }
        
          NSLog(@"%d",[[_models.cUser objectForKey:@"rateServe"] intValue]);
        if([[_models.cUser objectForKey:@"rateServe"] intValue]/[[_models.cUser objectForKey:@"commentNum"]intValue]==1){
            _fuwutaidu.image=[UIImage imageNamed:@"pingjia_xingxing"];
        }else
        if([[_models.cUser objectForKey:@"rateServe"] intValue]/[[_models.cUser objectForKey:@"commentNum"]intValue]==2){
            _fuwutaidu.image=[UIImage imageNamed:@"pingjia_xingxing2"];
        }else
        if([[_models.cUser objectForKey:@"rateServe"] intValue]/[[_models.cUser objectForKey:@"commentNum"]intValue]==3){
            _fuwutaidu.image=[UIImage imageNamed:@"pingjia_xingxing3"];
        }else
        if([[_models.cUser objectForKey:@"rateServe"]intValue]/[[_models.cUser objectForKey:@"commentNum"]intValue]==4){
            _fuwutaidu.image=[UIImage imageNamed:@"pingjia_xingxing4"];
        }else
        if([[_models.cUser objectForKey:@"rateServe"] intValue]/[[_models.cUser objectForKey:@"commentNum"]intValue]==5){
            _fuwutaidu.image=[UIImage imageNamed:@"pingjia_xingxing5"];
        }else{
            _fuwutaidu.image=[UIImage imageNamed:@"pingjia_xingxing5"];
        }
        

        
        
    }
   // [[AppUtils sharedAppUtilsInstance] tableViewSeparatorInsetZero:self];
}

//- (void)tableViewSeparatorInsetZero:(UITableView *)tableView
//{
//    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//        [tableView setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
//        [tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section==2){
        return 2;
    }else{
    return 1;
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失

    if(indexPath.section == 2 && indexPath.row == 0){
        if (_tagg==1) {
        ZaicarViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"zaizhuan"];
//        detail.yiyang= @"DOTA";
//        detail.useridd=[[BmobUser getCurrentUser]objectId];
        [self.navigationController pushViewController:detail animated:YES];
        }else{
            ZaicarViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"zaizhuan"];
            detail.yiyang= @"DOTA";
            detail.useridd=_models.userId;
            [self.navigationController pushViewController:detail animated:YES];
        }
        
    }
    if(indexPath.section == 2 && indexPath.row == 1){
        if (_tagg==1) {
            ZaicarViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"yizhuan"];

            [self.navigationController pushViewController:detail animated:YES];
        }else{
            ZaicarViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"yizhuan"];
            detail.yiyang= @"LOL";
            detail.useridd=_models.userId;
            [self.navigationController pushViewController:detail animated:YES];
        }


        
    }
    if (indexPath.section == 4 && indexPath.row == 0) {
  
    
     pinglunViewController *oneC = [self.storyboard instantiateViewControllerWithIdentifier:@"pinglun"];
        [self.navigationController pushViewController:oneC animated:YES];
    }
}


- (IBAction)faxiaoxi:(UIButton *)sender {
  
    if (_tagg==1) {
        return;
    }
    
    User *chatUser = _models.cUser;
        NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
        [infoDic setObject:chatUser.objectId forKey:@"uid"];
    [infoDic setObject:chatUser.username forKey:@"name"];
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
