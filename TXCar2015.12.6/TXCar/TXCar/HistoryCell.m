//
//  HistoryCell.m
//  TXCar
//
//  Created by ZhuHaikun on 15/12/10.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell

- (void)awakeFromNib {
    
    self.lsNumLabel.clipsToBounds = YES;
    self.lsNumLabel.layer.cornerRadius = 3.0;
    self.lsNumLabel.layer.borderColor = [UIColor colorWithRed:38/255.0 green:151/255.0 blue:1/255.0 alpha:1].CGColor;
    
    self.lsNumLabel.layer.borderWidth = 1;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
