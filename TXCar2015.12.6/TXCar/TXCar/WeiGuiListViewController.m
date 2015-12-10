//
//  WeiGuiListViewController.m
//  TXCar
//
//  Created by ZhuHaikun on 15/12/10.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "WeiGuiListViewController.h"
#import "RequestMethod.h"
#import "Constants.h"
#import "WeiGuiDetailTVC.h"

@interface WeiGuiListViewController ()
{
    
    NSArray *_dataSource;
    
}
@end

@implementation WeiGuiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.titleStr;
    
    
    self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    [self getData];
    
}




-(void)getData
{
   NSString *url = @"http://api.jisuapi.com/illegal/query";
    
    [RequestMethod requestWithURL:url params:_param results:^(BOOL success, id results) {
       
        
        if (success) {
            
            NSInteger status = [[results objectForKey:@"status"]integerValue];
            
            if (status == 0) {
                
                NSDictionary *result = [results objectForKey:@"result"];
                
                
                NSArray *list = [result objectForKey:@"list"];
                
                if (list.count > 0) {
                    
                    NSMutableDictionary *mudict = [NSMutableDictionary dictionaryWithDictionary:result];
                    
                    [mudict setObject:_param forKey:@"param"];
                    
                    
                    NSArray *temArray = [[NSUserDefaults standardUserDefaults ] objectForKey:kWeiGuiKey];
                    
                    NSMutableArray *muArray = [[NSMutableArray alloc]init];
                    
                    if (temArray.count > 0) {
                        
                        [muArray addObjectsFromArray:temArray];
                        
                    }
                    
                    [muArray addObject:mudict];
                    
                    [[NSUserDefaults standardUserDefaults ] setObject:muArray forKey:kWeiGuiLiShi];
                    
                    [[NSUserDefaults standardUserDefaults ] synchronize];
                    
                    _dataSource = list;
                    
                    
                    [self.tableView reloadData];
                    
                    
                }
                
                
                _headLabel.attributedText = [self fromFirstTwo:[NSString stringWithFormat:@"共有%ld起违章,其中未处理%ld起",(long)list.count,(long)list.count] andcheck:[NSString stringWithFormat:@"%ld",(long)list.count]];
                
                
                
            }
        }
    }];
    
}



#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 5)];
    
    blankView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    return blankView;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSDictionary *oneDict = [_dataSource objectAtIndex:indexPath.section];
    
    NSString *content = [oneDict objectForKey:@"content"];
    
    
    CGRect textRect = [content boundingRectWithSize:CGSizeMake(tableView.frame.size.width - 16, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    
    return textRect.size.height + 125;
    
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    WeiguiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WeiguiCell" forIndexPath:indexPath];
    
  
    NSDictionary *oneDict = [_dataSource objectAtIndex:indexPath.section];
    
    
    cell.timeLabel.text = [oneDict objectForKey:@"time"];
    
    cell.titleLabel.text = [oneDict objectForKey:@"address"];
    
    cell.contentLabel.text = [oneDict objectForKey:@"content"];
    
    cell.renciLabel.attributedText = [self getAttributeStringWithString:[NSString stringWithFormat:@"%@人",[oneDict objectForKey:@"legalnum"]] andcheckString:[NSString stringWithFormat:@"%@",[oneDict objectForKey:@"legalnum"]]];
    
    
    cell.koufenLabel.attributedText = [self getAttributeStringWithString: [NSString stringWithFormat:@"扣%@分",[oneDict objectForKey:@"score"]] andcheckString:[NSString stringWithFormat:@"%@",[oneDict objectForKey:@"score"]]];
    
    cell.fakuanLabel.attributedText = [self getAttributeStringWithString:[NSString stringWithFormat:@"罚款%@元",[oneDict objectForKey:@"price"]] andcheckString:[NSString stringWithFormat:@"%@",[oneDict objectForKey:@"price"]]];
    
    
    
    
    
    
    
    
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
     NSDictionary *oneDict = [_dataSource objectAtIndex:indexPath.section];
    
    WeiGuiDetailTVC *_detailTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WeiGuiDetailTVC"];
    
    _detailTVC.dataDict = oneDict;
    
    
    [self.navigationController pushViewController:_detailTVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(NSMutableAttributedString*)getAttributeStringWithString:(NSString*)str andcheckString:(NSString*)check
{
    
    NSMutableAttributedString *_aStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    
    
    [_aStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(str.length - check.length - 1, check.length)];
    
    
    
    return _aStr;
    
}


-(NSMutableAttributedString*)fromFirstTwo:(NSString*)str andcheck:(NSString*)check
{
    NSMutableAttributedString *_aStr = [[NSMutableAttributedString alloc]initWithString:str];
    

    [_aStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2, check.length)];
    
      [_aStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(str.length - 1 - check.length, check.length)];
    
    return _aStr;
}


@end
