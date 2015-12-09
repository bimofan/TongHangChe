//
//  chadang.h
//  TXCar
//
//  Created by jack on 15/10/26.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chadang : NSObject
@property(nonatomic,copy)NSString *carNumber;
@property(nonatomic,copy)NSString *sContact;;
@property(nonatomic,copy)NSString *sPhone;
@property(nonatomic,copy)NSString *userId;;
@property(nonatomic,copy)NSString * picUrl;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString * failReason;
@property(nonatomic,assign)int state;

@end
