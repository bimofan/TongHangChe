//
//  Comment.h
//  TXCar
//
//  Created by jack on 15/10/9.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <BmobSDK/Bmob.h>
#import "User.h"
@interface Comment : BmobObject

@property(nonatomic,copy)NSString *commentContent;
@property(nonatomic,strong)User *user;
@end
