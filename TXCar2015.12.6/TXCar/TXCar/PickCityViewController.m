//
//  PickCityViewController.m
//  TXCar
//
//  Created by ZhuHaikun on 15/12/10.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "PickCityViewController.h"
#import "MyProgressHUD.h"
#import "Constants.h"
#import "AppDelegate.h"

@interface PickCityViewController ()
@property (nonatomic) NSArray *leftDataSource;
@property (nonatomic) NSArray *rightDataSource;

@property (nonatomic) UITableView *leftTableView;
@property (nonatomic) UITableView *rightTableView;

@end

@implementation PickCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = @"城市选择";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screenSize.width/2, screenSize.height - 64) style:UITableViewStylePlain];
    
    _leftTableView.dataSource = self;
    _leftTableView.delegate = self;
    _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _leftTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.view addSubview:_leftTableView];
    
    
    _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(screenSize.width /2, 64, screenSize.width/2, screenSize.height - 64) style:UITableViewStylePlain];
    
    _rightTableView.dataSource = self;
    _rightTableView.delegate = self;
    _rightTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
     [self.view addSubview:_rightTableView];
    
    
    
      AppDelegate *delegate = [UIApplication sharedApplication].delegate;
  
    
    _leftDataSource = delegate.cityArray;
    
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
  

    
   
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 1;
    
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blanckView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    
    blanckView.backgroundColor = [UIColor clearColor];
    
    
    return blanckView;
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    if (tableView == _leftTableView) {
        
        return  _leftDataSource.count;
        
    }
    
    else
    {
        
        return _rightDataSource.count;
        
        
    }
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _leftTableView) {
       
        UITableViewCell *leftCell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
        
        if (!leftCell) {
            
            leftCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"leftCell"];
            
            
        }
        
        NSDictionary *province = [_leftDataSource objectAtIndex:indexPath.section];
        
        leftCell.textLabel.text = [province objectForKey:@"province"];
        
        
        NSArray *citys = [province objectForKey:@"list"];
        
        if (citys.count > 0) {
            
            leftCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            leftCell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        return leftCell;
        
        
    }
    else
    {
        
        UITableViewCell *rightCell = [tableView dequeueReusableCellWithIdentifier:@"rightCell"];
        
        if (!rightCell) {
            
            rightCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rightCell"];
            
            
        }
        
        NSDictionary *city = [_rightDataSource objectAtIndex:indexPath.section];
        
        rightCell.textLabel.text = [city objectForKey:@"city"];
        
        
        return rightCell;
        
        
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _leftTableView) {
        
        NSDictionary *provinceDic = [_leftDataSource objectAtIndex:indexPath.section];
        
        
        NSArray *citys = [provinceDic objectForKey:@"list"];
        
        if (citys.count > 0) {
            
            _rightDataSource = citys;
            
        
            [_rightTableView reloadData];
            
        }
        else
        {
            if (_block) {
                
                _block(provinceDic,NO);
               
                
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        }
        
        
        
    }
    else
    {
        NSDictionary *cityDict = [_rightDataSource objectAtIndex:indexPath.section];
        
        if (_block) {
            
            _block(cityDict,YES);
            
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    

}

-(void)pickCityBlock:(pickBlock)block
{
    _block = block;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
