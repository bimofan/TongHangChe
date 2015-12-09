//
//  susongdetailViewController.m
//  TXCar
//
//  Created by jack on 15/12/4.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "susongdetailViewController.h"

@interface susongdetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_titles;
    
}
@property (weak, nonatomic) IBOutlet UITableView *susong_tableview;

@end

@implementation susongdetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"诉讼详情";
    _titles = @[@"被执行人",@"被执行人证号",@"执行标的",@"执行法院",@"立案时间",@"案号"];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titles.count;
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
    
        static NSString *SimpleTableIdentifier = @"cell1";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
        }
    
       dispatch_async(dispatch_get_main_queue(), ^{
          
           UILabel *titleLabel = (UILabel*)[cell viewWithTag:99];
           
           titleLabel.text = [_titles objectAtIndex:indexPath.section];
           
           UILabel *contentLabel = (UILabel*)[cell viewWithTag:100];
           
           NSString *_content = nil;
           
           switch (indexPath.section) {
               case 0:
               {
                   _content = _model.Name;
               }
                   break;
                case 1:
               {
                   _content = [NSString stringWithFormat:@"%ld",(long)_model.Sourceid];
               }
                   break;
                case 2:
               {
                   _content = _model.Biaodi;
                   
               }
                   break;
                case 3:
               {
                   _content = _model.ExecuteGov;
               }
                   break;
                case 4:
               {
                   NSString *dateStr = _model.Liandate;
                   
                   if (dateStr.length > 10) {
                       
                       dateStr = [dateStr substringToIndex:10];
                       
                       
                   }
                   
                   _content = dateStr;
                   
               }
                   break;
                case 5:
               {
                   _content = _model.Anno;
                   
               }
                   break;
                   
                   
                   
                   
               default:
                   break;
           }
           
           
           
           contentLabel.text = _content;
           
           
       });
        return cell;

}
@end
