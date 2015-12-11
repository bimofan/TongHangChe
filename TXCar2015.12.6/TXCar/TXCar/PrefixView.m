//
//  PrefixView.m
//  TXCar
//
//  Created by ZhuHaikun on 15/12/11.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "PrefixView.h"

@implementation PrefixView

-(id)initWithFrame:(CGRect)frame
{
    
    if (self == [super initWithFrame:frame]) {
        
        UIControl *control = [[UIControl alloc]initWithFrame:frame];
        
        [control addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        control.backgroundColor = [UIColor clearColor];
        
        [self addSubview:control];
        
        CGFloat screenwith = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        
        CGFloat with = 60 + 30*8 + 5*7;
        CGFloat height = 200;
        
        whiteView = [[UIView alloc]initWithFrame: CGRectMake(screenwith/2 - with/2, screenHeight - height - 20, with, height)];
        whiteView.backgroundColor = [UIColor whiteColor];
        
        
        [self addSubview:whiteView];
        
        
        
        [self addButtons];
        
        
        
        
        
        
    }
    
    return self;
    
}

-(void)dismiss
{
    [self removeFromSuperview];
    
}
-(void)addButtons
{
    AppDelegate *_appdelegate = [UIApplication sharedApplication].delegate;
    
    _dataSource = _appdelegate.cityArray;
    
    
    for (int i = 0 ; i < _dataSource.count; i ++) {
        
        NSDictionary *oneProvince = [_dataSource objectAtIndex:i];
        
        NSString *prefix = [oneProvince objectForKey:@"lsprefix"];
        
        
        NSInteger line = i/8;
        NSInteger num = i%8;
        
        UIButton *oneButton = [[UIButton alloc]initWithFrame:CGRectMake(30 + 35*num, line * 35 + 20, 30, 30)];
        
        [oneButton setTitle:prefix forState:UIControlStateNormal];
        
        [oneButton setTitleColor:[UIColor colorWithRed:38/255.0 green:151/255.0 blue:1/255.0 alpha:1] forState:UIControlStateNormal];
        
        
        oneButton.clipsToBounds = YES;
        oneButton.layer.cornerRadius = 2;
        oneButton.layer.borderColor =[UIColor colorWithRed:38/255.0 green:151/255.0 blue:1/255.0 alpha:1].CGColor;
        oneButton.layer.borderWidth = 1;
        
        oneButton.tag = i;
        
        [oneButton addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [whiteView addSubview:oneButton];
    }
}

-(void)selectedButton:(UIButton*)sender
{
 
    
    
    if ([self.delegate respondsToSelector:@selector(didSelectedPrefix:)]) {
        
        [self.delegate didSelectedPrefix:sender.titleLabel.text];
        
        
    }
    
    
    
    [self dismiss];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
