//
//  User.h
//  TXCar
//
//  Created by jack on 15/9/18.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import <BmobSDK/Bmob.h>

@interface User : BmobUser

@property(nonatomic,copy)NSString *contact;
@property(nonatomic,copy)NSString * avatar;
@property(nonatomic,copy)NSString * sign;
@property(nonatomic,copy)NSString * location;
@property(nonatomic,assign) float fundMoney;

@property(nonatomic,assign) bool hasPayFund;
@property(nonatomic,assign) bool hasLock;


@property(nonatomic,assign) NSInteger commentNum;
@property(nonatomic,assign) NSInteger rateMain;
@property(nonatomic,assign) NSInteger rateDes;
@property(nonatomic,assign) NSInteger rateServe;
@property(nonatomic,copy)NSString * from;

//private BmobRelation favorite;
//private BmobRelation favCar;
//
//private Integer commentNum;// 评论总数
//private Integer rateMain;// 总体评价分数
//private Integer rateDes;// 描述相符
//private Integer rateServe;// 服务态度
//
//private Boolean hasLock;//是否被锁定
//// 操作渠道 android ios
//private String from;







@property(nonatomic,assign)  float  money;
@property(nonatomic)BOOL isAdmin;
@property(nonatomic,copy)NSString *installId;


@end
