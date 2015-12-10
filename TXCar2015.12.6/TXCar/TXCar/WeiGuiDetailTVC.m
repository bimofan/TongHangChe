//
//  WeiGuiDetailTVC.m
//  TXCar
//
//  Created by ZhuHaikun on 15/12/10.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "WeiGuiDetailTVC.h"

@interface WeiGuiDetailTVC ()
{
    NSArray *titles;
    
}
@end

@implementation WeiGuiDetailTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"违规详情";
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    titles = @[@"违章地点",@"违章内容",@"违章时间",@"违章状态",@"扣分情况",@"罚款金额",@"违章人数"];
    
    ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   
    return 1;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *BlankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 1)];
    
    BlankView.backgroundColor = [UIColor clearColor];
    
    return BlankView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        
        NSString *content = [_dataDict objectForKey:@"content"];
        
        CGRect rect = [content boundingRectWithSize:CGSizeMake(tableView.frame.size.width - 113, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} context:nil];
        
        if (rect.size.height < 45) {
            
            return 45;
            
        }
        return rect.size.height;
    }
    return 45;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        UILabel *titlelable = (UILabel*)[cell viewWithTag:100];
        
        titlelable.text = [titles objectAtIndex:indexPath.section];
        
        
        UILabel *contentLabel = (UILabel*)[cell viewWithTag:101];
        
        NSString *_content = nil;
        
        switch (indexPath.section) {
            case 0:
            {
                _content = [_dataDict objectForKey:@"address"];
                
            }
                break;
            case 1:
            {
                _content = [_dataDict objectForKey:@"content"];
                
            }
                break;
            case 2:
            {
                _content = [_dataDict objectForKey:@"time"];
                
            }
                break;
            case 3:
            {
                _content = @"未处理";
            }
                break;
            case 4:
            {
                _content = [_dataDict objectForKey:@"score"];
                
            }
                break;
            case 5:
            {
                _content = [_dataDict objectForKey:@"price"];
            }
                break;
            case 6:
            {
                _content = [_dataDict objectForKey:@"legalnum"];
                
            }
                break;
                
                
            default:
                break;
        }
        
        
        
        contentLabel.text = _content;
        
        if (indexPath.section == 3) {
            
            contentLabel.textColor = [UIColor redColor];
            
        }
        else
        {
            contentLabel.textColor = [UIColor colorWithRed:38/255.0 green:151/255.0 blue:1/255.0 alpha:1];
        }
        
        
    });
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
