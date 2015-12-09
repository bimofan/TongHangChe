//
//  MyzhanghuViewController.m
//  TXCar
//
//  Created by jack on 15/10/10.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "MyzhanghuViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobUser.h>
#import "QvXianViewController.h"
#import "Header.h"
#import "AppDelegate.h"
#import "GUAAlertView.h"
@interface MyzhanghuViewController ()<BackValueDelegate>
@property (weak, nonatomic) IBOutlet UILabel *zijin;
@property(nonatomic,copy)NSString * bibi;
@property(nonatomic,copy)NSString * str;
@end

@implementation MyzhanghuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"充值";
  //  [self.storyboard instantiateViewControllerWithIdentifier:@"my_massage"];
   
    _zijin.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
   // NSString * userid=[[BmobUser getCurrentUser]objectId];
   
//    UIBarButtonItem *submit_btn = [[UIBarButtonItem alloc]initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(mingxi)];
//    self.navigationItem.rightBarButtonItem =submit_btn;
    
//    BmobQuery *query = [BmobUser query];
//    [query whereKey:@"objectId" equalTo:userid];
//    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//        for (BmobUser *user in array) {
//            
//           _str = [[user objectForKey:@"money"] stringValue];
//            
//            _zijin.text=[NSString stringWithFormat:@"¥ %@",_str];
//          
//        }
// 
//    }];
  }

-(void)viewWillAppear:(BOOL)animated{
    AppDelegate * app=[[UIApplication sharedApplication]delegate];
    NSString * userid=[[BmobUser getCurrentUser]objectId];
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"objectId" equalTo:userid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobUser *user in array) {
            
            _str = [[user objectForKey:@"money"] stringValue];
            
            _zijin.text=[NSString stringWithFormat:@"¥ %@",_str];
            
        }
        
    }];

}



-(void)changeText:(NSString *)string{
     NSLog(@"%d",[string intValue]);
    _zijin.text=[NSString stringWithFormat:@"¥ %d",[_str intValue]-[string intValue]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)qvxian:(UIButton *)sender {
    QvXianViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"qvxian"];
    detail.delegate=self;
     [self performSegueWithIdentifier:@"qvxian22" sender:self];
}
- (IBAction)huiqv:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)chongzhi:(UIButton *)sender {
    [self performSegueWithIdentifier:@"chongzhi22" sender:self];

}

- (IBAction)mingxi:(UIButton *)sender {
    [self performSegueWithIdentifier:@"zhanghumingxi" sender:self];
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

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==0){
        if(alertView.tag==111){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%d",KEFU_PHONE]]];
        }
    }
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
