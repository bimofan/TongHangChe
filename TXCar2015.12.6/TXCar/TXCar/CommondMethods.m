//
//  CommondMethods.m
//  TXCar
//
//  Created by ZhuHaikun on 15/12/13.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "CommondMethods.h"

@implementation CommondMethods

#pragma mark - 对图片进行大小压缩
+(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

#pragma mark - 自动压缩图片
+ (UIImage*)autoSizeImageWithImage:(UIImage *)image
{
    CGSize imageSize = image.size;
    
    
    CGFloat imagewith = 300.0;
    
    CGFloat imageHeight = imageSize.height *imagewith/imageSize.width;
    
    
    
    return [self imageWithImage:image scaledToSize:CGSizeMake(imagewith, imageHeight)];
    
    
    
}

#pragma mark - 裁剪图片
+ (UIImage*)fitImageSizeWithImage:(UIImage*)image with:(CGFloat)with height:(CGFloat)height{
    
    CGSize imageSize = image.size;
    
    
    CGFloat imagewith = with;
    
    CGFloat imageHeight = imageSize.height *imagewith/imageSize.width;
    
    
    
     UIImage *scaleImage = [self imageWithImage:image scaledToSize:CGSizeMake(imagewith, imageHeight)];
    
    UIGraphicsBeginImageContext(scaleImage.size);
//    CGContextRef currentcontext = UIGraphicsGetCurrentContext();
    
    
     [scaleImage drawInRect:CGRectMake(0, 0, with, height)];
    
    scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    return scaleImage;
    
    
    
    
}

@end
