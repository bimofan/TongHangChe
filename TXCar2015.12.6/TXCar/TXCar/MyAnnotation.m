//
//  MyAnnotation.m
//  QianShouBang
//
//  Created by ZhuHaikun on 15/8/18.
//  Copyright (c) 2015年 zhuhaikun. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation

-(id)initWithCoord:(CLLocationCoordinate2D)coord
{
    if (self == [super init]) {
        
        self.coordinate = coord;
        
    }
    
    return self;
}



@end
