//
//  MingxiViewController.m
//  TXCar
//
//  Created by MacBooK Pro on 15/10/11.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "MingxiViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobUser.h>
#import "AcountBean.h"
#import "Header.h"
#import "MJRefresh.h"
#import "RKDropdownAlert.h"
@interface MingxiViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mingxi_tableview;
@property (nonatomic,copy)NSMutableArray * datasouse;
@property (nonatomic,assign) int page;
@end

@implementation MingxiViewController
{
    BmobQuery   *bquery;
    AcountBean * model;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _datasouse=[[NSMutableArray alloc]init];
    _mingxi_tableview.delegate=self;
    _mingxi_tableview.dataSource=self;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    [_mingxi_tableview addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
    [_mingxi_tableview addFooterWithTarget:self action:@selector(footerRereshing)];
    [self setupRefresh];
    
 
    
}



- (void)setupRefresh
{
    
    [_mingxi_tableview headerBeginRefreshing];
}

-(void)headerBeginRefreshing{
    

    bquery = [BmobQuery queryWithClassName:@"AcountBean"];
     bquery.limit = 10;
    [bquery orderByDescending:@"updatedAt"];
    [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
         [_datasouse removeAllObjects];
        for (BmobObject *obj in array) {
            AcountBean * carmodel=[[AcountBean alloc]init];;
            carmodel.money=[[obj objectForKey:@"money"]intValue];
            carmodel.type=[[obj objectForKey:@"type"]intValue];;
            
            carmodel.objectId=[obj objectId];
            carmodel.createdAt=[obj updatedAt];
            [_datasouse addObject:carmodel];
        }
        if(_datasouse.count==0){
            [RKDropdownAlert title:@"没有查询到数据" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
        }
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_mingxi_tableview reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_mingxi_tableview headerEndRefreshing];
    });
}

-(void)footerRereshing{
    bquery = [BmobQuery queryWithClassName:@"AcountBean"];
    _page++;
    bquery.limit = 10;
    bquery.skip = 10*_page;
    //查找CarDetail表的数据
    
   
    [bquery whereKey:@"userId" equalTo:[BmobUser getCurrentUser].objectId];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            //打印playerName
            AcountBean * carmodel=[[AcountBean alloc]init];;
            carmodel.money=[[obj objectForKey:@"money"]intValue];
            carmodel.type=[[obj objectForKey:@"type"]intValue];;
            
            carmodel.objectId=[obj objectId];
            carmodel.createdAt=[obj updatedAt];
   
            [_datasouse addObject:carmodel];
        }
        
    }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_mingxi_tableview reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_mingxi_tableview footerEndRefreshing];
    });
    
}







- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    
        return _datasouse.count;

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
   
        static NSString *CellIdentifier = @"setting_cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }


        model=[_datasouse objectAtIndex:indexPath.row];
        UILabel * label = (UILabel*)[cell viewWithTag:1];
        if( model.type == 1 )
        {
            label.text = @"充值";
        }
        
        if( (int)model.type == FLAG_GET  )
        {
            label.text = @"提现";
        }
        if((int)model.type == FLAG_ORDER_BACK_ALL  )
        {
            label.text = @"定金返还";
        }
        if( (int)model.type == FLAG_ORDER_BACK_MINUS  )
        {
            label.text = @"定金返还(已扣除200手续费)";
        }
        if((int)model.type == FLAG_BAOZHENGJIN_BACK_ALL  )
        {
            label.text = @"保证金退还";
        }
        if( (int)model.type == FLAG_BAOZHENGJIN_BACK_MINUS  )
        {
            label.text = @"保证金返还(已扣除200手续费)";
        }
        if( (int)model.type == FLAG_ORDER_AND_BAOZHENG )
        {
            label.text = @"买家定金和保证金(已扣除手400续费)";
        }
        if( (int)model.type == FLAG_ORDER_PAY_BAOZHENGJIN )
        {
        label.text = @"缴纳保证金";
        }
       if( (int)model.type == FLAG_ORDER_PAY_DINGJIN )
       {
         label.text = @"支付定金";
        }
    if( (int)model.type == FLAG_ORDER_PAY_CHADANG )
    {
        label.text = @"支付查档手续费";
    }
    if( (int)model.type == FLAG_ORDER_PAY_BAOZHANG )
    {
        label.text = @"支付信誉保证金";
    }

   
    
    NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"MM-dd hh:mm"];
    NSString * create_date=[formatter stringFromDate:model.createdAt];
    UILabel * label1 = (UILabel*)[cell viewWithTag:2];
    label1.text=create_date;
    
     UILabel * label2 = (UILabel*)[cell viewWithTag:3];
     NSString * ccc=[NSString stringWithFormat:@"%.f",model.money];
    if((model.type == 1) || ((int)model.type == FLAG_BAOZHENGJIN_BACK_ALL) ||((int)model.type == FLAG_ORDER_BACK_ALL)||((int)model.type == FLAG_ORDER_AND_BAOZHENG)||((int)model.type == FLAG_ORDER_BACK_MINUS)||(int)model.type == FLAG_BAOZHENGJIN_BACK_MINUS)
    {
        NSString * bbb=[NSString stringWithFormat:@"+%@",ccc];
        label2.text=bbb;
    }else{
    label2.text=ccc;
    }
    
        return cell;
    
    

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
 
        return 55;
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

        return 5;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
//    if(indexPath.section == 1 && indexPath.row == 0)
//    {
//        [self.delegate login_out:@"已注销"];
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }else if(indexPath.section == 0 && indexPath.row == 6){
//        [SVProgressHUD showErrorWithStatus:@"同行车与您一路同行"];
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
//    }else{
//        [SVProgressHUD showErrorWithStatus:@"功能未开放"];
//        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
//    }
    
    
}
- (IBAction)huiqv:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
