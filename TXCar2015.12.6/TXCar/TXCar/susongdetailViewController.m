//
//  susongdetailViewController.m
//  TXCar
//
//  Created by jack on 15/12/4.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "susongdetailViewController.h"

@interface susongdetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *susong_tableview;

@end

@implementation susongdetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"诉讼详情";
    self.automaticallyAdjustsScrollViewInsets=NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//标题头
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if(section == 0)
    {
        return 20;
    }else{
        return 10;
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        
        static NSString *SimpleTableIdentifier = @"cell1";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
        //    UILabel * lable12=(UILabel*)[cell viewWithTag:1];
        //
        //
        //    UILabel * lable1=(UILabel*)[cell viewWithTag:2];
        //
        //
        //
        //    UILabel * lable3=(UILabel*)[cell viewWithTag:3];
        return cell;
    }else if(indexPath.section == 1 && indexPath.row == 0){
        static NSString *SimpleTableIdentifier = @"cell2";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
        
        return cell;
        
    }else if(indexPath.section == 2 && indexPath.row == 0){
        static NSString *SimpleTableIdentifier = @"cell3";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
        
        return cell;
        
    }else if(indexPath.section == 3 && indexPath.row == 0){
        static NSString *SimpleTableIdentifier = @"cell4";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
        
        return cell;
        
    }else if(indexPath.section == 4 && indexPath.row == 0){
        static NSString *SimpleTableIdentifier = @"cell5";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
        
        return cell;
        
    }else {
        static NSString *SimpleTableIdentifier = @"cell6";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
        
        return cell;
        
    }}

@end
