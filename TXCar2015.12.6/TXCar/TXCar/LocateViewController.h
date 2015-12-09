//
//  LocateViewController.h
//  BmobIMDemo
//
//  Created by Bmob on 14-7-21.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^LocateBlock)(NSString*address,CLLocationCoordinate2D coord);


@interface LocateViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>


-(void)setLocateBlock:(LocateBlock)block;



@end
