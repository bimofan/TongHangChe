//
//  RecentTableViewCell.m
//  BmobIMDemo
//
//  Created by Bmob on 14-6-28.
//  Copyright (c) 2014年 bmob. All rights reserved.
//

#import "RecentTableViewCell.h"
#import "CommonUtil.h"
#import "Header.h"
@implementation RecentTableViewCell

@synthesize avatarImageView = _avatarImageView;
@synthesize nameLabel       = _nameLabel;
@synthesize messageLabel    = _messageLabel;
@synthesize lineImageView   = _lineImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(UIImageView*)redDotImageView
{
    if (!_redDotImageView) {
        
        _redDotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - 50, self.frame.size.height/2 - 5, 10, 10)];
        
        _redDotImageView.backgroundColor = [UIColor redColor];
        _redDotImageView.clipsToBounds = YES;
        _redDotImageView.layer.cornerRadius = 5;
        
        [self addSubview:_redDotImageView];
        
    }
    
    return _redDotImageView;
    
}

-(UILabel*)nameLabel{
    if (!_nameLabel) {
        _nameLabel                 = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor       = RGB(60, 60, 60, 1.0f);
        _nameLabel.font            = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:_nameLabel];
    }
    
    return _nameLabel;
}

-(UIImageView*)lineImageView{
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240/255.0 blue:240/255.0 alpha:1];
        
        [self.contentView addSubview:_lineImageView];
    }
    
    return _lineImageView;
}


-(UIImageView*)avatarImageView{
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        [_avatarImageView.layer setMasksToBounds:YES];
        [_avatarImageView.layer setCornerRadius:10];
        [self.contentView addSubview:_avatarImageView];
    }
    
    return _avatarImageView;
}
-(UILabel*)messageLabel{
    if (!_messageLabel) {
        _messageLabel                 = [[UILabel alloc] init];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.font            = [CommonUtil setFontSize:13];
        _messageLabel.textAlignment   = NSTextAlignmentLeft;
        _messageLabel.textColor       = RGB(136, 136, 136, 1.0f);//[CommonUtil setColorByR:136 G:136 B:136];
        [self.contentView addSubview:_messageLabel];
    }
    return _messageLabel;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.nameLabel.frame       = CGRectMake(70, 8, 200, 22);
    self.lineImageView.frame   = CGRectMake(0, self.frame.size.height-1, ScreenWidth, 1);
    self.avatarImageView.frame = CGRectMake(20, 10, 30, 30);
    self.messageLabel.frame    = CGRectMake(70, 35, 200, 15);
    self.redDotImageView.frame = CGRectMake(self.frame.size.width - 50, self.frame.size.height/2 - 5, 10, 10);
    
}

@end
