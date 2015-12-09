//
//  SendWXViewController.h
//  TXCar
//
//  Created by ZhuHaikun on 15/11/6.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendWXViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIView *photoView;
- (IBAction)photoButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *sayLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoViewHeightConstants;

@end
