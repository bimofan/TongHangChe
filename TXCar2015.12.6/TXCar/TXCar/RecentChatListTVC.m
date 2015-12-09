//
//  RecentChatListTVC.m
//  QianShouBang
//
//  Created by ZhuHaikun on 15/8/18.
//  Copyright (c) 2015年 zhuhaikun. All rights reserved.
//

#import "RecentChatListTVC.h"
#import "RecentTableViewCell.h"
#import "ChatViewController.h"

@interface RecentChatListTVC ()
{
    NSMutableArray      *_chatsArray;
      
}
@end

@implementation RecentChatListTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"聊天消息";
    _chatsArray = [[NSMutableArray alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewMessage:) name:@"DidRecieveUserMessage" object:nil];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(hadUnReadedMsg) name:@"HadUnReadedMsg" object:nil];
    
    
    [self search];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
}
-(void)dealloc

{
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:@"HadUnReadedMsg" object:nil];
    
    [[NSNotificationCenter defaultCenter ] removeObserver:self name:@"DidRecieveUserMessage" object:nil];
}
-(void)search{
    
    NSArray *array = [[BmobDB currentDatabase] queryRecent];
    
    if (array) {
        
        [_chatsArray setArray:array];
        [self.tableView reloadData];
        
        
    }
}
#pragma mark - UITableView Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"count:%ld",(long)_chatsArray.count);
    
    return [_chatsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    
    RecentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[RecentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    
    BmobRecent *recent = (BmobRecent *)[_chatsArray objectAtIndex:indexPath.row];
    
    BOOL hadUnReaded = [self checkUnReadMsgWithTargetName:recent.targetName];
    
    if (hadUnReaded) {
        
        //显示红点
        cell.redDotImageView.hidden = NO;
    }
    else
    {
        // 隐藏红点
        
        cell.redDotImageView.hidden = YES;
        
    }
    
    
    if (recent.avatar) {
        
        
        NSString *headString = @"icon_user";
        
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:recent.avatar] placeholderImage:[UIImage imageNamed:headString]];
    }
    
    if (recent.targetName) {
        
        cell.nameLabel.text      = recent.targetName;
    }
    else
    {
        cell.nameLabel.text      = recent.targetId;
    }
    cell.messageLabel.text   = recent.message;
    //    cell.lineImageView.image = [UIImage imageNamed:@"common_line"];
    
    
    
    
    return cell;
}

#pragma mark - UITableView Delegate methods

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteChat:indexPath];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self chatWithSB:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)chatWithSB:(NSIndexPath *)indexPath{
    BmobRecent *recent = (BmobRecent *)[_chatsArray objectAtIndex:indexPath.row];
    
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    
    [infoDic setObject:recent.targetId forKey:@"uid"];
    [infoDic setObject:recent.targetName forKey:@"name"];
    
    if (recent.nick) {
        [infoDic setObject:recent.nick forKey:@"nick"];
    }
    
    if (recent.avatar) {
        [infoDic setObject:recent.avatar forKey:@"avatar"];
    }
    
    
    
    [self removeUnReaded:recent.targetName];
    
    
    
    ChatViewController *cvc = [[ChatViewController alloc] initWithUserDictionary:infoDic];
    cvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:cvc animated:YES];
    
}


-(void)deleteChat:(NSIndexPath *)indexPath{
    
    BmobRecent *recent = (BmobRecent *)[_chatsArray objectAtIndex:indexPath.row];
    
    [[BmobDB currentDatabase] deleteRecentWithUid:recent.targetId];
    
    [_chatsArray removeObject:recent];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    
}


//接收到消息
-(void)didReceiveNewMessage:(NSNotification *)noti{
    
    
    [self search];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)checkUnReadMsgWithTargetName:(NSString*)targetName
{
    
    NSArray *unReadedMsgArray = [[NSUserDefaults standardUserDefaults ] objectForKey:@"UnReadedMsgTargetName"];
    
    for (int i = 0 ; i < unReadedMsgArray.count; i++) {
        
        NSString *temTargetName = [unReadedMsgArray objectAtIndex:i];
        
        if ([temTargetName isEqualToString:targetName]) {
            
            return YES;
            
        }
        
    }
    
    return NO;
    
}

-(void)removeUnReaded:(NSString*)targetName
{
    NSArray *unReadedMsgArray = [[NSUserDefaults standardUserDefaults ] objectForKey:@"UnReadedMsgTargetName"];
    
    if (unReadedMsgArray ) {
        
        NSMutableArray *muArray = [[NSMutableArray alloc]initWithArray:unReadedMsgArray];
        
        for (int i = 0 ; i < muArray.count; i++) {
            
            NSString *temTargetName = [muArray objectAtIndex:i];
            
            if ([temTargetName isEqualToString:targetName]) {
                
                
                [muArray removeObject:temTargetName];
                
                
            }
            
        }
        
        [[NSUserDefaults standardUserDefaults ] setObject:muArray forKey:@"UnReadedMsgTargetName"];
        [[NSUserDefaults standardUserDefaults ] synchronize];
        
    }
    
    
    
}

-(void)hadUnReadedMsg
{
    [self.tableView reloadData];
    
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
