//
//  QvXianViewController.h
//  TXCar
//
//  Created by jack on 15/10/12.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BackValueDelegate<NSObject>
-(void)changeText:(NSString *)string;
@end
@interface QvXianViewController : UIViewController
@property (nonatomic,retain) id<BackValueDelegate>delegate;
@end
