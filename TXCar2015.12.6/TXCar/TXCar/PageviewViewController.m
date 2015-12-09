//
//  PageviewViewController.m
//  TXCar
//
//  Created by jack on 15/10/14.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "PageviewViewController.h"
#import "YuyueViewController.h"
#import "YuyuemaiViewController.h"
#import "MingxiViewController.h"
#import "MenuViewController.h"

@interface PageviewViewController ()

@end

@implementation PageviewViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"订单中心";
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10,15)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"navbar_return_normal.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismiss3) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

    NSLog(@"上我这来了");
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}
-(void)dismiss3{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
