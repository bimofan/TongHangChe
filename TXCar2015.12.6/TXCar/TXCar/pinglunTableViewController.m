//
//  pinglunTableViewController.m
//  TXCar
//
//  Created by jack on 15/10/30.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "pinglunTableViewController.h"
#import "UIImageView+WebCache.h"
#import "HCSStarRatingView.h"
#import "RKDropdownAlert.h"
#import "SVProgressHUD.h"
@interface pinglunTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nianxian;
@property (weak, nonatomic) IBOutlet UILabel *cheming;
@property (weak, nonatomic) IBOutlet UILabel *gonglishu;
@property (weak, nonatomic) IBOutlet UIImageView *tupian;
@property (weak, nonatomic) IBOutlet UILabel *jine;
@property (weak, nonatomic) IBOutlet UIImageView *zhuangtai;
@property (weak, nonatomic) IBOutlet UILabel *faburiqi;
@property (weak, nonatomic) IBOutlet UITextView *pinglun;
@property (nonatomic,copy)NSNumber *s1;
@property (nonatomic,copy)NSNumber *s2;
@property (nonatomic,copy)NSNumber *s3;

@end

@implementation pinglunTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _pinglun.layer.borderColor = UIColor.grayColor.CGColor;
    _pinglun.layer.borderWidth = 1;
    _pinglun.layer.cornerRadius = 6;
    _pinglun.layer.masksToBounds = YES;
   
    _cheming.text=[[_model11 objectForKey:@"sCar"]objectForKey:@"carInfo"];
    
    NSURL *URL = [NSURL URLWithString:[[_model11 objectForKey:@"sCar"]objectForKey:@"carPic"]];
    [_tupian sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"loading-image"]];
    
    NSString * bbb=[NSString stringWithFormat:@"%@",[[_model11 objectForKey:@"sCar"]objectForKey:@"carDistance"]];
    NSString * bbbb=[bbb stringByAppendingString:@"万公里 /"];
    _gonglishu.text=bbbb;
    
    NSString * create_date=[NSString stringWithFormat:@"%@", [[_model11 objectForKey:@"sCar"] createdAt]];
    NSString * create_date1=[create_date substringWithRange:NSMakeRange(5, 5)];
    
    NSString * aaaa=[create_date1 stringByAppendingString:[[_model11 objectForKey:@"sCar"]objectForKey:@"carLocation"]];
    _faburiqi.text=aaaa;
    
    NSString * ccc=[NSString stringWithFormat:@"%@",[[_model11 objectForKey:@"sCar"]objectForKey:@"carPrice" ]];
    NSString * cccc=[ccc stringByAppendingString:@"万元"];
    _jine.text=cccc;
    
    NSString * ns=[[[_model11 objectForKey:@"sCar"]objectForKey:@"carYearCheck"] substringToIndex:4];
    _nianxian.text=ns;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }else
        return 1;
}



- (IBAction)p1:(HCSStarRatingView *)sender {
    
    if(sender.tag==11){
        _s1=[NSNumber numberWithFloat:sender.value];
    }
    if(sender.tag==22){
        _s2=[NSNumber numberWithFloat:sender.value];
        
    }
    if(sender.tag==33){
        _s3=[NSNumber numberWithFloat:sender.value];
    }
}



- (IBAction)tijiao:(UIButton *)sender {
    
    if (_s1==nil) {
        [RKDropdownAlert title:@"提示: 请对卖家打分" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }else if(_s2==nil) {
        [RKDropdownAlert title:@"提示: 请对相符程度打分" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }else if(_s3==nil) {
        [RKDropdownAlert title:@"提示: 请对服务态度打分" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    
    
    [SVProgressHUD showWithStatus:@"正在提交"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    BmobObject  *gameScore = [BmobObject objectWithClassName:@"OrderComment"];
    
    [gameScore setObject:_s2 forKey:@"desRate"];
    [gameScore setObject:_s1 forKey:@"mainRate"];
    [gameScore setObject:_s3 forKey:@"serveRate"];
    if([_pinglun.text isEqualToString:@"评论内容( 选填 )"]){
        [gameScore setObject:@"" forKey:@"comment"];
    }else{
    [gameScore setObject:_pinglun.text forKey:@"comment"];
    }
    [gameScore setObject:@"IOS" forKey:@"from"];
     User *user1 = [User objectWithoutDatatWithClassName:@"User" objectId:[[_model11 objectForKey:@"sUser"]objectId]];
    [gameScore setObject:user1 forKey:@"tUser"];
    
    [gameScore setObject:[[_model11 objectForKey:@"sUser"]objectId] forKey:@"tUserId"];
    
    [gameScore setObject:[[_model11 objectForKey:@"sCar"] objectId] forKey:@"carId"];
    
    [gameScore setObject:[_model11 objectId] forKey:@"orderId"];
    User *user = [User objectWithoutDatatWithClassName:@"User" objectId:[[_model11 objectForKey:@"carUser"]objectId]];
    [gameScore setObject:user forKey:@"cUser"];
    [gameScore setObject:[[_model11 objectForKey:@"carUser"]objectId] forKey:@"cUserId"];
    [gameScore setObject:user forKey:@"cUser"];
    
    [gameScore setObject:_model11 forKey:@"reserveOrder"];
    
    //异步保存
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:[[_model11 objectForKey:@"carUser"]objectForKey:@"username"],@"username",@"1",@"commentNum",_s1,@"rateMain",_s2,@"rateDes",_s3,@"rateServe",nil];
            
            [BmobCloud callFunctionInBackground:@"updateSalerRate" withParameters:dic2 block:^(id object, NSError *error) {
                if (!error) {
                    
                    BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"ReserveCar"  objectId:[_model11 objectId]];
                    [bmobObject setObject:[gameScore objectId] forKey:@"commentId"];
                    [bmobObject updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            [SVProgressHUD dismiss];
                            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                            [self.navigationController popViewControllerAnimated:YES];
                        } else if (error){
                            [SVProgressHUD dismiss];
                            [SVProgressHUD showSuccessWithStatus:@"评论失败"];
                            NSLog(@"%@",error);
                        } else {
                            [SVProgressHUD dismiss];
                            [SVProgressHUD showSuccessWithStatus:@"评论失败"];
                            NSLog(@"UnKnow error");
                        }
                    }];
                    
                    
                    
                    
                    
                    
                    
                    //                    [_model11 setObject:[gameScore objectId] forKey:@"commentId"];
                    //                    [_model11 updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    //                         [SVProgressHUD dismiss];
                    //                         [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                    //                        [self.navigationController popViewControllerAnimated:YES];
                    //
                    //                    }];
                }
                
            }] ;
            
        } else if (error){
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"评论失败"];
            //发生错误后的动作
            NSLog(@"错了%@",error);
        } else {
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"评论失败"];
            NSLog(@"Unknow error");
        }
    }];
    
    
    
}


@end
