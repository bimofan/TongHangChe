//
//  shixinViewController.m
//  TXCar
//
//  Created by jack on 15/12/3.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "shixinViewController.h"
#import "shixindetailViewController.h"
#import "susongdetailViewController.h"
#import "MJRefresh.h"
#import "ShiXinModel.h"
#import "WeiGuiViewController.h"

@interface shixinViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSInteger pageIndex;
    
    NSMutableArray *_dataSource;
    
    
}


@property (weak, nonatomic) IBOutlet UIButton *shixin;
@property (weak, nonatomic) IBOutlet UIButton *susong;
@property (weak, nonatomic) IBOutlet UITableView *tab_tableviwe;
@property (weak, nonatomic) IBOutlet UIView *r2;
@property (weak, nonatomic) IBOutlet UIView *r1;
@property(nonatomic,assign)int a;

@end

@implementation shixinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  
    _dataSource = [[NSMutableArray alloc]init];
    


    [[[_searchBar.subviews objectAtIndex:0].subviews objectAtIndex:0]removeFromSuperview];
    _searchBar.delegate = self;
    
 
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    [refreshButton setTitle:@"搜索" forState: UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [refreshButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    
    refreshButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [refreshButton.layer setMasksToBounds:YES];
    [refreshButton.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
    
    refreshButton.backgroundColor=[UIColor colorWithRed:39/255.0 green:151/255.0 blue:1/255.0 alpha:1];
    [refreshButton addTarget:self action:@selector(next1) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    self.navigationItem.rightBarButtonItem = leftBarButtonItem;
   
    
    [_tab_tableviwe addFooterWithTarget:self action:@selector(footerRefresh)];
    
     [_searchBar becomeFirstResponder];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
   
    
    
}

-(void)footerRefresh
{
    pageIndex ++;
    
    [self getData];
    
}


#pragma mark -  搜索
-(void)next1{
    
    if (_searchBar.text.length == 0) {
        
        [[[UIAlertView alloc]initWithTitle:nil
    message:@"请输入查询信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show ];
       
        return;
        
    }
    
    
   [_searchBar resignFirstResponder];
    
    [self getData];
    
    
    
    

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, 0);
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:
(NSIndexPath *)indexPath {
    
    static NSString *SimpleTableIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    
    
    ShiXinModel *model  = [_dataSource objectAtIndex:indexPath.section];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UILabel * lable12=(UILabel*)[cell viewWithTag:1];
     
        UILabel * lable1=(UILabel*)[cell viewWithTag:2];

        UILabel * lable3=(UILabel*)[cell viewWithTag:3];
        
        UIImageView *image = (UIImageView*)[cell viewWithTag:4];
        
        UILabel *addressLabel = (UILabel*)[cell viewWithTag:5];
        
        
        
      
        NSString *dateStr = model.Liandate;
        

        
        if (dateStr.length > 10) {
            
            dateStr = [dateStr substringToIndex:10];
            
        }
        
        
        lable12.text = model.Name;
        lable1.text = model.Anno;
        lable3.text = dateStr;
        addressLabel.text = model.Province;
   
        
        if(model.type==2){
            [image setImage:[UIImage imageNamed:@"susong_biaoshi"]];
        }else{
            [image setImage:[UIImage imageNamed:@"shixin_biaoshi"]];
        }
        
        
        
    });

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
  
    ShiXinModel *model = [_dataSource objectAtIndex:indexPath.section];
    
    
    if(model.type==1){
    
    shixindetailViewController *oneC = [self.storyboard instantiateViewControllerWithIdentifier:@"shixindetail"];
    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
       
        oneC.model = model;
        
    [self.navigationController pushViewController:oneC animated:YES];
    }else{
        
    susongdetailViewController *oneC = [self.storyboard instantiateViewControllerWithIdentifier:@"susongdetail"];
        self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        oneC.model = model;
        
        [self.navigationController pushViewController:oneC animated:YES];

    }

}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if (searchBar.text.length == 0) {
        
        [[[UIAlertView alloc]initWithTitle:nil
                                   message:@"请输入查询信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show ];
        
        return;
    }
    
    [searchBar resignFirstResponder];
    
    [self getData];
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}


#pragma mark - 搜索结果
-(void)getData
{
    
    
     NSString *header = @"http://eci.yjapi.com/Court/SearchCourt";
    NSString *keyword = _searchBar.text;
    
    NSDictionary *param = @{@"province":@"",@"keyword":keyword,@"isExactlySame":@(NO),@"pageSize":@(10),@"pageIndex":@(pageIndex),@"key":kShiXinKey,@"dtype":@"json"};
    
    [RequestMethod requestWithURL:header params:param results:^(BOOL success, id results) {
       
        [_tab_tableviwe footerEndRefreshing];
        
        
        if (success) {
            
            NSInteger status = [[results objectForKey:@"Status"]integerValue];
            
            if (status == 200) {
                
                NSDictionary *Result = [results objectForKey:@"Result"];
                
                NSDictionary *ShiXinResult = [Result objectForKey:@"ShiXinResult"];
                
                NSArray *_shixinitems = [ShiXinResult objectForKey:@"Items"];
                
                NSMutableArray *_muShiXin = [[NSMutableArray alloc]init];
                
                for (int i = 0; i < _shixinitems.count ; i ++) {
                    
                    NSDictionary *_temDict = [_shixinitems objectAtIndex:i];
                    
                    ShiXinModel  *_model = [[ShiXinModel alloc]init];
                    
                    [_model setValuesForKeysWithDictionary:_temDict];
                    
                    _model.type = 1;
                    
                    [_muShiXin addObject:_model];
                    
                    
                    
                    
                }
                
                NSDictionary *ZhiXingResult = [Result objectForKey:@"ZhiXingResult"];
                
                NSArray *_zhixingItems = [ZhiXingResult objectForKey:@"Items"];
                
                NSMutableArray *_muzhixing = [[NSMutableArray alloc]init];
                for (int i = 0 ; i < _zhixingItems.count; i ++) {
                    
                    NSDictionary *dict = [_zhixingItems objectAtIndex:i];
                    
                    ShiXinModel  *_model = [[ShiXinModel alloc]init];
                    
                    [_model setValuesForKeysWithDictionary:dict];
                    
                    _model.type = 2;
                    
                    [_muzhixing addObject:_model];
                    
                    
                }
                
                
                
                [_dataSource addObjectsFromArray:_muShiXin];
                
                [_dataSource addObjectsFromArray:_muzhixing];
                
                [_tab_tableviwe reloadData];
                
                
            }
        }
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
