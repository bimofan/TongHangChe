//
//  WeiGuiViewController.m
//  TXCar
//
//  Created by ZhuHaikun on 15/12/9.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "WeiGuiViewController.h"
#import "PickCityViewController.h"
#import "WeiGuiListViewController.h"

@interface WeiGuiViewController ()

@property (nonatomic,strong) NSString *Isprefix;
@property (nonatomic,strong ) NSString *carorg;
@property (nonatomic,strong)  NSDictionary *dict;

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
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"历史" style:UIBarButtonItemStylePlain target:self action:@selector(showHistory)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    
    
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return YES;
    
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
           
           _dict = dict;
           
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
           
           
              NSInteger engineno = [[_dict objectForKey:@"engineno"]integerValue];
           
           if (engineno == 0) {
               
               _enginenoTextField.placeholder = @"请填写发动机号(选填)";
           }
           else
           {
                _enginenoTextField.placeholder = @"请填写发动机号(必填)";
           }
           
              NSInteger frameno = [[_dict objectForKey:@"frameno"]integerValue];
           
           
           if (frameno == 0) {
               
               _framenoTextField.placeholder = @"请填写车架号(选填)";
           }else
           {
               _framenoTextField.placeholder = @"请填写车架号(必填)";
           }
           
       }
       
       
   }];
    
    [self.navigationController pushViewController:_pickCityVC animated:YES];
    
}

- (IBAction)searchButton:(id)sender {
    
    
    if (_carNumLabel.text.length == 0 || _IsprefixLabel.text.length == 0 ) {
        
        
        [[[UIAlertView alloc]initWithTitle:nil message:@"请填写完整的车辆信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show ];
        
        
        return;
    }
    
    
    //需要的数据长度
    NSInteger frameno = [[_dict objectForKey:@"frameno"]integerValue];
    NSString *_framenoStr = nil;
    
    if (frameno == 0) {
        
        _framenoStr = @"";
        
    }
    else if (frameno == 100)
    {
        
     
        
        if (_framenoStr.length == 0) {
            
            [[[UIAlertView alloc]initWithTitle:nil message:@"请填写完整的车辆信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show ];
            
            
            return;

            
        }
    }
    else
    {
        if (_framenoTextField.text.length < frameno) {
            
            [[[UIAlertView alloc]initWithTitle:nil message:@"请填写完整的车辆信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show ];
            
            
            return;
            
        }
        else
        {
               _framenoStr = _framenoTextField.text;
            
            _framenoStr = [_framenoStr substringFromIndex:(_framenoStr.length - frameno)];
            
            
        }
    }
    
    
    NSInteger engineno = [[_dict objectForKey:@"engineno"]integerValue];
    NSString *_enginenoStr = nil;
  
    if (engineno == 0) {
        
        _enginenoStr = @"";
    }
    else if (engineno == 100)
    {
        _enginenoStr = _enginenoTextField.text;
        
        if (_enginenoTextField.text.length == 0) {
            
            [[[UIAlertView alloc]initWithTitle:nil message:@"请填写完整的车辆信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show ];
            
            
            return;
        }
    }
    else
    {
        if (_enginenoStr.length < engineno) {
            
            [[[UIAlertView alloc]initWithTitle:nil message:@"请填写完整的车辆信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show ];
            
            
            return;
            
        }
        else
        {
            _enginenoStr = [_enginenoStr substringFromIndex:(_enginenoStr.length - engineno)];
            
            
        }
    }
    
    NSDictionary *param = @{@"carorg":_carorg,@"lsprefix":_Isprefix,@"lsnum":_carNumLabel.text,@"lstype":@"02",@"frameno":_framenoStr,@"engineno":_enginenoStr,@"appkey":kWeiGuiKey};
    
    
    WeiGuiListViewController *_weiguilistTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WeiGuiListViewController"];
    
    _weiguilistTVC.param = param;
    
    _weiguilistTVC.titleStr = [NSString stringWithFormat:@"%@%@",_Isprefix,_carNumLabel.text];
    
    
    [self.navigationController pushViewController:_weiguilistTVC animated:YES];
    
    
    
}

#pragma mark  - 显示历史查询记录
-(void)showHistory
{
    WeiGuiHistoryTVC *_history = [self.storyboard instantiateViewControllerWithIdentifier:@"WeiGuiHistoryTVC"];
    
    
    [self.navigationController pushViewController:_history animated:YES];
    
}
@end
