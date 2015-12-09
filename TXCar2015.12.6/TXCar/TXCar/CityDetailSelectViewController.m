//
//  CityDetailSelectViewController.m
//  TXCar
//
//  Created by jack on 15/10/20.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "CityDetailSelectViewController.h"
#import "ZhaoCheViewController.h"
#import "CarInputViewController.h"
#import "sousuocheViewController.h"
@interface CityDetailSelectViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview_citydetai;

@end

@implementation CityDetailSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_city_state;
     NSLog(@"%@",_city_detail);
   
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _city_detail.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cell_id = @"city_detail_cell";
    
    UITableViewCell *cell = [_tableview_citydetai dequeueReusableCellWithIdentifier:cell_id];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    UILabel*image1 = (UILabel*)[cell viewWithTag:1];
    image1.text=_city_detail[indexPath.row];
    return cell;

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"城市";

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    if ([_city_select_type isEqualToString:@"找车-城市选择"]) {
        NSInteger view_count=self.navigationController.viewControllers.count;
          NSLog(@"!~~~~~%ld",(long)view_count);
        ZhaoCheViewController * view=self.navigationController.viewControllers[view_count-3];
        if(![_city_detail[indexPath.row] isEqual:@"不限"]){
            view.selecte_city=[NSString stringWithFormat:@"%@ %@",_city_state,_city_detail[indexPath.row]];
            view.car_city_search=[NSString stringWithFormat:@"%@ %@",_city_state,_city_detail[indexPath.row]];
        [view setupRefresh];
      }else{
          view.selecte_city=[NSString stringWithFormat:@"%@",_city_state];
          if([_city_state isEqual:@"全国"]){
              view.car_city_search=@"";
          }else{
              view.car_city_search=_city_state;
          }
          [view setupRefresh];
      }
        
        [self.navigationController popToViewController:view animated:YES];
    }
    if ([_city_select_type isEqual:@"转车-车辆原籍"]) {
        NSInteger view_count=self.navigationController.viewControllers.count;
        CarInputViewController * view=self.navigationController.viewControllers[view_count-3];
        if(![_city_detail[indexPath.row] isEqual:@"不限"]){
            view.dihzi=[NSString stringWithFormat:@"%@ %@",_city_state,_city_detail[indexPath.row]];
        }else{
            view.dihzi=_city_state;
            
        }
        [view.tableview_input reloadData];
        [self.navigationController popToViewController:view animated:YES];
    }
    if ([_city_select_type isEqual:@"转车-所在地"])
    {
        NSInteger view_count=self.navigationController.viewControllers.count;
        CarInputViewController * view=self.navigationController.viewControllers[view_count-3];
        if(![_city_detail[indexPath.row] isEqual:@"不限"]){
            view.suozaidi=[NSString stringWithFormat:@"%@ %@",_city_state,_city_detail[indexPath.row]];
        }else{
            view.suozaidi=_city_state;
            
        }
        [view.tableview_input reloadData];
        [self.navigationController popToViewController:view animated:YES];
    }
    
    
    
    if ([_city_select_type isEqualToString:@"找车-城市选择1"]) {
        NSInteger view_count=self.navigationController.viewControllers.count;
      
        sousuocheViewController * view=self.navigationController.viewControllers[view_count-3];
       
        if(![_city_detail[indexPath.row] isEqual:@"不限"]){
            view.selecte_city=[NSString stringWithFormat:@"%@ %@",_city_state,_city_detail[indexPath.row]];
            view.car_city_search=[NSString stringWithFormat:@"%@ %@",_city_state,_city_detail[indexPath.row]];
            [view setupRefresh];
        }else{
            view.selecte_city=[NSString stringWithFormat:@"%@",_city_state];
            if([_city_state isEqual:@"全国"]){
                view.car_city_search=@"";
            }else{
                view.car_city_search=_city_state;
            }
            [view setupRefresh];
        }
        
        [self.navigationController popToViewController:view animated:YES];
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
