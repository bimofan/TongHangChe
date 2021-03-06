//
//  PrefixView.h
//  TXCar
//
//  Created by ZhuHaikun on 15/12/11.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#define screenwith [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height

@protocol SelectedPrefix <NSObject>

-(void)didSelectedPrefix:(NSString*)prefix;


@end


@interface PrefixView : UIView
{
    NSArray *_dataSource;
    
    UIView *whiteView;
    
    
}

@property (nonatomic,assign) id <SelectedPrefix> delegate;

@end
