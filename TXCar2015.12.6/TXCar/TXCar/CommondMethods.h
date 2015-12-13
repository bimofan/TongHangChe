//
//  CommondMethods.h
//  TXCar
//
//  Created by ZhuHaikun on 15/12/13.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommondMethods : NSObject

#pragma mark - 裁剪图片
+ (UIImage*)fitImageSizeWithImage:(UIImage*)image with:(CGFloat)with height:(CGFloat)height;

#pragma mark - 对图片进行大小压缩
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;


#pragma mark - 自动压缩图片
+ (UIImage*)autoSizeImageWithImage:(UIImage *)image;


@end
