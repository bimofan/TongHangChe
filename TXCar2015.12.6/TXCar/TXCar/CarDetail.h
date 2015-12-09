//
//  CarDetail.h
//  TXCar
//
//  Created by jack on 15/9/18.
//  Copyright (c) 2015年 BH. All rights reserved.
//


#import "User.h"
@interface CarDetail : BmobObject
@property(nonatomic,copy)  NSString * userName;
@property(nonatomic,strong)  User *cUser;
@property(nonatomic,copy)  NSString * collected;
@property(nonatomic,copy)  NSString * userId;
@property(nonatomic,copy)  NSString * carInfo;

@property(nonatomic,copy)  NSString * carPic;

@property(nonatomic,copy)  NSString * carLocation;

@property(nonatomic,assign)  float carDistance ;
@property(nonatomic,copy)  NSString * carColor;

@property(nonatomic,copy)  NSString * carNotes;

@property(nonatomic,copy)  NSString * carYearCheck;

@property(nonatomic,copy)  NSString * contactName;

@property(nonatomic,copy)  NSString * contactPhone;

@property(nonatomic,copy)  NSString * carState;

@property(nonatomic,copy)  NSString * publishTime;

@property(nonatomic,assign)  float carPrice;
@property(nonatomic,assign) float flag;

@property(nonatomic,assign) bool isPriceTalk;

@end
