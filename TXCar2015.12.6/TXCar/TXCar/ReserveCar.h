//
//  ReserveCar.h
//  TXCar
//
//  Created by jack on 15/10/13.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import "User.h"
#import "CarDetail.h"
@interface ReserveCar : BmobObject
@property(nonatomic,copy)NSString *sDate; //看车日期
@property(nonatomic,copy)NSString *sContact;//看车联系人
@property(nonatomic,copy)NSString *sPhone;//看车联系人电话

@property(nonatomic,strong)CarDetail* sCar;//车辆信息
@property(nonatomic,strong)User *sUser;//看车人
@property(nonatomic,strong)User *cUser;
@property(nonatomic,copy)NSString *seeUserId; //看车人id
@property(nonatomic,copy)NSString *carUserId;//发车人id

@property(nonatomic,copy)NSString *cancleType;//取消类别
@property(nonatomic,copy)NSString *cancleReason;//取消原因

@property(nonatomic,copy)NSString *commentId ;//订单评论

@property(nonatomic,assign)int state; //1 看车信息提交  2 买家已付定金  3 卖家确认   4 转车成功  5 转车失败(未退还定金) 6 已退还定金
@end
