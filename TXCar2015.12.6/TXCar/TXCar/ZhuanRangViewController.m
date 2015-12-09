//
//  ZhuanRangViewController.m
//  TXCar
//
//  Created by jack on 15/9/17.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import "ZhuanRangViewController.h"
#import <BmobSDK/BmobUser.h>
#import "RKDropdownAlert.h"
#import "LoginViewController.h"
#import "WoDeViewController.h"

@interface ZhuanRangViewController ()<UITableViewDataSource,UITableViewDelegate,LoginToMyDelegate>
@property (weak, nonatomic) IBOutlet UITableView *lalala_tableview;
@property(nonatomic,assign)BOOL a;
@property(nonatomic,assign)BOOL b;
@property(nonatomic,assign)BOOL c;
@property(nonatomic,assign)BOOL d;
@end

@implementation ZhuanRangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lalala_tableview.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.automaticallyAdjustsScrollViewInsets=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if(_a){
        if(section==0){
            return 50;
        }
    }
    if(_b){
     if(section==1){
    return 50;
        }
    }
    if(_c){
        if(section==2){
            return 50;
        }
    }
    if(_d){
        if(section==3){
            return 50;
        }
    }
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
       if(_a){
    if (section == 0)
    {
        UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
        myView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0  blue: 248/255.0 alpha: 1];
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"我们承诺您的定金将得到最有力的保证.这里绝不会有微信或QQ拉黑、电话屏蔽现象."];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range4=[[hintString string]rangeOfString:@"我们承诺您的定金将得到最有力的保证.这里绝不会有微信或QQ拉黑、电话屏蔽现象."];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1.0] range:range4];
        NSRange range1=[[hintString string]rangeOfString:@"最有力"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:39/255.0 green:151/255.0 blue:1/255.0 alpha:1.0] range:range1];
        
        NSRange range2=[[hintString string]rangeOfString:@"拉黑"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:39/255.0 green:151/255.0 blue:1/255.0 alpha:1.0] range:range2];
        
        NSRange range3=[[hintString string]rangeOfString:@"屏蔽"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:39/255.0 green:151/255.0 blue:1/255.0 alpha:1.0] range:range3];
        
      
        
        UILabel * labell=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-20, 50)];
   //     labell.text=@"我们承诺您的定金将得到最有力的保证.这里绝不会有微信或QQ拉黑、电话屏蔽现象.";
        labell.attributedText=hintString;
     //   labell.textColor =[UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1.0];
        labell.numberOfLines = 0;
        labell.font = [UIFont systemFontOfSize:12];
        [myView addSubview:labell];
        return myView;
    }
       }
    if(_b){
    if (section == 1){
        UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
        myView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0  blue: 248/255.0 alpha: 1];
        UILabel * labell=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-20, 50)];
       
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"您的转车率和别人对您的评价越高,您的信誉越高."];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range4=[[hintString string]rangeOfString:@"您的转车率和别人对您的评价越高,您的信誉越高."];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1.0] range:range4];
        NSRange range1=[[hintString string]rangeOfString:@"找车率"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:39/255.0 green:151/255.0 blue:1/255.0 alpha:1.0] range:range1];
        
        NSRange range2=[[hintString string]rangeOfString:@"评价"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:39/255.0 green:151/255.0 blue:1/255.0 alpha:1.0] range:range2];
        labell.attributedText=hintString;
      
        labell.numberOfLines = 0;
        labell.font = [UIFont systemFontOfSize:12];
        [myView addSubview:labell];
        return myView;
    }
    }
    if(_c){
    if (section == 2){
        UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
        myView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0  blue: 248/255.0 alpha: 1];
        UILabel * labell=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-20, 50)];
    
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"这里有海量认证车源,包括全国各地域,辐射到乡镇级别."];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range1=[[hintString string]rangeOfString:@"这里有海量认证车源,包括全国各地域,辐射到乡镇级别."];

        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1.0] range:range1];
        
        NSRange range4=[[hintString string]rangeOfString:@"包括"];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:39/255.0 green:151/255.0 blue:1/255.0 alpha:1.0] range:range4];

        labell.attributedText=hintString;

        
        labell.numberOfLines = 0;
        labell.font = [UIFont systemFontOfSize:12];
        [myView addSubview:labell];
        return myView;
    }
    }
    if(_d){
        if (section == 3){
        UIView * myView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,60)];
        myView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0  blue: 248/255.0 alpha: 1];
        UILabel * labell=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-20, 50)];

        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"一键分享,分享到您的手机APP、微信、QQ,只需要一个按键操作."];
            NSRange range1=[[hintString string]rangeOfString:@"一键分享,分享到您的手机APP、微信、QQ,只需要一个按键操作."];
            
            [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:1.0] range:range1];
            NSRange range4=[[hintString string]rangeOfString:@"一个按键"];
            [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:39/255.0 green:151/255.0 blue:1/255.0 alpha:1.0] range:range4];
            
            labell.attributedText=hintString;
       
        labell.numberOfLines = 0;
        labell.font = [UIFont systemFontOfSize:12];
        [myView addSubview:labell];
        return myView;

    }
          
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"cell1";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIImageView * lll=(UIImageView*)[cell viewWithTag:1];

        if(!_a){
            
            lll.image=[UIImage imageNamed:@"zhuanrang_xiala"];
        }else{
            lll.image=[UIImage imageNamed:@"zhuanrang_dianji"];
            
        }

        return cell;
    }
    else if(indexPath.section == 1 && indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"cell2";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIImageView * lll=(UIImageView*)[cell viewWithTag:1];
        if(!_b){
            lll.image=[UIImage imageNamed:@"zhuanrang_xiala"];
        }else{
            lll.image=[UIImage imageNamed:@"zhuanrang_dianji"];
            
        }
        return cell;
    }
    else     if   (indexPath.section == 2 && indexPath.row == 0) {
        static NSString *CellIdentifier = @"cell3";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIImageView * lll=(UIImageView*)[cell viewWithTag:1];
        if(!_c){
            lll.image=[UIImage imageNamed:@"zhuanrang_xiala"];
        }else{
            lll.image=[UIImage imageNamed:@"zhuanrang_dianji"];
            
        }
        return cell;

       
        
    }
    else   {
        static NSString *CellIdentifier = @"cell4";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIImageView * lll=(UIImageView*)[cell viewWithTag:1];
        if(!_d){
            lll.image=[UIImage imageNamed:@"zhuanrang_xiala"];
        }else{
            lll.image=[UIImage imageNamed:@"zhuanrang_dianji"];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
    if (!_a) {
        _a=YES;
        [_lalala_tableview reloadData];
        return;
    }
  
    if (_a) {
        _a=NO;
        [_lalala_tableview reloadData];
        return;
    }
    }
    
    if(indexPath.section==1){
        if (!_b) {
            _b=YES;
            [_lalala_tableview reloadData];
            return;
        }
        
        if (_b) {
            _b=NO;
            [_lalala_tableview reloadData];
            return;
        }
    }
    
    if(indexPath.section==2){
        if (!_c) {
            _c=YES;
            [_lalala_tableview reloadData];
            return;
        }
        
        if (_c) {
            _c=NO;
            [_lalala_tableview reloadData];
            return;
        }
    }
    
    
    if(indexPath.section==3){
        if (!_d) {
            _d=YES;
            [_lalala_tableview reloadData];
            return;
        }
        
        if (_d) {
            _d=NO;
            [_lalala_tableview reloadData];
            return;
        }
    }

    
}


- (IBAction)dianjimaiche:(id)sender {
  
    if([BmobUser getCurrentUser]==nil){
        [RKDropdownAlert title:@"提示:请登陆后操作" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
        
        [self performSegueWithIdentifier:@"release_login_segue" sender:self];
        
    }else
    {

        
    [self   performSegueWithIdentifier:@"release_car_segue" sender: self];
        
    }
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual:@"release_login_segue"]){
        UINavigationController * navi=segue.destinationViewController;
        LoginViewController * view=navi.viewControllers[0];
        view.delegate=self;
//        WoDeViewController * myview= self.tabBarController.viewControllers.lastObject;
//        view.delegate=myview;
//        [view setValue:myview forKey:@"delegate"];
    }

}


@end
