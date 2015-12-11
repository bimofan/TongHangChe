//
//  WeiGuiViewController.h
//  TXCar
//
//  Created by ZhuHaikun on 15/12/9.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "WeiGuiHistoryTVC.h"

@interface WeiGuiViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *IsprefixLabel;

@property (weak, nonatomic) IBOutlet UITextField *carNumLabel;

@property (weak, nonatomic) IBOutlet UIButton *lsprefixButton;


- (IBAction)showPreFix:(id)sender;


@property (weak, nonatomic) IBOutlet UITextField *citytextField;

@property (weak, nonatomic) IBOutlet UITextField *enginenoTextField;
@property (weak, nonatomic) IBOutlet UITextField *framenoTextField;
@property (weak, nonatomic) IBOutlet UIButton *pickcityButton;
- (IBAction)pickcityAction:(id)sender;
- (IBAction)searchButton:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *engineLabel;
@property (weak, nonatomic) IBOutlet UIView *enginelineView;
@property (weak, nonatomic) IBOutlet UIView *chejialineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *chejialabel;

@property (weak, nonatomic) IBOutlet UIView *chejiaVline;


@end
