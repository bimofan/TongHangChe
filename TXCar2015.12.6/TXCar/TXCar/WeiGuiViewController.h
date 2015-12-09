//
//  WeiGuiViewController.h
//  TXCar
//
//  Created by ZhuHaikun on 15/12/9.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiGuiViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *IsprefixLabel;

@property (weak, nonatomic) IBOutlet UITextField *carNumLabel;

@property (weak, nonatomic) IBOutlet UITextField *citytextField;

@property (weak, nonatomic) IBOutlet UITextField *enginenoTextField;
@property (weak, nonatomic) IBOutlet UITextField *framenoTextField;
@property (weak, nonatomic) IBOutlet UIButton *pickcityButton;
- (IBAction)pickcityAction:(id)sender;
- (IBAction)searchButton:(id)sender;

@end