//
//  MyAnnotation.h
//  QianShouBang
//
//  Created by ZhuHaikun on 15/8/18.
//  Copyright (c) 2015年 zhuhaikun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MyAnnotation : NSObject

@property (nonatomic) CLLocationCoordinate2D coordinate;


// Title and subtitle for use by selection UI.
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

-(id)initWithCoord:(CLLocationCoordinate2D)coord;



@end
