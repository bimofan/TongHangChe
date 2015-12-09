//
//  shixindetailViewController.m
//  TXCar
//
//  Created by jack on 15/12/4.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "shixindetailViewController.h"

@interface shixindetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_titllesArray;
    
}
@property (weak, nonatomic) IBOutlet UITableView *sxdetail_tableview;

@end

@implementation shixindetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"失信明细";
    
    
    _titllesArray = @[@"被执行人",@"被执行人证号",@"生效法律文件确定的义务",@"被执行人的履行情况",@"失信被执行人行为具体情形",@"执行法院",@"省份",@"执行依据文号",@"立案时间",@"案号",@"做出执行依据单位",@"发布时间"];
    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//段数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titllesArray.count;
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
   
    
    if (indexPath.section == 0) {
        
        return 62;
    }
    
    if (indexPath.section == 2) {
        
        NSString *yiwu = _model.Yiwu;
        
        CGRect bounds = [yiwu boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        
        
        return bounds.size.height + 43;
        
    }
    return 55;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
   if(indexPath.section == 0 )
       {

    static NSString *SimpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
           
           dispatch_async(dispatch_get_main_queue(), ^{
              
               
               UILabel *nameLabel = (UILabel *)[cell viewWithTag:100];
               
               UILabel *sexylabel = (UILabel*)[cell viewWithTag:101];
               
               UILabel *ageLabel = (UILabel*)[cell viewWithTag:102];
               
               nameLabel.text = _model.Name;
               
               sexylabel.text = _model.Sexy;
               
               ageLabel.text = [NSString stringWithFormat:@"%ld",(long)_model.Age];
               
               
               
               
           });
           return cell;
           
       }
    
    else
    {
        
        UITableViewCell *simpleCell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            UILabel *titleLabel = (UILabel*)[simpleCell viewWithTag:99];
            
            titleLabel.text = [_titllesArray objectAtIndex:indexPath.section];
            
            UILabel *contentLabel = (UILabel*)[simpleCell viewWithTag:100];
            NSString *text  = nil;
            
            switch (indexPath.section) {
            
                case 1:
                {
                    text = _model.Orgno;
                }
                    break;
                case 2:
                {
                    text = _model.Yiwu;
                    
                }
                    break;
                    
                case 3:
                {
                    text = _model.Executestatus;
                }
                    break;
                case 4:
                {
                    text = _model.Actionremark;
                    
                }
                    break;
                case 5:
                {
                    text = _model.Executeunite;
                    
                }
                    break;
                case 6:
                {
                    text = _model.Province;
                }
                    break;
                case 7:
                {
                    text = _model.Executeno;
                }
                    break;
                case 8:
                {
                    NSString *dateStr = _model.Liandate;
                    
                    if (dateStr.length > 10) {
                        
                        dateStr = [dateStr substringToIndex:10];
                        
                    }
                    
                    text = dateStr;
                    
                }
                    break;
                case 9:
                {
                    text = _model.Anno;
                    
                }
                    break;
                case 10:
                {
                    text = _model.Executegov;
                }
                    break;
                case 11:
                {
                    NSString *dateStr = _model.Publicdate;
                    
                    if (dateStr.length > 10) {
                        
                        dateStr = [dateStr substringToIndex:10];
                        
                    }
                    text = dateStr;
                    
                }
                    break;
                    
                
                    
                default:
                    break;
            }
            
            
            contentLabel.text = text;
            
        });
        
        return simpleCell;
        
        
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
