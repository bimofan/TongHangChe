//
//  WeiGuiHistoryTVC.m
//  TXCar
//
//  Created by ZhuHaikun on 15/12/10.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "WeiGuiHistoryTVC.h"
#import "Constants.h"
#import "WeiGuiListViewController.h"

@interface WeiGuiHistoryTVC ()<UIAlertViewDelegate>
{
    NSMutableArray *dataSource;
    
}
@end

@implementation WeiGuiHistoryTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"查询历史";
  
    dataSource = [[NSMutableArray alloc]init];
    
    
    [self getData];
    
    
    
}

-(void)getData
{
    NSArray *temArray = [[NSUserDefaults standardUserDefaults] objectForKey:kWeiGuiLiShi];
    
    if (temArray.count > 0) {
        
        [dataSource addObjectsFromArray:temArray];
        
        
    }
    
    [self.tableView reloadData];
    
    
}

#pragma mark - Table view data source

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
    
    NSString *lsprefix =nil;
    NSString *lsnum = nil;
    NSInteger score = 0;
    NSInteger price = 0;
    NSInteger num = 0;
    
    
    NSDictionary *oneResult = [dataSource objectAtIndex:indexPath.section];
    
       NSDictionary *param = [oneResult objectForKey:@"param"];
    lsprefix = [param objectForKey:@"lsprefix"];
    lsnum = [param objectForKey:@"lsnum"];
    
    cell.lsNumLabel.text = [NSString stringWithFormat:@"%@%@",lsprefix,lsnum];
    
    
    NSArray *list = [oneResult objectForKey:@"list"];
    
    for (int i = 0 ; i < list.count; i ++) {
        
        NSDictionary *dict = [list objectAtIndex:i];
        
        NSInteger temscore = [[dict objectForKey:@"score"]integerValue];
        
        score += temscore;
        
        NSInteger temprice = [[dict objectForKey:@"price"]integerValue];
        
        price += temprice;
        
        
    }
    
    num = list.count;
    
    
    
    cell.scoreLabel.text = [NSString stringWithFormat:@"%ld",(long)score];
    
    cell.priceLabel.text = [NSString stringWithFormat:@"%ld",(long)price];
    
    cell.numLabel.text = [NSString stringWithFormat:@"%ld",(long)num];
    
    
    cell.contentView.tag = indexPath.section;
    
    [cell.editButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     NSDictionary *oneResult = [dataSource objectAtIndex:indexPath.section];
    
    NSDictionary *param = [oneResult objectForKey:@"param"];
    
    
    WeiGuiListViewController *_weiguilistTVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WeiGuiListViewController"];
    
    _weiguilistTVC.param = param;
    
    _weiguilistTVC.titleStr = [NSString stringWithFormat:@"%@%@",[param objectForKey:@"lsprefix"],[param objectForKey:@"lsnum"]];
    
    
    [self.navigationController pushViewController:_weiguilistTVC animated:YES];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(void)editAction:(UIButton*)sender;
{
     NSInteger tag = [[sender superview] superview].tag;
    
    
    UIAlertView *_alert = [[UIAlertView alloc]initWithTitle:nil message:@"是否删除该条记录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    
    _alert.tag = tag;
    
    [_alert show];
    
    
    
    
    

}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        
        [dataSource removeObjectAtIndex:alertView.tag];
        
        [self.tableView reloadData];
        
        [[NSUserDefaults standardUserDefaults] setObject:dataSource forKey:kWeiGuiLiShi];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
}



@end
