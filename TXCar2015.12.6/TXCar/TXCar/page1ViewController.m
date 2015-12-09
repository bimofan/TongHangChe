//
//  page1ViewController.m
//  TXCar
//
//  Created by jack on 15/11/6.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "page1ViewController.h"

@interface page1ViewController ()

@end

@implementation page1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的转车";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
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
