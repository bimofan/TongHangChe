//
//  ZhaoCheViewController.m
//  TXCar
//
//  Created by jack on 15/9/17.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import "ZhaoCheViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobUser.h>
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
#import "sousuocheViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"

@interface ZhaoCheViewController ()<UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDataSource, DOPDropDownMenuDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView * tableview_car_list;
@property (nonatomic,assign) int page;
@property (nonatomic, copy) NSArray *citys;
@property (nonatomic, copy) NSArray *ages;
@property (nonatomic, copy) NSArray *genders;
@property (nonatomic, assign) int row;
@property (nonatomic, assign) int row1;

@property (nonatomic,assign)  int min_price;
@property (nonatomic,assign)  int max_price;


@property (nonatomic, copy) NSString * car_price_search;
@property (nonatomic, copy) NSString * car_sort_search;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *city_select_button;
@property (nonatomic,strong) CLLocationManager *manager;
@property (nonatomic, copy) NSString * car_info_search;
@end

@implementation ZhaoCheViewController

{
    NSMutableArray * datasource;
    BmobQuery   *bquery;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    
    _manager = [[CLLocationManager alloc]init];
    _manager.delegate =self;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        [_manager requestWhenInUseAuthorization];
        
    }
    else
    {
        
        [_manager startUpdatingLocation];
        
    }
    
    
  
    
    
    _selecte_city=@"全国";
  
    _min_price=0;
    _max_price=99999;
    
    _citys = @[@"全部品牌",@"指定车型"];
    _ages = @[@"价格不限",@"3万及以下",@"3-5万",@"5-8万",@"8-10万",@"10-15万",@"15-20万",@"20万以上"];
    _genders =@[@"默认排序",@"价格最低",@"价格最高",@"最新发布",@"只看已售"];
    
    
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:40];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    
    //刷新
    [_tableview_car_list addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
    [_tableview_car_list addFooterWithTarget:self action:@selector(footerRereshing)];
    [self setupRefresh];
    
    
    datasource=[[NSMutableArray alloc]init];
    _tableview_car_list.dataSource = self;
    _tableview_car_list.delegate = self;
    
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.city_select_button.title = _selecte_city;
    
}


- (IBAction)sousuo:(UIBarButtonItem *)sender {
    
    
    sousuocheViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"sousuocheliang"];

    [self.navigationController pushViewController:detail animated:YES];
    
    
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)setupRefresh
{
    [_tableview_car_list headerBeginRefreshing];
}


- (void)headerBeginRefreshing
{

    bquery = [BmobQuery queryWithClassName:@"CarDetail"];
    bquery.limit = 10;

    
    [bquery whereKey:@"flag" greaterThan:[NSNumber numberWithInt:0]];
  
    if(_car_type_search !=nil){
       
        [bquery whereKey:@"carInfo" matchesWithRegex:_car_type_search];
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
    NSLog(@"%@",_car_city_search);
    if(_car_city_search != nil){
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
            
            
            [_tableview_car_list reloadData];
            
            
            
        }

        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableview_car_list reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableview_car_list headerEndRefreshing];
    });
  
}


-(void)footerRereshing{
    bquery = [BmobQuery queryWithClassName:@"CarDetail"];
    [bquery orderByDescending:@"updatedAt"];
    [bquery whereKey:@"flag" greaterThan:[NSNumber numberWithInt:0]];
    if(_car_type_search !=nil){
        [bquery whereKey:@"carInfo" matchesWithRegex:_car_type_search];
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
            [_tableview_car_list reloadData];
        }
 
        
    }];
 
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableview_car_list reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        
        [_tableview_car_list footerEndRefreshing];
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
  
//    dispatch_async(dispatch_get_main_queue(), ^{
//       
//        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:URL]];
//         image = [CommondMethods fitImageSizeWithImage:image with:image1.frame.size.width height:image1.frame.size.height];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            image1.image = image;
//            
//        });
//    });
    
    [image1 sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"loading-image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        
//        image = [CommondMethods fitImageSizeWithImage:image with:image1.frame.size.width height:image1.frame.size.height];
        
//        image1.image = [CommondMethods fitImageSizeWithImage:image1.image with:image1.frame.size.width height:image1.frame.size.height];
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//            
// 
//        });
        
        
    }];
    
    image1.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UIImageView *image22 = (UIImageView*)[cell viewWithTag:20];
    if(model.flag==4){
        [image22 setImage:[UIImage imageNamed:@"wode_yiyuding"]];
    }else if(model.flag==3){
        [image22 setImage:[UIImage imageNamed:@"wode_yizhuanche"]];
    }else{
        [image22 setImage:nil];
    }
    
    UIImageView *image15 = (UIImageView*)[cell viewWithTag:15];
    if([[model.cUser objectForKey:@"hasPayFund"]intValue]==1){
        [image15 setImage:[UIImage imageNamed:@"shouye_baozhang"]];
        image15.hidden=NO;
    }else {
        image15.hidden=YES;
    }

    
    UILabel * lable1=(UILabel*)[cell viewWithTag:2];
    lable1.text=model.carInfo;
    
    UILabel * lable2=(UILabel*)[cell viewWithTag:3];
    NSString * bbb=[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:model.carDistance]];
    NSString * bbbb=[NSString stringWithFormat:@"%@%@",[bbb stringByAppendingString:@"万公里 / "],[model.carYearCheck substringToIndex:4]];
    
    lable2.text=bbbb;
    
    UILabel * lable44=(UILabel*)[cell viewWithTag:10];
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"MM-dd hh:mm"];
    NSString * create_date=[formatter stringFromDate:model.createdAt];
    lable44.text=create_date;

    

    
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
     NSTimeInterval time1 = [model.createdAt timeIntervalSince1970];
    long long int date = (long long int)time;
     long long int date1 = (long long int)time1;
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *yesterday,*yesterday1;

    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    yesterday1 = [today dateByAddingTimeInterval: -secondsPerDay*2];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
   
    lable44.textColor=[UIColor blackColor];
    NSString * dateString = [[model.createdAt description] substringToIndex:10];
   
    if ([dateString isEqualToString:todayString])
    {
        NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"hh:mm"];
        NSString * create_date=[formatter stringFromDate:model.createdAt];
        lable44.text=[NSString stringWithFormat:@"今天 %@",create_date];
        lable44.textColor=[UIColor colorWithRed:247/255.0 green:84/255.0 blue:43/255.0 alpha:1];
        
    } else if ([dateString isEqualToString:yesterdayString])
    {
        NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
        [formatter setLocale:[NSLocale currentLocale]];
        [formatter setDateFormat:@"hh:mm"];
        NSString * create_date=[formatter stringFromDate:model.createdAt];
        lable44.text=[NSString stringWithFormat:@"昨天 %@",create_date];
        
    }else if (date-date1<= 3600*24*7)
    {
        lable44.text=@"一周内";

    }
   

    
    
    
    
    
    
    
    
    
     UILabel * lable9=(UILabel*)[cell viewWithTag:9];
    lable9.text=model.carLocation;
    UILabel * lable5=(UILabel*)[cell viewWithTag:5];
    NSString * ccc=[NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:model.carPrice]];
    NSString * cccc=[ccc stringByAppendingString:@"万元"];
    if([ccc intValue]==0){
        lable5.text=@"电议";
    }else{
    lable5.text=cccc;
    }
//    UILabel * lable7=(UILabel*)[cell viewWithTag:7];
//    NSString * ns=[model.carYearCheck substringToIndex:4];
//    
//    lable7.text=ns;
    return cell;
}






-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     _row=(int)indexPath.row;
    [self performSegueWithIdentifier:@"lalalala" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqual:@"lalalala"]){
        CarDetail * model=[datasource objectAtIndex:_row];
         UINavigationController * navi=segue.destinationViewController;
        ZhaoCheDetailViewController *detail =navi.viewControllers.firstObject;
        detail.carInfoID = [[datasource objectAtIndex:_row]objectId];
        detail.fff=(int)model.flag;
        detail.asd=1;
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
                NSLog(@"全部车型");
                self.car_type_search = @"";
                [self setupRefresh];
                return;
            }else{
                NSLog(@"选择车型");
                
                
                 CarSelectViewController *detail1 = [self.storyboard instantiateViewControllerWithIdentifier:@"car_select_view"];
                detail1.type_info=@"找车-车型选择";
                
                
                [self.navigationController pushViewController:detail1 animated:YES];
                
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

- (IBAction)city_clicked:(UIBarButtonItem *)sender {
    CityViewController* view = [self.storyboard instantiateViewControllerWithIdentifier:@"city_select_view"];
    
    
    view.city_select_type = @"找车-城市选择";
    
    [self.navigationController pushViewController:view animated:YES];
}



-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [_manager startUpdatingLocation];
        
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *lastLocation = [locations lastObject];
    
    if (lastLocation) {
        
        [_manager stopUpdatingLocation];
        
        [self geocodeCity:lastLocation];
        
    }
}




-(void)geocodeCity:(CLLocation*)location
{
    CLGeocoder *_geoCoder = [[CLGeocoder alloc]init];


    [_geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        CLPlacemark * placemark = [placemarks firstObject];
 
        NSLog(@"详细地址：%@",[placemark.addressDictionary objectForKey:@"Name"]);
   
        NSString *aaa=[NSString stringWithFormat:@"%f",location.coordinate.latitude];
         NSString *bbb=[NSString stringWithFormat:@"%f",location.coordinate.longitude];
        
        if([BmobUser getCurrentUser]!=nil){
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        //    //申明返回的结果是json类型
        //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //    //申明请求的数据是json类型
        //    manager.requestSerializer=[AFJSONRequestSerializer serializer];
        
            NSString *addressName = [placemark.addressDictionary objectForKey:@"Name"];
            NSString *userName = [BmobUser getCurrentUser].username;
            
            if (!addressName) {
                
                addressName = @"";
            }
            if (!userName) {
                
                userName = @"";
            }
        NSDictionary *parameters = @{@"lat":aaa,@"lon":bbb,@"addr":addressName,@"username":userName,@"from":@"IOS"};
        [manager POST:@"http://tonghangche.com/system/mobile/savePositionInfo"parameters:parameters
              success:^(AFHTTPRequestOperation *operation,id responseObject) {
                  if([[responseObject objectForKey:@"code"] intValue]==1){
                      NSLog(@"成功");
                  }
                 
              }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
               
                  NSLog(@"失败Error: %@", error);

              }
         ];

    }
     
        
        
        
        
        
    }];
}


@end
