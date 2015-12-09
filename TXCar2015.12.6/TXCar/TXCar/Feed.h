//
//  Feed.h
//  TXCar
//
//  Created by jack on 15/10/8.
//  Copyright © 2015年 BH. All rights reserved.
//
#import <BmobSDK/Bmob.h>

@interface Feed : BmobObject
@property(nonatomic,copy)NSString *content;

@property(nonatomic,copy)NSString * name;

@property(nonatomic,assign)NSNumber* love;
@property(nonatomic,assign)NSInteger share;
@property(nonatomic,assign)NSInteger comment;

@end
