//
//  WXViewController.m
//  WFCoretext
//
//  Created by 阿虎 on 14/10/28.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#import "WXViewController.h"
#import "YMTableViewCell.h"
#import "ContantHead.h"
#import "YMShowImageView.h"
#import "YMTextData.h"
#import "YMReplyInputView.h"
#import "WFReplyBody.h"
#import "WFMessageBody.h"
#import "WFPopView.h"
#import "WFActionSheet.h"
#import <BmobSDK/Bmob.h>
#import "CarDetail.h"
#import "UIImageView+WebCache.h"
#import "Feed.h"
#import "User.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "SendWXViewController.h"
#import "MJRefresh.h"
#import "RKDropdownAlert.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#define dataCount 10
#define kLocationToBottom 20
//#define kAdmin @"小虎-tiger"


@interface WXViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate,UIActionSheetDelegate>
{
    NSMutableArray *_imageDataSource;
    
    NSMutableArray *_contentDataSource;//模拟接口给的数据
    
    NSMutableArray *_tableDataSource;//tableview数据源
    NSMutableArray *pinglunshuju;
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    NSMutableArray * ymDataArray  ;
    UITableView *mainTable;
    
    UIView *popView;
    
    YMReplyInputView *replyView ;
    
    NSInteger _replyIndex;
    
    NSString * kAdmin;
}

@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property (nonatomic,assign) int page;
@end

@implementation WXViewController


#pragma mark - 数据源
- (void)configData{
    
    
    _replyIndex = -1;//代表是直接评论
    
    
    BmobQuery *  bquery = [BmobQuery queryWithClassName:@"Feed"];
    bquery.limit = 5;
    [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:1]];
    [bquery orderByDescending:@"createdAt"];
    [bquery includeKey:@"author"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [_tableDataSource removeAllObjects];
        [_contentDataSource removeAllObjects];
        [_shuoshuoDatasSource removeAllObjects];
        NSLog(@"%@!!",array);
        for (BmobObject *obj in array) {
            CarDetail * model=[[CarDetail alloc]init];
            model.objectId=[obj objectId];
            WFMessageBody *messBody1 = [[WFMessageBody alloc] init];
            
            messBody1.plId=[obj objectId];
            
            messBody1.posterContent = [obj objectForKey:@"content"];
            messBody1.posterPostImage = [obj objectForKey:@"picList"];
            
            messBody1.user = [obj objectForKey:@"author"];
            
            NSString * iiiiiii=[messBody1.user objectForKey:@"avatar"];
            
            messBody1.posterImgstr=iiiiiii;
            
            
            messBody1.posterName = [messBody1.user objectForKey:@"contact"];
            
            NSArray * jkjkjk=@[];
            
            NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
            [formatter setLocale:[NSLocale currentLocale]];
            [formatter setDateFormat:@"MM-dd HH:mm"];
            messBody1.posterIntro =[formatter stringFromDate:[obj createdAt]];
            messBody1.posterFavour = [NSMutableArray arrayWithArray:jkjkjk];
            messBody1.isFavour = NO;
            NSLog(@"%@!!",messBody1);
            [_contentDataSource addObject:messBody1];
            [_shuoshuoDatasSource addObject:model];
        }
        
        
        [self jiazaipinglun];
        //        [self initTableview];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setupRefresh];
}

-(void)jiazaipinglun{
    
    int index = 0 ;
     NSLog(@"%lu",(unsigned long)_contentDataSource.count);
    for ( ;index < _contentDataSource.count; index ++) {
        WFMessageBody *messBody=[_contentDataSource objectAtIndex:index];
        //关联对象表
     
        BmobQuery *bquery = [BmobQuery queryWithClassName:@"Comment"];
        [bquery includeKey:@"user"];
        bquery.limit=10;
        //  [bquery orderByDescending:@"updatedAt"]
        [bquery orderByDescending:@"createdAt"];
        //需要查询的列
        BmobObject *comment = [BmobObject objectWithoutDatatWithClassName:@"Feed" objectId:messBody.plId];
        [bquery whereObjectKey:@"relation" relatedTo:comment];
        
        messBody.posterReplies=[[NSMutableArray alloc]init];
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            } else {
                pinglunshuju=[[NSMutableArray alloc]init];
                //    NSLog(@"!!!!!!!!!!!!%lu",(unsigned long)array.count);
                for (Comment *com in array) {
                    
                    WFReplyBody *body1 = [[WFReplyBody alloc] init];
                    body1.replyUser =[[com objectForKey:@"user"]objectForKey:@"contact"];
                    body1.replyInfo = [com objectForKey:@"commentContent"];
                    body1.repliedUser = @"";
                    [pinglunshuju addObject:body1];
                }
                messBody.posterReplies = [NSMutableArray arrayWithArray:pinglunshuju];
                NSLog(@"zheline ");
                if(index == _contentDataSource.count-1){
                     NSLog(@"zheline1 ");
                    [self loadTextData];
                }
               
             
            }
        }];
        
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableview];
    _tableDataSource = [[NSMutableArray alloc] init];
    _contentDataSource = [[NSMutableArray alloc] init];
    _shuoshuoDatasSource=[[NSMutableArray alloc] init];
    UIBarButtonItem *submit_btn = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(submit_clicked)];
    self.navigationItem.rightBarButtonItem =submit_btn;
    //    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //    backBtn.frame = CGRectMake(0, 20, self.view.frame.size.width, 44);
    //    [backBtn setTitle:[NSString stringWithFormat:@"我是返回,该登陆用户为%@",kAdmin] forState:UIControlStateNormal];
    //    backBtn.backgroundColor = [UIColor clearColor];
    //    [self.view addSubview:backBtn];
    //    [backBtn addTarget:self action:@selector(backToPre) forControlEvents:UIControlEventTouchUpInside];
    self.title=@"同行说";
    kAdmin=[[BmobUser getCurrentUser]objectForKey:@"contact"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
   
  //  [self configData];
    [mainTable addHeaderWithTarget:self action:@selector(headerBeginRefreshing)];
    [mainTable addFooterWithTarget:self action:@selector(footerRereshing)];
   // [self setupRefresh];
    //    [self initTableview];
    
    // [self loadTextData];
}

- (void)setupRefresh
{
    
    [mainTable headerBeginRefreshing];
}


-(void)headerBeginRefreshing{
    
    
    [self configData];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
     //   [mainTable reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [mainTable headerEndRefreshing];
    });
}

-(void)footerRereshing{
    
    BmobQuery *  bquery = [BmobQuery queryWithClassName:@"Feed"];
    [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:1]];
    NSLog(@"%d",_page);
    _page++;
    bquery.limit = 5;
    NSLog(@"%d",_page);
    bquery.skip = 5*_page;
    //  [bquery whereKey:@"flag" equalTo:[NSNumber numberWithInt:1]];
    [bquery orderByDescending:@"createdAt"];
    [bquery includeKey:@"author"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [_contentDataSource removeAllObjects];
     //   [_shuoshuoDatasSource removeAllObjects];
       
    NSLog(@"%lu",(unsigned long)array.count);
        for (BmobObject *obj in array) {
        
            CarDetail * model=[[CarDetail alloc]init];
            model.objectId=[obj objectId];
            WFMessageBody *messBody1 = [[WFMessageBody alloc] init];
            
            messBody1.plId=[obj objectId];
            
            messBody1.posterContent = [obj objectForKey:@"content"];
            messBody1.posterPostImage = [obj objectForKey:@"picList"];
            
            messBody1.user = [obj objectForKey:@"author"];
            
            NSString * iiiiiii=[messBody1.user objectForKey:@"avatar"];
            
            messBody1.posterImgstr=iiiiiii;
            
            
            messBody1.posterName = [messBody1.user objectForKey:@"contact"];
            
            NSArray * jkjkjk=@[];
            
            NSDateFormatter * formatter=[[NSDateFormatter alloc]init];
            [formatter setLocale:[NSLocale currentLocale]];
            [formatter setDateFormat:@"MM-dd HH:mm"];
            messBody1.posterIntro =[formatter stringFromDate:[obj createdAt]];
            messBody1.posterFavour = [NSMutableArray arrayWithArray:jkjkjk];
            messBody1.isFavour = NO;
            
            [_contentDataSource addObject:messBody1];
            [_shuoshuoDatasSource addObject:model];
     
        }
        
        if(array.count==0){
            [SVProgressHUD showInfoWithStatus:@"没有更多信息"];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            [mainTable footerEndRefreshing];
        }
        [self jiazaipinglun];
        //        [self initTableview];
    }];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        // 刷新表格
//        [mainTable reloadData];
//        
//        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
//        [mainTable footerEndRefreshing];
//    });
    
}







-(void)submit_clicked{
    if([BmobUser getCurrentUser]==nil){
        [RKDropdownAlert title:@"提示:请登陆后操作" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    
    
    SendWXViewController * bb=[[SendWXViewController alloc]init];
    [self.navigationController pushViewController:bb animated:YES];
}
#pragma mark -加载数据
- (void)loadTextData{
    NSLog(@"jinlaimeiyou1");
    ymDataArray =[[NSMutableArray alloc]init];
    [ymDataArray removeAllObjects];
    for (int i = 0 ; i < _contentDataSource.count; i ++) {
        
        WFMessageBody *messBody = [_contentDataSource objectAtIndex:i];
        
        YMTextData *ymData = [[YMTextData alloc] init ];
        ymData.messageBody = messBody;
        
        [ymDataArray addObject:ymData];
        
    }
    [self calculateHeight:ymDataArray];
    [mainTable reloadData];
    [mainTable footerEndRefreshing];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
       
          NSLog(@"!!!ymDataArray!!!!%lu",(unsigned long)ymDataArray.count);
    
//        [mainTable reloadData];
//         [mainTable footerEndRefreshing];
//      

        
    });
}



#pragma mark - 计算高度
- (void)calculateHeight:(NSMutableArray *)dataArray{
    NSLog(@"jinlaimeiyou ");
    
    NSDate* tmpStartData = [NSDate date];
    
    for (YMTextData *ymData in dataArray) {
        
        
        
        ymData.shuoshuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:NO];//折叠
        
        ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:YES];//展开
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        
        ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
        
        [_tableDataSource addObject:ymData];
        
    }
    
    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@"cost time = %f", deltaTime);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [mainTable reloadData];
        
    });
    
    
}




- (void)backToPre{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void) initTableview{
    
    CGFloat offset = 0;
    
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height-offset)];
    mainTable.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mainTable];
    
}

//**
// *  ///////////////////////////////////////////////////

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 5)];
    
    
    blankView.backgroundColor = [UIColor clearColor];
    
    return blankView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSLog(@"1333");
    return 5;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%lu",(unsigned long)_tableDataSource.count);
    return  _tableDataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YMTextData *ym = [_tableDataSource objectAtIndex:indexPath.section];
    BOOL unfold = ym.foldOrNot;
    //    return TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance + ym.favourHeight + (ym.favourHeight == 0?0:kReply_FavourDistance);
    //
    return TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance;
    
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ILTableViewCell";
    
    YMTableViewCell *cell = (YMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.stamp = indexPath.section;
    cell.replyBtn.appendIndexPath = indexPath;
    [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.section]];
    NSLog(@"111%@",[_tableDataSource objectAtIndex:indexPath.section]);
    
    return cell;
}

////////////////////////////////////////////////////////////////////

#pragma mark - 按钮动画

- (void)replyAction:(YMButton *)sender{
    
    CGRect rectInTableView = [mainTable rectForRowAtIndexPath:sender.appendIndexPath];
    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame), origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    _selectedIndexPath = sender.appendIndexPath;
    YMTextData *ym = [_tableDataSource objectAtIndex:_selectedIndexPath.section];
    [self.operationView showAtView:mainTable rect:targetRect isFavour:ym.hasFavour];
}



- (WFPopView *)operationView {
    if (!_operationView) {
        _operationView = [WFPopView initailzerWFOperationView];
        WS(ws);
        _operationView.didSelectedOperationCompletion = ^(WFOperationType operationType) {
            switch (operationType) {
                case WFOperationTypeLike:
                    
                    [ws share];
                    break;
                case WFOperationTypeReply:
                    [ws replyMessage: nil];
                    break;
                default:
                    break;
            }
        };
    }
    return _operationView;
}

#pragma mark  - 分享
-(void)share
{
    if([BmobUser getCurrentUser]==nil){
        [RKDropdownAlert title:@"提示:请登陆后操作" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
  //  NSLog(@"%@",[[_shuoshuoDatasSource objectAtIndex:_selectedIndexPath.section]objectId]);
    
    NSArray* imageArray = @[[UIImage imageNamed:@"60-60-0"]];
    // （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"来自同行车APP"
                                         images:imageArray
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.tongxingche.com/h5/pinglun.html?objectId=%@",[[_shuoshuoDatasSource objectAtIndex:_selectedIndexPath.section]objectId]]]
                                          title:@"同行车,与您一路同行"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:@[
                                         
                                         @(SSDKPlatformTypeWechat),
                                         @(SSDKPlatformTypeQQ),
                                         ]
         
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                       
                   }];
        
    }

    
    
    NSLog(@"分享");
    
}
#pragma mark - 赞
- (void)addLike{
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:_selectedIndexPath.section];
    WFMessageBody *m = ymData.messageBody;
    if (m.isFavour == YES) {//此时该取消赞
        [m.posterFavour removeObject:kAdmin];
        m.isFavour = NO;
    }else{
        [m.posterFavour addObject:kAdmin];
        m.isFavour = YES;
    }
    ymData.messageBody = m;
    
    
    //清空属性数组。否则会重复添加
    
    [ymData.attributedDataFavour removeAllObjects];
    
    
    ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:_selectedIndexPath.section withObject:ymData];
    
    [mainTable reloadData];
    
}


#pragma mark - 真の评论
- (void)replyMessage:(YMButton *)sender{
    if([BmobUser getCurrentUser]==nil){
        [RKDropdownAlert title:@"提示:请登陆后操作" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
        return;
    }

    if (replyView) {
        return;
    }
    replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
    replyView.delegate = self;
    replyView.replyTag = _selectedIndexPath.section;
    [self.view addSubview:replyView];
    
}

#pragma mark -移除评论按钮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.operationView dismiss];
    
}


#pragma mark -cellDelegate
- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger)cellStamp{
    
    [_tableDataSource replaceObjectAtIndex:cellStamp withObject:ymD];
    [mainTable reloadData];
    
}

#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
    
    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    maskview.backgroundColor = [UIColor blackColor];
    [self.view addSubview:maskview];
    
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:self.view.bounds byClick:clickTag appendArray:imageViews];
    [ymImageV show:maskview didFinish:^(){
        
        [UIView animateWithDuration:0.5f animations:^{
            
            ymImageV.alpha = 0.0f;
            maskview.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            [ymImageV removeFromSuperview];
            [maskview removeFromSuperview];
        }];
        
    }];
    
}

#pragma mark - 长按评论整块区域的回调
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    [self.operationView dismiss];
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = b.replyInfo;
    
}

#pragma mark - 点评论整块区域的回调
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    [self.operationView dismiss];
    
    _replyIndex = replyIndex;
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    if ([b.replyUser isEqualToString:kAdmin]) {
        WFActionSheet *actionSheet = [[WFActionSheet alloc] initWithTitle:@"删除评论？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.actionIndex = index;
        [actionSheet showInView:self.view];
        
        for (WFReplyBody *object in ymData.messageBody.posterReplies) {
            //        NSLog(@"__%@clickRichText",object.replyInfo);
            
        }
        
    }else{
        //回复
        if (replyView) {
            return;
        }
        replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
        replyView.delegate = self;
        
        replyView.lblPlaceholder.text = [NSString stringWithFormat:@"回复%@:",b.replyUser];
        replyView.replyTag = index;
        
        [self.view addSubview:replyView];
    }
}

#pragma mark - 评论说说回调
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag{
    
    YMTextData *ymData = nil;
    if (_replyIndex == -1) {
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = kAdmin;
        body.repliedUser = @"";
        body.replyInfo = replyText;
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
        
        BmobObject  *gameScore = [BmobObject objectWithClassName:@"Comment"];
        //score为1200
        [gameScore setObject:replyText forKey:@"commentContent"];
        User *user = [User objectWithoutDatatWithClassName:@"User" objectId:[[BmobUser getCurrentUser]objectId]];
        [gameScore setObject:user forKey:@"user"];
        [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                
                BmobObject *author = [BmobObject objectWithoutDatatWithClassName:@"Feed" objectId:[[_shuoshuoDatasSource objectAtIndex:_selectedIndexPath.section]objectId]];
                //新建relation对象
                BmobRelation *relation = [[BmobRelation alloc] init];
                [relation addObject:[BmobObject objectWithoutDatatWithClassName:@"Comment" objectId:gameScore.objectId]];
                //添加关联关系到postlist列中
                [author addRelation:relation forKey:@"relation"];
                
                //异步更新obj的数据
                [author updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"successful");
                    }else{
                        NSLog(@"error %@",[error description]);
                    }
                }];
                
                NSLog(@"objectid :%@",gameScore.objectId);
            } else if (error){
                //发生错误后的动作
                NSLog(@"%@",error);
            } else {
                NSLog(@"Unknow error");
            }
        }];
        
        
        
        
        
        
    }else{
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = kAdmin;
        body.repliedUser = [(WFReplyBody *)[m.posterReplies objectAtIndex:_replyIndex] replyUser];
        body.replyInfo = replyText;
        
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
        
    }
    
    
    
    //清空属性数组。否则会重复添加
    [ymData.completionReplySource removeAllObjects];
    [ymData.attributedDataReply removeAllObjects];
    
    
    ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:inputTag withObject:ymData];
    
    [mainTable reloadData];
    
}

- (void)destorySelf{
    
    //  NSLog(@"dealloc reply");
    [replyView removeFromSuperview];
    replyView = nil;
    _replyIndex = -1;
    
}

- (void)actionSheet:(WFActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //delete
        YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:actionSheet.actionIndex];
        WFMessageBody *m = ymData.messageBody;
        [m.posterReplies removeObjectAtIndex:_replyIndex];
        ymData.messageBody = m;
        [ymData.completionReplySource removeAllObjects];
        [ymData.attributedDataReply removeAllObjects];
        
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        [_tableDataSource replaceObjectAtIndex:actionSheet.actionIndex withObject:ymData];
        
        [mainTable reloadData];
        
    }else{
        
    }
    _replyIndex = -1;
}

- (void)dealloc{
    
    NSLog(@"销毁");
    
}

@end
