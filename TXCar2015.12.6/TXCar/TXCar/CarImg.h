//
//  CarImg.h
//  TXCar
//
//  Created by jack on 15/9/18.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import <BmobSDK/Bmob.h>

@interface CarImg : BmobObject
@property(nonatomic,copy)  NSString * carId;
@property(nonatomic,copy)  NSString *  imgName;
@property(nonatomic,copy)  NSString * url;
@end
