//
//  Header.h
//  TXCar
//
//  Created by jack on 15/10/10.
//  Copyright © 2015年 BH. All rights reserved.
//
#import <Availability.h>
#ifndef Header_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#define Header_h

//订车状态
//1 看车信息提交  2 买家已付定金  3 卖家确认   4 转车成功  12;//买家取消定金  13;//买家取消看车  22;//卖家取消确认订单   23;//卖家取消看车
#define RESERVE_SEE_CAR  1
#define RESERVE_PAYED  2
#define RESERVE_SALER_SURE  3
#define RESERVE_SUCCED  4
#define RESERVE_BUYER_CANCLE_PAYED  12//买家取消定金
#define RESERVE_BUYER_CANCLE_SEE  13//买家取消看车
#define RESERVE_SALER_CANCLE_SURE  22//卖家取消确认订单
#define RESERVE_SALER_CANCLE_SEE  23//卖家取消看车

#define RESERVE_ORDER_PRICE  100000 //预约定金（以分为单位）1000
#define BAOZHENGJIN_PRICE  100000 //保证金（以分为单位）1000
#define QUEREN_CAR_PRICE  2000 //查档手续费（以分为单位）20

//定金金额
#define  RESERVE_ORDER_PRICE_MONEY  1000 //定金金额（以元为单位,要和上面的以分为单位的值相同）
#define  RESERVE_ORDER_BAOZHENGJIN_MONEY  1000 //保证金金额
#define  RESERVE_ORDER_BAOZHENGJIN_PAY  -1000 //卖家缴纳保证金金额
#define  RESERVE_MINUS_PRICE_MONEY  400 //定金扣除金额（以元为单位）
#define  RESERVE_CANCLE_PRICE_MONEY  200 //取消订单扣除金额（以元为单位）
//ping 支付标识
#define PAY_SUCCED  1 //支付成功
#define PAY_FAIL  -1 //支付失败
#define PAY_CANCLE  0 //用户取消

//账户操作标识
#define FLAG_PAY  1// 充值
#define FLAG_GET  -1// 提现
#define FLAG_ORDER_AND_BAOZHENG  2// 买家定金和保证金(已扣除手续费)
#define FLAG_ORDER_BACK_ALL  3// 定金全部退还
#define FLAG_BAOZHENGJIN_BACK_ALL  4// 保证金退还
#define FLAG_ORDER_BACK_MINUS  5// 定金返还(已扣除200手续费)
#define FLAG_BAOZHENGJIN_BACK_MINUS  6// 保证金返还(已扣除200手续费)
#define FLAG_ORDER_PAY_BAOZHENGJIN  7// 缴纳保证金
#define FLAG_ORDER_PAY_DINGJIN  8 //支付定金
#define FLAG_ORDER_PAY_CHADANG  9   // 支付查档手续费
#define FLAG_ORDER_PAY_BAOZHANG  10  // 支付信誉保障金

//if((int)model.type == FLAG_ORDER_BACK_ALL  )
//{
//    label.text = @"定金返还";
//}
//if( (int)model.type == FLAG_ORDER_BACK_MINUS  )
//{
//    label.text = @"定金返还(已扣除200手续费)";
//}
//if((int)model.type == FLAG_BAOZHENGJIN_BACK_ALL  )
//{
//    label.text = @"保证金退还";
//}
//if( (int)model.type == FLAG_BAOZHENGJIN_BACK_MINUS  )
//{
#define KEFU_PHONE 57796744 
//    label.text = @"保证金返还(已扣除200手续费)";
//}
//if( (int)model.type == FLAG_ORDER_AND_BAOZHENG )
//{
//    label.text = @"买家定金和保证金(已扣除手续费)";
//}
//if( (int)model.type == FLAG_ORDER_PAY_BAOZHENGJIN )
//{
//    label.text = @"缴纳保证金";
//}
//if( (int)model.type == FLAG_ORDER_PAY_DINGJIN )
//{
//    label.text = @"支付定金";
//}
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width


//DeviceToken installId data
#define kDeviceTokenData        @"DeviceTokenData"

#define IS_IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define StatueBarHeight (IS_iOS7 ? 20:0)
#define NavigationbarHeight (IS_iOS7 ? 44:0)
#define ViewOriginY (IS_iOS7 ? 64:0)
#define RGB(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define kBackGroundColor  RGB(240,240,240,1)
#define kMBProgressTag 9999
#define IS_iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

#define STATE_FIRST  0
#define STATE_PASS  1
#define STATE_NOPASS  2
#define STATE_SALED  3
#define STATE_RESERVED  4//已预定
#define STATE_CANCLED  5
//已取消
#endif /* Header_h */
