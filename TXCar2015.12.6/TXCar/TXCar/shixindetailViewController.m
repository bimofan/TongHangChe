//
//  shixindetailViewController.m
//  TXCar
//
//  Created by jack on 15/12/4.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "shixindetailViewController.h"

@interface shixindetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *sxdetail_tableview;

@end

@implementation shixindetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"失信明细";
    self.automaticallyAdjustsScrollViewInsets=NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 12;
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
    return 60;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
   if(indexPath.section == 0 && indexPath.row == 0)
       {

    static NSString *SimpleTableIdentifier = @"cell";
    
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
           static NSString *SimpleTableIdentifier = @"cell10";
           
           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
           if (cell==nil) {
               cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
           }
           
           return cell;
           
       }else if(indexPath.section == 3 && indexPath.row == 0){
           static NSString *SimpleTableIdentifier = @"cell3";
           
           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
           if (cell==nil) {
               cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
           }
           
           return cell;
           
       }else if(indexPath.section == 4 && indexPath.row == 0){
           static NSString *SimpleTableIdentifier = @"cell11";
           
           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
           if (cell==nil) {
               cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
           }
           
           return cell;
           
       }else if(indexPath.section == 5 && indexPath.row == 0){
           static NSString *SimpleTableIdentifier = @"cell4";
           
           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
           if (cell==nil) {
               cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
           }
           
           return cell;
           
       }else if(indexPath.section == 6 && indexPath.row == 0){
           static NSString *SimpleTableIdentifier = @"cell5";
           
           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
           if (cell==nil) {
               cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
           }
           
           return cell;

       }else if(indexPath.section == 7 && indexPath.row == 0){
           static NSString *SimpleTableIdentifier = @"cell12";
           
           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
           if (cell==nil) {
               cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
           }
           
           return cell;
           
       }else if(indexPath.section == 8 && indexPath.row == 0){
           static NSString *SimpleTableIdentifier = @"cell6";
           
           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
           if (cell==nil) {
               cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
           }
           
           return cell;
           
       }else if(indexPath.section == 9 && indexPath.row == 0){
           static NSString *SimpleTableIdentifier = @"cell7";
           
           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
           if (cell==nil) {
               cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
           }
           
           return cell;
           
       }else if(indexPath.section == 10 && indexPath.row == 0){
           static NSString *SimpleTableIdentifier = @"cell8";
           
           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
           if (cell==nil) {
               cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
           }
           
           return cell;
           
       }else {
           static NSString *SimpleTableIdentifier = @"cell9";
           
           UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
           if (cell==nil) {
               cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
           }
           
           return cell;
           
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
