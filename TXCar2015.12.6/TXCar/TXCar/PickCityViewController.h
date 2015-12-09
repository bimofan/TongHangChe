//
//  PickCityViewController.h
//  TXCar
//
//  Created by ZhuHaikun on 15/12/10.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^pickBlock)(NSDictionary*dict,BOOL isCity);


@interface PickCityViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    pickBlock _block;
    
    
}
-(void)pickCityBlock:(pickBlock)block;

@end
