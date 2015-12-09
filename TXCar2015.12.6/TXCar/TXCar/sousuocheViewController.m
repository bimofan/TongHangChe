//
//  sousuocheViewController.m
//  TXCar
//
//  Created by jack on 15/11/9.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "sousuocheViewController.h"
#import <BmobSDK/Bmob.h>
#import "CarDetail.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "DOPDropDownMenu.h"
#import "ZhaoCheDetailViewController.h"
#import "CarSelectViewController.h"
#import "WXViewController.h"
#import "ContantHead.h"
#import "Header.h"
#import "CityViewController.h"
#import "MyzhanghuViewController.h"
@interface sousuocheViewController ()<UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDataSource, DOPDropDownMenuDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *sousuo_tableview;
@property (nonatomic,assign) int page;
@property (nonatomic, copy) NSArray *citys;
@property (nonatomic, copy) NSArray *ages;
@property (nonatomic, copy) NSArray *genders;
@property (nonatomic, assign) int row;
@property (nonatomic, assign) int row1;

@property (nonatomic,assign)  int min_price;
@property (nonatomic,assign)  int max_price;
@property (weak, nonatomic) IBOutlet UITextField *cheliang;


@property (nonatomic, copy) NSString * car_price_search;
@property (nonatomic, copy) NSString * car_sort_search;

@property (nonatomic, copy) NSString * car_info_search;
@end

@implementation sousuocheViewController
{
    NSMutableArray * datasource;
    BmobQuery   *bquery;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _min_price=0;
    _max_price=99999;
    
    _citys = @[@"全国地区",@"指定地区"];
    _ages = @[@"价格不限",@"3万及以下",@"3-5万",@"5-8万",@"8-10万",@"10-15万",@"15-20万",@"20万以上"];
    _genders =@[@"默认排序",@"价格最低",@"价格最高",@"最新发布",@"只看已售"];
    
    
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    
    datasource=[[NSMutableArray alloc]init];
    _sousuo_tableview.dataSource = self;
    _sousuo_tableview.delegate = self;
    
    [self setupRefresh];
    [_sousuo_tableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
    [_sousuo_tableview addFooterWithTarget:self action:@selector(footerRereshing)];

    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10,15)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"navbar_return_normal.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismiss1:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    _cheliang.returnKeyType = UIReturnKeySearch;
    _cheliang.delegate=self;
    
    
   // [_cheliang setBorderStyle:UITextBorderStyleNone];
    _cheliang.clearsOnBeginEditing = YES;
    _cheliang.placeholder = @"请输入您要搜索的车辆";
    _cheliang.textColor=[UIColor blackColor];
//   [_cheliang addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
}

//-(void)textFieldChanged:(UITextField*)sender{
//    _car_info_search=sender.text;
//    NSLog(@"%@",_car_info_search);
//    [self setupRefresh];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismiss1:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    _car_info_search=_cheliang.text;
    [self setupRefresh];
//    [_sousuo_tableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
//    [_sousuo_tableview addFooterWithTarget:self action:@selector(footerRereshing)];
    [textField resignFirstResponder];
    
    
    
    return YES;  
    
}
- (void)setupRefresh
{
    [_sousuo_tableview headerBeginRefreshing];
}


- (void)headerBeginRefreshing
{
    
    bquery = [BmobQuery queryWithClassName:@"CarDetail"];
    bquery.limit = 10;
    NSLog(@"%@",_car_info_search);
    if(_car_info_search !=nil){
        [bquery whereKey:@"carInfo" matchesWithRegex:_car_info_search];
    }
    
    if (_min_price != 0 || _max_price != 99999){
        
        NSArray *array =  @[@{@"carPrice":@{@"$gt":  [[NSNumber alloc]initWithInt:_min_price]}},@{@"carPrice":@{@"$lt": [[NSNumber alloc]initWithInt:_max_price]}}];
        
        [bquery addTheConstraintByAndOperationWithArray:array];
    }
    if (_car_sort_search != nil)
    {
        NSLog(@"%@",_car_sort_search);
        
        if ([_car_sort_search  isEqual: @"默认排序"])
        {
            _car_sort_search = @"";
        }
        if ([_car_sort_search  isEqual: @"价格最低"])
        {
            
            [bquery orderByAscending:@"carPrice"];
        }
        if ([_car_sort_search  isEqual: @"价格最高"])
        {
            [bquery orderByDescending:@"carPrice"];
        }
        if ([_car_sort_search  isEqual: @"最新发布"])
        {
            NSLog(@"2222222");
            [bquery orderByDescending:@"updatedAt"];
        }
        if ([_car_sort_search  isEqual: @"只看已售"])
        {
            [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:3]];
        }
    }
    
    if(![_car_city_search isEqual:@""]){
        NSString * city=[_car_city_search stringByReplacingOccurrencesOfString:@"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,_car_city_search.length)];
        
        if([_car_city_search isEqualToString:@"大区 京津冀"]){
            [bquery whereKey:@"carLocation" containedIn:[NSArray arrayWithObjects:@"北京",@"天津",@"河北", nil]];
        }else if([_car_city_search isEqualToString:@"大区 晋鲁豫"]){
            [bquery whereKey:@"carLocation" containedIn:[NSArray arrayWithObjects:@"山西",@"山东",@"河南", nil]];
        }else if([_car_city_search isEqualToString:@"大区 黑吉辽"]){
            [bquery whereKey:@"carLocation" containedIn:[NSArray arrayWithObjects:@"黑龙江",@"吉林",@"辽宁", nil]];
        }else if([_car_city_search isEqualToString:@"大区 江浙沪"]){
            [bquery whereKey:@"carLocation" containedIn:[NSArray arrayWithObjects:@"江苏",@"浙江",@"上海", nil]];
        }else if([_car_city_search isEqualToString:@"大区 广深"]){
            [bquery whereKey:@"carLocation" containedIn:[NSArray arrayWithObjects:@"广东",@"广西",@"深圳", nil]];
        }else if([_car_city_search isEqualToString:@"大区 云贵川"]){
            [bquery whereKey:@"carLocation" containedIn:[NSArray arrayWithObjects:@"云南",@"贵州",@"四川", nil]];
        }
        else{
            
            [bquery whereKey:@"carLocation" matchesWithRegex:city];
        }

        
    }
    [bquery includeKey:@"cUser"];
    [bquery orderByDescending:@"updatedAt"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error) {
            [datasource removeAllObjects];
            for (BmobObject *obj in array) {
                //打印playerName
                
                CarDetail * carmodel=[[CarDetail alloc]init];
                carmodel.carInfo=[obj objectForKey:@"carInfo"];
                carmodel.carPic=[obj objectForKey:@"carPic"];
                carmodel.contactPhone=[obj objectForKey:@"contactPhone"];
                carmodel.publishTime=[obj objectForKey:@"publishTime"];
                carmodel.userId=[obj objectForKey:@"userId"];
                carmodel.contactName=[obj objectForKey:@"contactName"];
                carmodel.carColor=[obj objectForKey:@"carColor"];
                carmodel.carLocation=[obj objectForKey:@"carLocation"];
                carmodel.carNotes=[obj objectForKey:@"carNotes"];
                carmodel.carPrice=[[obj objectForKey:@"carPrice"]floatValue];
                carmodel.carYearCheck=[obj objectForKey:@"carYearCheck"];
                carmodel.carDistance=[[obj objectForKey:@"carDistance"]floatValue];
                carmodel.flag=[[obj objectForKey:@"flag"]intValue];
                carmodel.cUser=[obj objectForKey:@"cUser"];
                carmodel.userId=[obj objectForKey:@"userId"];
                carmodel.objectId=[obj objectId];
                carmodel.createdAt=[obj updatedAt];
                [datasource addObject:carmodel];
                
            }
            
            
            [_sousuo_tableview reloadData];
            
            
            
        }
        
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_sousuo_tableview reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_sousuo_tableview headerEndRefreshing];
    });
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_cheliang resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, 0);
    }];
}
-(void)footerRereshing{
    bquery = [BmobQuery queryWithClassName:@"CarDetail"];
    if(_car_info_search!=nil){
        [bquery whereKey:@"carInfo" matchesWithRegex:_car_info_search];
    }
    
    if (_min_price != 0 || _max_price != 99999){
        
        NSArray *array =  @[@{@"carPrice":@{@"$gt":  [[NSNumber alloc]initWithInt:_min_price]}},@{@"carPrice":@{@"$lt": [[NSNumber alloc]initWithInt:_max_price]}}];
        
        [bquery addTheConstraintByAndOperationWithArray:array];
    }
    if (_car_sort_search != nil)
    {
        NSLog(@"%@",_car_sort_search);
        
        if ([_car_sort_search  isEqual: @"默认排序"])
        {
            _car_sort_search = @"";
        }
        if ([_car_sort_search  isEqual: @"价格最低"])
        {
            
            [bquery orderByAscending:@"carPrice"];
        }
        if ([_car_sort_search  isEqual: @"价格最高"])
        {
            [bquery orderByDescending:@"carPrice"];
        }
        if ([_car_sort_search  isEqual: @"最新发布"])
        {
            NSLog(@"2222222");
            [bquery orderByDescending:@"updatedAt"];
        }
        if ([_car_sort_search  isEqual: @"只看已售"])
        {
            [bquery whereKey:@"flag" greaterThan:[NSNumber numberWithInt:3]];
        }
    }
    if(![_car_city_search isEqual:@""]){
        NSString * city=[_car_city_search stringByReplacingOccurrencesOfString:@"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0,_car_city_search.length)];
        
        if([_car_city_search isEqualToString:@"大区 京津冀"]){
            [bquery whereKey:@"carLocation" containedIn:[NSArray arrayWithObjects:@"北京",@"天津",@"河北", nil]];
        }else if([_car_city_search isEqualToString:@"大区 晋鲁豫"]){
            [bquery whereKey:@"carLocation" containedIn:[NSArray arrayWithObjects:@"山西",@"山东",@"河南", nil]];
        }else if([_car_city_search isEqualToString:@"大区 黑吉辽"]){
            [bquery whereKey:@"carLocation" containedIn:[NSArray arrayWithObjects:@"黑龙江",@"吉林",@"辽宁", nil]];
        }else if([_car_city_search isEqualToString:@"大区 江浙沪"]){
            [bquery whereKey:@"carLocation" containedIn:[NSArray arrayWithObjects:@"江苏",@"浙江",@"上海", nil]];
        }else if([_car_city_search isEqualToString:@"大区 广深"]){
            [bquery whereKey:@"carLocation" containedIn:[NSArray arrayWithObjects:@"广东",@"广西",@"深圳", nil]];
        }else if([_car_city_search isEqualToString:@"大区 云贵川"]){
            [bquery whereKey:@"carLocation" containedIn:[NSArray arrayWithObjects:@"云南",@"贵州",@"四川", nil]];
        }
        else{
            
            [bquery whereKey:@"carLocation" matchesWithRegex:city];
        }

        
    }

    
    _page++;
    bquery.limit = 10;
    bquery.skip = 10*_page;
    [bquery includeKey:@"cUser"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (array.count > 0) {
            
            for (BmobObject *obj in array) {
                //打印playerName
                CarDetail * carmodel=[[CarDetail alloc]init];
                carmodel.carInfo=[obj objectForKey:@"carInfo"];
                carmodel.carPic=[obj objectForKey:@"carPic"];
                carmodel.contactPhone=[obj objectForKey:@"contactPhone"];
                carmodel.publishTime=[obj objectForKey:@"publishTime"];
                carmodel.userId=[obj objectForKey:@"userId"];
                carmodel.contactName=[obj objectForKey:@"contactName"];
                carmodel.carColor=[obj objectForKey:@"carColor"];
                carmodel.carLocation=[obj objectForKey:@"carLocation"];
                carmodel.carNotes=[obj objectForKey:@"carNotes"];
                carmodel.carPrice=[[obj objectForKey:@"carPrice"]floatValue];
                carmodel.carYearCheck=[obj objectForKey:@"carYearCheck"];
                carmodel.carDistance=[[obj objectForKey:@"carDistance"]floatValue];
                carmodel.flag=[[obj objectForKey:@"flag"]intValue];
                carmodel.cUser=[obj objectForKey:@"cUser"];
                carmodel.objectId=[obj objectId];
                carmodel.createdAt=[obj updatedAt];
                [datasource addObject:carmodel];
                
            }
            // 刷新表格
            [_sousuo_tableview reloadData];
        }
        
        
    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_sousuo_tableview reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_sousuo_tableview footerEndRefreshing];
    });

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return datasource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 90;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
/*设置标题尾的宽度*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

//下面这个函数，用于实现表格中数据的显示
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    
    CarDetail * model=[datasource objectAtIndex:indexPath.row];
    
    
    UIImageView *image1 = (UIImageView*)[cell viewWithTag:1];
    NSURL *URL = [NSURL URLWithString:model.carPic];
    [image1 sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"loading-image"]];
    
    UIImageView *image22 = (UIImageView*)[cell viewWithTag:20];
    if(model.flag==4){
        [image22 setImage:[UIImage imageNamed:@"wode_yiyuding"]];
    }else if(model.flag==3){
        [image22 setImage:[UIImage imageNamed:@"wode_yizhuanche"]];
    }else{
        [image22 setImage:nil];
    }
    
    UIImageView *image15 = (UIImageView*)[cell viewWithTag:15];
    if([[model.cUser objectForKey:@"fundMoney"]floatValue]==1000){
        [image15 setImage:[UIImage imageNamed:@"shouye_baozhang"]];
    }else {
        image15.hidden=YES;
    }
    
    
    UILabel * lable1=(UILabel*)[cell viewWithTag:2];
    lable1.text=model.carInfo;
    
    UILabel * lable2=(UILabel*)[cell viewWithTag:3];
    NSString * bbb=[NSString stringWithFormat:@"%.00f",model.carDistance];
    NSString * bbbb=[bbb stringByAppendingString:@"万公里 /"];
    lable2.text=bbbb;
    
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"MM-dd"];
    NSString * create_date=[formatter stringFromDate:model.createdAt];
    NSString * aaaa=[create_date stringByAppendingString:model.carLocation];
    UILabel * lable4=(UILabel*)[cell viewWithTag:4];
    lable4.text=aaaa;
    
    UILabel * lable5=(UILabel*)[cell viewWithTag:5];
    NSString * ccc=[NSString stringWithFormat:@"%.f",model.carPrice];
    NSString * cccc=[ccc stringByAppendingString:@"万元"];
    lable5.text=cccc;
    
    UILabel * lable7=(UILabel*)[cell viewWithTag:7];
    NSString * ns=[model.carYearCheck substringToIndex:4];
    
    lable7.text=ns;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _row=(int)indexPath.row;
    [self performSegueWithIdentifier:@"sousuo_" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqual:@"sousuo_"]){
        CarDetail * model=[datasource objectAtIndex:_row];
        UINavigationController * navi=segue.destinationViewController;
        ZhaoCheDetailViewController *detail =navi.viewControllers.firstObject;
                NSLog(@"%@",[[datasource objectAtIndex:_row]objectId]);
        detail.carInfoID = [[datasource objectAtIndex:_row]objectId];
        detail.fff=(int)model.flag;
    }
    if([segue.identifier isEqual:@"dianzhi"]){
         UINavigationController * navi=segue.destinationViewController;
         CityViewController *detail =navi.viewControllers.firstObject;
        
        detail.city_select_type = @"找车-城市选择1";

     }
    
}


- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 3;
}
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    switch (column)
    {
        case 0:{
            return _citys.count;
            break;
        }
        case 1:
        {
            return _ages.count;
            break;
        }
            
        case 2:
        {
            return _genders.count;
            break;
        }
        default:
        {
            return 0;
            break;
        }
    }
    
}
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    switch (indexPath.column) {
        case 0: return self.citys[indexPath.row];
            break;
        case 1: return self.ages[indexPath.row];
            break;
        case 2: return self.genders[indexPath.row];
            break;
        default:
            return nil;
            break;
    }
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
    
    //  NSLog(@"%@",[menu titleForRowAtIndexPath:indexPath]);
    
    //点击的是哪个抽屉
    //    NSString *title = [menu titleForRowAtIndexPath:indexPath];
    
    switch (indexPath.column)
    {
            
        case 0:{
       
                if(indexPath.row == 0) {
                 
                    self.car_type_search = @"";
                    [self setupRefresh];
                    return;
                }else{
                    CityViewController* view = [self.storyboard instantiateViewControllerWithIdentifier:@"city_select_view"];
                    
                    
                    view.city_select_type = @"找车-城市选择1";
                    
                    [self.navigationController pushViewController:view animated:YES];
                    return;
                    
      
             
        
            
                
                
            }
            
            break;
        }
            
        case 1:{
            if(indexPath.row == 0) {
                NSLog(@"全部价格");
                
                _min_price = 0;
                _max_price = 99999;
                [self setupRefresh];
                return;
                
            }else if(indexPath.row == 1){
                NSLog(@"0-3");
                //                self.min_price = 0
                //                self.max_price = 3
                _min_price=0;
                _max_price=3;
                [self setupRefresh];
                return;
                
            }else if(indexPath.row == 2){
                NSLog(@"3-5");
                _min_price=3;
                _max_price=5;
                //                self.min_price = 3
                //                self.max_price = 5
                [self setupRefresh];
                return;
                
            }else if(indexPath.row == 3){
                NSLog(@"5-8");
                _min_price=5;
                _max_price=8;
                //                self.min_price = 5
                //                self.max_price = 8
                [self setupRefresh];
                return;
                
            }else if(indexPath.row == 4){
                NSLog(@"8-10");
                _min_price=8;
                _max_price=10;
                //                self.min_price = 8
                //                self.max_price = 10
                [self setupRefresh];
                return;
                
            }else if(indexPath.row == 5){
                NSLog(@"10-15");
                _min_price=10;
                _max_price=15;
                //                self.min_price = 10
                //                self.max_price = 15
                [self setupRefresh];
                return;
                
            }else if(indexPath.row == 6){
                NSLog(@"15-20");
                _min_price=15;
                _max_price=20;
                //                self.min_price = 15
                //                self.max_price = 20
                [self setupRefresh];
                return;
                
            }else{
                NSLog(@"20-99999");
                _min_price=20;
                _max_price=99999;
                //                self.min_price = 20
                //                self.max_price = 99999
                [self setupRefresh];
                return;
                
            }
            break;
        }
            
        case 2:{
            if(indexPath.row == 0){
                NSLog(@"默认排序");
                _car_sort_search=@"默认排序";
                //                self.car_sort_search = ""
                [self setupRefresh];
                return;
                
            }else if(indexPath.row == 1){
                _car_sort_search=@"价格最低";
                NSLog(@"价格最低");
                //                self.car_sort_search = "价格最低"
                [self setupRefresh];
                return;
                
            }else if(indexPath.row == 2){
                _car_sort_search=@"价格最高";
                NSLog(@"价格最高");
                //                self.car_sort_search = "价格最高"
                [self setupRefresh];
                return;
                
            }else if(indexPath.row == 3){
                _car_sort_search=@"最新发布";
                NSLog(@"最新发布");
                //                self.car_sort_search = "最新发布"
                [self setupRefresh];
                return;
                
            }else{
                _car_sort_search=@"只看已售";
                NSLog(@"只看已售");
                //        self.car_sort_search = "只看已售"
                [self setupRefresh];
                return;
                
            }
            break;
        }
        default:
            return;
            
    }
    
}






- (IBAction)huiqv:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
