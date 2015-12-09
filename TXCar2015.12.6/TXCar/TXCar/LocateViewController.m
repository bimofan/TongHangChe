//
//  LocateViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 14-7-21.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "LocateViewController.h"

#import "CommonUtil.h"
#import "ChatViewController.h"

@interface LocateViewController (){
//    BMKMapView                  *_mapView;     //百度地图
//    BMKLocationService          *_locService;  //定位
//    BMKGeoCodeSearch            *_geocodesearch;//地理编码
    
    MKMapView *_mapview;
     CLLocationManager *_locationManager;
    CLLocationCoordinate2D      _currentLocationCoordinate2D;//当前百度坐标
    NSString             *_addressString;//当前地理位置
    
    LocateBlock _block;
    
}
@end

@implementation LocateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"位置";
        
        _addressString = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *rightButton                  = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame                      = CGRectMake(0, 0, 50, 44);
    [[rightButton titleLabel] setFont:[UIFont systemFontOfSize:15]];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem             = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    ;
    
    
    _mapview = [[MKMapView alloc]initWithFrame:self.view.frame];
    _mapview.delegate = self;
    [self.view addSubview:_mapview];
    
    _mapview.showsUserLocation = YES;
    
    //定位
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {//ios8以后
        [_locationManager requestWhenInUseAuthorization];
        //        [_locationManager requestAlwaysAuthorization];
    }
    else
    {
        [_locationManager startUpdatingLocation];
    }
  

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}



-(void)dealloc{
    
}

-(void)send{
  
    if (_addressString && _block)
    {
        _block(_addressString,_currentLocationCoordinate2D);
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
}


#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse ||  status == kCLAuthorizationStatusAuthorizedAlways) {
        
        [_locationManager startUpdatingLocation];;
        
    }
    else
    {
        [[[UIAlertView alloc]initWithTitle:nil message:@"无法定位，请在 设置－隐私－定位服务 里开启定位允许" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show ];
        
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
//    for (CLLocation *location in locations)
    {
        
        
        [self locateLocation:[locations lastObject]];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}

- (void)locateLocation:(CLLocation *)location {
    
    
    location =  _mapview.userLocation.location;
    
    CLGeocoder *_myGeocoder = [[CLGeocoder alloc] init];
    
    
    [_myGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error == nil && [placemarks count] > 0) {
            //这时的placemarks数组里面只有一个元素
            CLPlacemark * placemark = [placemarks firstObject];
            
            NSLog(@"=========== addressDictionary:%@", placemark.addressDictionary);
            
            
            
            NSString *name =placemark.name;
            
            _addressString = name;
            
            _currentLocationCoordinate2D = location.coordinate;
            
         
            [_mapview setRegion:MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000) animated:YES];
            
            [_locationManager stopUpdatingLocation];
            
            _mapview.showsUserLocation = YES;
            
            
            self.navigationItem.rightBarButtonItem.enabled = YES;
            ;
            
        }
    }];
    
    /*
     city:上海市市辖区  城市
     country:中国    国家
     name:中国上海市徐汇区漕河泾街道漕河泾田东路  具体地址
     state:上海市   省份
     street:田东路  街道完整名称
     sublocaality:徐汇区  区名
     subthoroughfare:(null)
     thoroughfare:田东路 街道
     */
    /*
     dic Name = 宏润国际花园(西区)
     dic State = 上海市
     dic Street = 漕东支路 218弄
     dic SubLocality= 徐汇区
     dic SubThoroughfare= 218弄
     dic Thoroughfare = 漕东支路
     */
    
    
    /*
     {
     City = "\U4e0a\U6d77\U5e02\U5e02\U8f96\U533a";
     Country = "\U4e2d\U56fd";
     CountryCode = CN;
     FormattedAddressLines =     (
     "\U4e2d\U56fd\U4e0a\U6d77\U5e02\U5f90\U6c47\U533a\U6f15\U6cb3\U6cfe\U8857\U9053\U6f15\U4e1c\U652f\U8def218\U5f04"
     );
     Name = "\U5b8f\U6da6\U56fd\U9645\U82b1\U56ed(\U897f\U533a)";
     State = "\U4e0a\U6d77\U5e02";
     Street = "\U6f15\U4e1c\U652f\U8def 218\U5f04";
     SubLocality = "\U5f90\U6c47\U533a";
     SubThoroughfare = "218\U5f04";
     Thoroughfare = "\U6f15\U4e1c\U652f\U8def";
     }
     
     
     */
    
}


-(void)setLocateBlock:(LocateBlock)block
{
    _block = block;
    
    
}

@end
