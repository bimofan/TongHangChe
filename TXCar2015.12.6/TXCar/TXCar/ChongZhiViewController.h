//
//  ChongZhiViewController.h
//  TXCar
//
//  Created by jack on 15/10/12.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PassValueDelegate
- (void)setValue:(NSString *)value;
@end
@interface ChongZhiViewController : UIViewController
{
    id<PassValueDelegate> passDelegate;
    
}
@property(nonatomic, retain) id<PassValueDelegate> passDelegate;
@end
