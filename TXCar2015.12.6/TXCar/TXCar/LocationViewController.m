//
//  LocationViewController.m
//  BmobIMDemo
//
//  Created by Bmob on 14-7-14.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "LocationViewController.h"

#import "CommonUtil.h"

#define IS_iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)

#define ViewOriginY (IS_iOS7 ? 64:0)
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height


@interface LocationViewController (){
   
    
    MKMapView *_mapView;
    
}



@property (nonatomic) CLLocationCoordinate2D coord;


@end

@implementation LocationViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(instancetype)initWithLocationCoordinate:(CLLocationCoordinate2D)coord{
    self = [super init];
    if (self) {
        
        self.coord = coord;
        
        self.title = @"定位";
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _mapView                   = [[MKMapView alloc] initWithFrame:CGRectMake(0, ViewOriginY, ScreenWidth, ScreenHeight - ViewOriginY)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_mapView setRegion:MKCoordinateRegionMakeWithDistance(self.coord, 500, 500) animated:YES];
    
    MyAnnotation *pinanno = [[MyAnnotation alloc]initWithCoord:self.coord];
    
    [_mapView addAnnotations:@[pinanno]];
    
    
}



-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MyAnnotation *myanno =  annotation;
    
    MKPinAnnotationView *pinkView = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"location"];
    
    
    
    return pinkView;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goback{
//    [super goback];
//    self.mapView = nil;
    
}


//- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation{
//
//    NSString *AnnotationViewID = @"annotationViewID";
//	//根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
//    BMKAnnotationView *annotationView =[view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
//   
//    if (annotationView == nil) {
//        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//		((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorRed;
//		((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
//    }
//	
//	annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
//    annotationView.annotation = annotation;
//	annotationView.canShowCallout = TRUE;
//    annotationView.selected = YES;
//    return annotationView;
//}


#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]


- (NSString*)getMyBundlePath1:(NSString *)filename {
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		return s;
	}
	return nil ;
}

@end
