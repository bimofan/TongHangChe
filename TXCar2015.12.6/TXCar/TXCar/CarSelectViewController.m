//
//  CarSelectViewController.m
//  TXCar
//
//  Created by jack on 15/9/20.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import "CarSelectViewController.h"
#import "FMDatabase.h"
#import "UIImageView+WebCache.h"
#import "CarDetailSelectViewController.h"
@interface CarSelectViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview_carselect;


@property (nonatomic,copy)NSMutableArray *car_first_letter;
@property (nonatomic,copy)NSMutableArray *car_brand;
@property (nonatomic,copy)NSMutableArray *car_image;

@property (nonatomic,copy)NSMutableDictionary * huhu;


@end

@implementation CarSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车型选择";
    _car_first_letter=[[NSMutableArray alloc]init];
      _car_brand=[[NSMutableArray alloc]init];
      _car_image=[[NSMutableArray alloc]init];
    _huhu=[[NSMutableDictionary alloc]init];
    
    _tableview_carselect.sectionIndexColor = [UIColor grayColor];
    
    _tableview_carselect.sectionIndexBackgroundColor = [UIColor clearColor];
    
    _tableview_carselect.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
    
    [self load_car_db];

}


-(void)load_car_db{
    NSString * db_path=[[NSBundle mainBundle] pathForResource:@"car" ofType:@"db"];
    FMDatabase *db = [FMDatabase databaseWithPath:db_path];
    if (![db open]) {
        NSLog(@"不能打开数据库");
        return;
    }
    
     FMResultSet *rs = [db executeQuery:@"select distinct first_letter from tb_car_image",nil];
            while ([rs next]) {
                NSString * a =  [rs stringForColumn:@"first_letter"];
                [_car_first_letter addObject:a];
                
    }
    for (NSString *letter in _car_first_letter) {
        NSMutableArray * tmp_brand=[[NSMutableArray alloc]init];
        NSMutableArray * tmp_img=[[NSMutableArray alloc]init];
          NSString *ssss = [NSString stringWithFormat:@"select brand,img_name from tb_car_image where first_letter = '%@'",letter];
        FMResultSet *rs = [db executeQuery:ssss,nil];
        while ([rs next]) {
            
            NSString * a =  [rs stringForColumn:@"brand"];
             NSString * b =  [rs stringForColumn:@"img_name"];
        
            
            [tmp_brand addObject:a];
            [tmp_img addObject:b];

        }
 
        NSString  * s=[NSString stringWithFormat:@"%lu",(unsigned long)_car_brand.count];
        [_car_brand addObject:tmp_brand];
        [_car_image addObject:tmp_img];
        
        
     
        [_huhu setObject:tmp_brand forKey:s];
        
      

       
    }
    [db close];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray * s=[_huhu objectForKey:[NSString stringWithFormat:@"%ld",(long)section]];
    
    return s.count;
    
    
  
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
 
    static NSString * cell_id = @"car_select_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
 
        
     UIImageView *image1 = (UIImageView*)[cell viewWithTag:1];
    NSString * url111=[NSString stringWithFormat:@"http://95diya.com%@",_car_image[indexPath.section][indexPath.row]];
    NSURL *URL = [NSURL URLWithString:url111];
     [image1 sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"loading-image"]];

    
    UILabel * lable=(UILabel*)[cell viewWithTag:2];
    lable.text=_car_brand[indexPath.section][indexPath.row];
    
 
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _car_first_letter.count;
    
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  
    return _car_first_letter[section];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        return 30;
    }
    else
    {
        return 18;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return _car_first_letter;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{{
    CarDetailSelectViewController * view=[self.storyboard instantiateViewControllerWithIdentifier:@"car_detail_select_view"];
    view.select_car_type=_car_brand[indexPath.section][indexPath.row];
    view.type_info=self.type_info;
    [self.navigationController pushViewController:view animated:YES];
}
}
@end
