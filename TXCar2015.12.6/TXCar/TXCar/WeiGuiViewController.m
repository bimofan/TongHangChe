//
//  WeiGuiViewController.m
//  TXCar
//
//  Created by ZhuHaikun on 15/12/9.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "WeiGuiViewController.h"
#import "PickCityViewController.h"

@interface WeiGuiViewController ()

@property (nonatomic,strong) NSString *Isprefix;
@property (nonatomic,strong ) NSString *carorg;

@end

@implementation WeiGuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"车辆详情";
    _IsprefixLabel.clipsToBounds = YES;
    _IsprefixLabel.layer.cornerRadius = 2.0;
    
    _IsprefixLabel.layer.borderColor = [UIColor colorWithRed:38/255.0 green:151/255.0 blue:1/255.0 alpha:1].CGColor;
    _IsprefixLabel.textColor =[UIColor colorWithRed:38/255.0 green:151/255.0 blue:1/255.0 alpha:1];
    _IsprefixLabel.layer.borderWidth = 1;
    
    
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    
}





- (IBAction)pickcityAction:(id)sender {
    
    
    PickCityViewController *_pickCityVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PickCityViewController"];
    
    
   [_pickCityVC pickCityBlock:^(NSDictionary *dict,BOOL isCity) {
      
       
       if (dict) {
           
           _carorg = [dict objectForKey:@"carorg"];
           
           _Isprefix = [dict objectForKey:@"lsprefix"];
           
           
           _IsprefixLabel.text = _Isprefix;
           
           if (isCity) {
               
              _citytextField.text = [dict objectForKey:@"city"];
           }
           else
           {
               _citytextField.text = [dict objectForKey:@"province"];
               
               
           }
           
           
       }
       
       
   }];
    
    [self.navigationController pushViewController:_pickCityVC animated:YES];
    
}

- (IBAction)searchButton:(id)sender {
    
    
}
@end
