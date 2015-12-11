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
#import "PrefixView.h"

@interface WeiGuiViewController ()<SelectedPrefix>
{
    PrefixView *_prefixView;
    
}
@property (nonatomic,strong) NSString *Isprefix;
@property (nonatomic,strong ) NSString *carorg;
@property (nonatomic,strong)  NSDictionary *dict;

@end

@implementation WeiGuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.title = @"车辆详情";
    
    _lsprefixButton.clipsToBounds = YES;
    _lsprefixButton.layer.cornerRadius = 2.0;
    
    _lsprefixButton.layer.borderColor = [UIColor colorWithRed:38/255.0 green:151/255.0 blue:1/255.0 alpha:1].CGColor;
    
    _lsprefixButton.layer.borderWidth = 1;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithTitle:@"历史" style:UIBarButtonItemStylePlain target:self action:@selector(showHistory)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _Isprefix = @"京";
    
    
    _prefixView = [[PrefixView alloc]initWithFrame:self.view.bounds];
    
    _prefixView.delegate = self;
    
    
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
           
       
           
           if (isCity) {
               
              _citytextField.text = [dict objectForKey:@"city"];
           }
           else
           {
               _citytextField.text = [dict objectForKey:@"province"];
               
               
           }
           
           
              NSInteger engineno = [[_dict objectForKey:@"engineno"]integerValue];
           
           if (engineno == 0) {
               
               _enginenoTextField.hidden = YES;
               _engineLabel.hidden = YES;
               _enginelineView.hidden = YES;
               
       
               
               _viewHeightConstraint.constant = 120;
               
               
               _enginenoTextField.placeholder = @"请填写发动机号";
           }
           else
           {
               _enginenoTextField.hidden = NO;
               _engineLabel.hidden = NO;
               _enginelineView.hidden = NO;
                _enginenoTextField.placeholder = @"请填写发动机号";
           }
           
              NSInteger frameno = [[_dict objectForKey:@"frameno"]integerValue];
           
           
           if (frameno == 0) {
               
               _chejialabel.hidden = YES;
               _chejialineView.hidden = YES;
               _chejiaVline.hidden = YES;
               _framenoTextField.hidden = YES;
               
               _framenoTextField.placeholder = @"请填写车架号";
               
               
               if (engineno == 0) {
                   
                   _viewHeightConstraint.constant = 80;
               }
               else
               {
                   _viewHeightConstraint.constant = 120;
               }
               
               
               
               
           }else
           {
               _chejialabel.hidden = NO;
               _chejialineView.hidden = NO;
               _framenoTextField.hidden = NO;
               _chejiaVline.hidden = NO;
               _framenoTextField.placeholder = @"请填写车架号";
           }
           
       }
       
       
   }];
    
    [self.navigationController pushViewController:_pickCityVC animated:YES];
    
}

- (IBAction)searchButton:(id)sender {
    
    
    if (_carNumLabel.text.length == 0 ) {
        
        
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
- (IBAction)showPreFix:(id)sender {
    
    
    [self.view addSubview:_prefixView];
    
    
    
    
}

-(void)didSelectedPrefix:(NSString *)prefix
{
    _Isprefix = prefix;
    
    [_lsprefixButton setTitle:prefix forState:UIControlStateNormal];
    
    
    
}
@end
