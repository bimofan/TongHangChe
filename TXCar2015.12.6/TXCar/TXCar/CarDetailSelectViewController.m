//
//  CarDetailSelectViewController.m
//  TXCar
//
//  Created by jack on 15/10/20.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "CarDetailSelectViewController.h"
#import "FMDatabase.h"
#import "CarInputViewController.h"
#import "ZhaoCheViewController.h"
@interface CarDetailSelectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview_car_type1;
@property (weak, nonatomic) IBOutlet UITableView *tableview_car_type2;
@property(nonatomic,copy)NSString * select_car_type_1;
@property(nonatomic,copy)NSString * select_car_type_2;
@property(nonatomic,copy)NSMutableArray * car_type1;
@property(nonatomic,copy)NSMutableArray * car_type2;
@end

@implementation CarDetailSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_type_info);
    _car_type1=[[NSMutableArray alloc]init];
    _car_type2=[[NSMutableArray alloc]init];
    NSString * nni=@"不限";
    [_car_type1 addObject:nni];
    [_car_type2 addObject:nni];
    self.title=_select_car_type;
    [self search_type_by_brand];
    
    // Do any additional setup after loading the view.
}

-(void)search_type_by_brand{
    NSString * db_path=[[NSBundle mainBundle] pathForResource:@"car" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
    if (![db open]) {
        NSLog(@"不能打开数据库");
        return;
    }
    
    NSString *ssss = [NSString stringWithFormat:@"select distinct department from tb_car where brand = '%@'",_select_car_type];
    FMResultSet *rs = [db executeQuery:ssss,nil];
    while ([rs next]) {
        NSString * a =  [rs stringForColumn:@"department"];
        [_car_type1 addObject:a];
        
    }
}


-(void)search_subtype:(NSString *)key{
    [_car_type2 removeAllObjects];
    if ([key isEqual:@"不限"]) {
        [_car_type2 addObject:@"不限"];
        [_tableview_car_type2 reloadData];
        return;
    }
    NSString * db_path=[[NSBundle mainBundle] pathForResource:@"car" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
    if (![db open]) {
        NSLog(@"不能打开数据库");
        return;
    }
    
    [_car_type2 addObject:@"不限"];
    NSString *ssss = [NSString stringWithFormat:@"select type from tb_car where department =  '%@'",key];
    FMResultSet *rs = [db executeQuery:ssss,nil];
    while ([rs next]) {
        NSString * a =  [rs stringForColumn:@"type"];
        [_car_type2 addObject:a];
        
    }
    [_tableview_car_type2 reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==1) {
        return _car_type1.count;
    }else{
        return _car_type2.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==1) {
        static NSString * cell_id = @"car_type1_cell";
        
        UITableViewCell *cell = [_tableview_car_type1 dequeueReusableCellWithIdentifier:cell_id];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        }
        
        UILabel * lable=(UILabel*)[cell viewWithTag:1];
        lable.text=_car_type1[indexPath.row];
        return cell;
    }
    else
    {
        static NSString * cell_id = @"car_type2_cell";
        
        UITableViewCell *cell = [_tableview_car_type2 dequeueReusableCellWithIdentifier:cell_id];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        }
        
        UILabel * lable=(UILabel*)[cell viewWithTag:1];
        lable.text=_car_type2[indexPath.row];
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0.2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([_type_info isEqual:@"转车—车型选择"])
    {
        if (tableView.tag==1)
        {
            
            _select_car_type_1=_car_type1[indexPath.row];
            [self search_subtype:_car_type1[indexPath.row]];
        }
        if (tableView.tag==2)
        {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            _select_car_type_2=_car_type2[indexPath.row];
            
            if ([_select_car_type_2 isEqual:@"不限"])
            {
                if ([_select_car_type_1 isEqual:@"不限"])
                {
                    NSInteger view_count=self.navigationController.viewControllers.count;
                    CarInputViewController * view=self.navigationController.viewControllers[view_count-3];
                    NSString * bbb=[self.select_car_type stringByAppendingString:[NSString stringWithFormat:@" %@",self.select_car_type_1]];
                    view.cainfo=bbb;
                        NSLog(@"%@111",bbb);
                    [view.tableview_input reloadData];
                    [self.navigationController popToViewController:view animated:YES];
                    
                }
                else
                {
                    NSInteger view_count=self.navigationController.viewControllers.count;
                    CarInputViewController * view=self.navigationController.viewControllers[view_count-3];
                    NSString * bbb=[self.select_car_type stringByAppendingString:[NSString stringWithFormat:@" %@",self.select_car_type_1]];
                    //  NSString * nnn=[bbb stringByAppendingString:[NSString stringWithFormat:@" %@",self.select_car_type_2]];
                    view.cainfo=bbb;
                        NSLog(@"%@222",bbb);
                    [view.tableview_input reloadData];
                    [self.navigationController popToViewController:view animated:YES];
                    
                }
            }
            else
            {
                NSInteger view_count=self.navigationController.viewControllers.count;
                CarInputViewController * view=self.navigationController.viewControllers[view_count-3];
                NSString * bbb=[self.select_car_type stringByAppendingString:[NSString stringWithFormat:@" %@",self.select_car_type_1]];
                NSString * nnn=[bbb stringByAppendingString:[NSString stringWithFormat:@" %@",self.select_car_type_2]];
                view.cainfo=nnn;
                NSLog(@"%@333",nnn);
                [view.tableview_input reloadData];
                [self.navigationController popToViewController:view animated:YES];
            }
        }
    }
    
    if ([_type_info isEqual:@"找车-车型选择"])
    {
        if (tableView.tag==1)
        {
            NSLog(@"22");
            
            _select_car_type_1=_car_type1[indexPath.row];
            [self search_subtype:_car_type1[indexPath.row]];
        }
        if (tableView.tag==2)
        {
            NSLog(@"11");
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            _select_car_type_2=_car_type2[indexPath.row];
            if ([_select_car_type_2 isEqual:@"不限"])
            {
                if ([_select_car_type_1 isEqual:@"不限"])
                {
                    NSLog(@"33");
                    NSInteger view_count=self.navigationController.viewControllers.count;
                    ZhaoCheViewController * view=self.navigationController.viewControllers[view_count-3];
                    
                    view.car_type_search=self.select_car_type;
                    //view.tableview_input.reloadData()这里没写完
                    [view setupRefresh];
                    [self.navigationController popToViewController:view animated:YES];
                    
                    
                }
                else
                {
                    NSLog(@"44");
                    NSInteger view_count=self.navigationController.viewControllers.count;
                    ZhaoCheViewController * view=self.navigationController.viewControllers[view_count-3];
                    NSString * bbb=[self.select_car_type stringByAppendingString:[NSString stringWithFormat:@" %@",self.select_car_type_1]];
                    //   NSString * nnn=[bbb stringByAppendingString:[NSString stringWithFormat:@" %@",self.select_car_type2]];
                    view.car_type_search=bbb;
                    [view setupRefresh];
                    //view.tableview_input.reloadData()这里没写完
                    [self.navigationController popToViewController:view animated:YES];
                    
                }
            }
            else
            {
                
                NSInteger view_count=self.navigationController.viewControllers.count;
                ZhaoCheViewController * view=self.navigationController.viewControllers[view_count-3];
                NSString * bbb=[self.select_car_type stringByAppendingString:[NSString stringWithFormat:@" %@",self.select_car_type_1]];
                NSLog(@"!!!!!!!!%@",bbb);
                NSString * nnn=[bbb stringByAppendingString:[NSString stringWithFormat:@" %@",self.select_car_type_2]];
                 NSLog(@"!!!!!!!!%@",nnn);
                view.car_type_search=nnn;
                [view setupRefresh];
                //view.tableview_input.reloadData()这里没写完
                [self.navigationController popToViewController:view animated:YES];
                
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
