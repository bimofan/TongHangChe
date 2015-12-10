//
//  AppDelegate.m
//  TXCar
//
//  Created by jack on 15/9/17.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import "AppDelegate.h"
#import <BmobSDK/Bmob.h>
#import <BmobIM/BmobIM.h>
#import <BmobIM/BmobChat.h>

#import <SMS_SDK/SMS_SDK.h>
#import "Header.h"
#import <AVFoundation/AVFoundation.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "BMapKit.h"

#import "CommonUtil.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"
#import "EAIntroView.h"
#import "YindaoyeViewController.h"
//新浪微博SDK头文件

#import "ChongZhiViewController.h"
#import "Pingpp.h"
#import "ReserveCar.h"
#import "MobClick.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobUser.h>
#import "sys/utsname.h"
#import "iPhone.h"
#import "Constants.h"

@interface AppDelegate ()<PassValueDelegate>

@end

@implementation AppDelegate
void UncaughtExceptionHandler(NSException *exception) {
    
    NSString* phoneVersion = [[UIDevice currentDevice] systemVersion];
    //  NSLog(@"手机系统版本: %@", phoneVersion);
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //  NSLog(@"当前应用软件版本:%@",appCurVersion);
    NSString* phoneVersion1=[iPhone deviceString];
    
    //  NSArray *arr= [exception callStackSymbols];//得到当前调用栈信息
    NSString*reason = [exception reason];//非常重要，就是崩溃的原因
    //  NSString*name = [exception name];//异常类型
    BmobObject  *gameScore = [BmobObject objectWithClassName:@"IOSExcepion"];
    [gameScore setObject:reason forKey:@"erroInfo"];
    [gameScore setObject:phoneVersion1 forKey:@"model"];
    [gameScore setObject:appCurVersion forKey:@"appVersion"];
    [gameScore setObject:phoneVersion forKey:@"version"];
    if ([BmobUser getCurrentUser]!=nil) {
        
    
    [gameScore setObject:[[BmobUser getCurrentUser]objectId] forKey:@"username"];
    }
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"objectid :%@",gameScore.objectId);
        } else if (error){
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
    // NSLog(@"exception type : %@ /n crash reason : %@ /n call stack info: %@", name, reason, arr);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MobClick setCrashReportEnabled:YES];
    
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
    //友盟统计
    [MobClick startWithAppkey:@"565e8fe567e58eea49000f64" reportPolicy:BATCH   channelId:@"App Store"];
    
    
    [BmobChat registerAppWithAppKey:@"f917e3ade256d7414210369bca613758"];
    // [Bmob registerWithAppKey:@"6547bf96972523d70d771f31d529222f"];
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >=8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
    }
    
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    }
    
    BmobUser *user = [BmobUser getCurrentUser];
    if (user) {
        BmobDB *db = [BmobDB currentDatabase];
        [db createDataBase];
    }else{
        
    }
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
    
    
    
    
    
    
    [SMS_SDK registerApp:@"7a6127387bcd" withSecret:@"141bf5abab3b60bca04b95951461f40e"];
    [ShareSDK registerApp:@"3df7a36158b2"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            ]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 
                 break;
                 
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx95f441be59f7752f"
                                       appSecret:@"01705020a55ba1ff2c959fb420ff71eb"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
                 
             default:
                 break;
         }
     }];
    
    
    
    //引导页
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]] ;
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        NSLog(@"第一次启动");
        //如果是第一次启动的话,使用UserGuideViewController (用户引导页面) 作为根视图
        YindaoyeViewController *ller = [[YindaoyeViewController alloc] init];
        self.window.rootViewController = ller;
    }
    else
    {
        UIStoryboard * story= [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController * vc = [story instantiateViewControllerWithIdentifier:@"TranslateController"];
        self.window.rootViewController = vc;
        
    }
    
    
    //先加载城市
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JiSuCity" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    
    _cityArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    

    
    
    return YES;
}


#ifdef __IPHONE_8_0

-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
    
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    
}
#endif


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *dToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    dToken = [dToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"STR:%@",dToken);
    
    
    if (dToken)
    {
        [BmobChat regisetDeviceWithDeviceToken:deviceToken];
        
        BmobUser *user = [BmobUser getCurrentUser];
        if (user)
        {
            
            //这句一定要，重新绑定，不然收不到消息
            [[BmobUserManager currentUserManager] checkAndBindDeviceToken:deviceToken];
            
            
            
        }
        
        
        [[NSUserDefaults standardUserDefaults ] setObject:deviceToken forKey:kDeviceTokenData];
        
        
        
        [[NSUserDefaults standardUserDefaults ] synchronize];
    }
    
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Registfail%@",error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    NSLog(@"userInfo is :%@",[userInfo description]);
    
    if ([userInfo objectForKey:@"tag"]) {
        
        if ([[[userInfo objectForKey:@"tag"] description] isEqualToString:@"add"]) {
            [self saveInviteMessageWithAddTag:userInfo];
            [BmobPush handlePush:userInfo];
        } else if ([[[userInfo objectForKey:@"tag"] description] isEqualToString:@"agree"]) {
            [self saveInviteMessageWithAgreeTag:userInfo];
        } else if ([[[userInfo objectForKey:@"tag"] description] isEqualToString:@""]) {
            [self saveMessageWith:userInfo];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DidRecieveUserMessage" object:userInfo];
            [[NSUserDefaults standardUserDefaults]setInteger:YES forKey:@"HadRecieveNewMessage"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
        // AudioServicesPlaySystemSound(1106);
    }
    else
    {
        NSDictionary *aps = [userInfo objectForKey:@"aps"];
        
        
        
        
        
        
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark save
-(void)saveInviteMessageWithAddTag:(NSDictionary *)userInfo{
    BmobInvitation *invitation = [[BmobInvitation alloc] init];
    invitation.avatar          = [[userInfo objectForKey:PUSH_ADD_FROM_AVATAR] description];
    invitation.fromId          = [[userInfo objectForKey:PUSH_ADD_FROM_ID] description];
    invitation.fromname        = [[userInfo objectForKey:PUSH_ADD_FROM_NAME] description];
    invitation.nick            = [[userInfo objectForKey:PUSH_ADD_FROM_NICK] description];
    invitation.time            = [[userInfo objectForKey:PUSH_ADD_FROM_TIME] integerValue];
    invitation.statue          = STATUS_ADD_NO_VALIDATION;
    [[BmobDB currentDatabase] saveInviteMessage:invitation];
}

-(void)saveInviteMessageWithAgreeTag:(NSDictionary *)userInfo{
    BmobInvitation *invitation = [[BmobInvitation alloc] init];
    invitation.avatar          = [[userInfo objectForKey:PUSH_ADD_FROM_AVATAR] description];
    invitation.fromId          = [[userInfo objectForKey:PUSH_ADD_FROM_ID] description];
    invitation.fromname        = [[userInfo objectForKey:PUSH_ADD_FROM_NAME] description];
    invitation.nick            = [[userInfo objectForKey:PUSH_ADD_FROM_NICK] description];
    invitation.time            = [[userInfo objectForKey:PUSH_ADD_FROM_TIME] integerValue];
    invitation.statue          = STATUS_ADD_AGREE;
    
    [[BmobDB currentDatabase] saveInviteMessage:invitation];
    [[BmobDB currentDatabase] saveContactWithMessage: invitation];
    
    //添加到用户的好友关系中
    BmobUser *user = [BmobUser getCurrentUser];
    if (user) {
        BmobUser *friendUser   = [BmobUser objectWithoutDatatWithClassName:@"User" objectId:invitation.fromId];
        BmobRelation *relation = [BmobRelation relation];
        [relation addObject:friendUser];
        [user addRelation:relation forKey:@"contacts"];
        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (error) {
                NSLog(@"\n error is :%@",[error description]);
            }
        }];
    }
    
}

//-(void)saveMessageWith:(NSDictionary *)userInfo{
//
//    BmobChatUser *user = [[BmobDB currentDatabase] queryUserWithUid:[[userInfo objectForKey:PUSH_KEY_TARGETID] description]];
//    BmobQuery *queryUser = [BmobQuery queryForUser];
//
//    [queryUser whereKey:@"objectId" equalTo:[userInfo objectForKey:PUSH_KEY_TARGETID]];
//
//    [queryUser findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//
//        if (!error && array.count > 0) {
//
//            BmobUser *fromUser = [array firstObject];
//
//            BmobChatUser *chatUser = [[BmobChatUser alloc]initFromBmobOjbect:fromUser];
//
//            chatUser.nick = [fromUser objectForKey:@"nick"];
//            chatUser.avatar = [fromUser objectForKey:@"avatar"];
//
//            NSString *content = [userInfo objectForKey:PUSH_KEY_CONTENT];
//            NSString *toid    = [[userInfo objectForKey:PUSH_KEY_TOID] description];
//            int type          = MessageTypeText;
//            if ([userInfo objectForKey:PUSH_KEY_MSGTYPE]) {
//                type = [[userInfo objectForKey:PUSH_KEY_MSGTYPE] intValue];
//            }
//
//
//            BmobMsg *msg      = [BmobMsg createReceiveWithUser:chatUser
//                                                       content:content
//                                                          toId:toid
//                                                          time:[[userInfo objectForKey:PUSH_KEY_MSGTIME] description]
//                                                          type:type status:STATUS_RECEIVER_SUCCESS];
//
//            [[BmobDB currentDatabase] saveMessage:msg];
//
//            //更新最新的消息
//            BmobRecent *recent = [BmobRecent recentObejectWithAvatarString:chatUser.avatar
//                                                                   message:msg.content
//                                                                      nick:chatUser.nick
//                                                                  targetId:msg.belongId
//                                                                      time:[msg.msgTime integerValue]
//                                                                      type:msg.msgType
//                                                                targetName:user.username];
//
//            [[BmobDB currentDatabase] performSelector:@selector(saveRecent:) withObject:recent afterDelay:0.3f];
//
//        }
//    }];
//
//
//
//}



-(void)saveMessageWith:(NSDictionary *)userInfo{
    
    __block  BmobChatUser *user = [[BmobDB currentDatabase] queryUserWithUid:[[userInfo objectForKey:PUSH_KEY_TARGETID] description]];
    
    BmobQuery *queryUser = [BmobQuery queryForUser];
    
    [queryUser whereKey:@"objectId" equalTo:[userInfo objectForKey:PUSH_KEY_TARGETID]];
    
    [queryUser findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error && array.count > 0) {
            
            BmobUser *fromUser = [array firstObject];
            
            user.nick = [fromUser objectForKey:@"nick"];
            user.username = fromUser.username;
            user.avatar = [fromUser objectForKey:@"avatar"];
            
            NSString *content = [userInfo objectForKey:PUSH_KEY_CONTENT];
            NSString *toid    = [[userInfo objectForKey:PUSH_KEY_TOID] description];
            int type          = MessageTypeText;
            if ([userInfo objectForKey:PUSH_KEY_MSGTYPE]) {
                type = [[userInfo objectForKey:PUSH_KEY_MSGTYPE] intValue];
            }
            
            
            BmobMsg *msg      = [BmobMsg createReceiveWithUser:user
                                                       content:content
                                                          toId:toid
                                                          time:[[userInfo objectForKey:PUSH_KEY_MSGTIME] description]
                                                          type:type status:STATUS_RECEIVER_SUCCESS];
            
            [[BmobDB currentDatabase] saveMessage:msg];
            
            //更新最新的消息
            BmobRecent *recent = [BmobRecent recentObejectWithAvatarString:user.avatar
                                                                   message:msg.content
                                                                      nick:user.nick
                                                                  targetId:msg.belongId
                                                                      time:[msg.msgTime integerValue]
                                                                      type:msg.msgType
                                                                targetName:user.username];
            
            
            
            [[BmobDB currentDatabase] saveRecent:recent];
            
            [self saveUnReadMsgTargetName:user.username];
            
        }
    }];
    
}

-(void)saveUnReadMsgTargetName:(NSString *)targetName
{
    NSArray *beforeArray = [[NSUserDefaults standardUserDefaults ] objectForKey:@"UnReadedMsgTargetName"];
    
    
    NSMutableArray *muArray  = [[NSMutableArray alloc]init];
    
    if (beforeArray) {
        
        [muArray addObjectsFromArray:beforeArray];
        
        
    }
    
    [muArray addObject:targetName];
    
    
    [[NSUserDefaults standardUserDefaults]setObject:muArray forKey:@"UnReadedMsgTargetName"];
    
    if ([[NSUserDefaults standardUserDefaults ] synchronize]) {
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"HadUnReadedMsg" object:nil];
        
        
    }
    
    
}


- (void) setValue:(NSString *) value{
    _qianqianqian=value;
}


- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url options:(NSDictionary *)options {
    if ([[[UIDevice currentDevice] systemVersion]floatValue]>=9){
        [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
            if ([result isEqualToString:@"success"]) {
                NSLog(@"祝福成功");
                
                
                NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:[[BmobUser getCurrentUser]username],@"username",[NSString stringWithFormat:@"%@",_qianqianqian],@"money", nil];
                
                [BmobCloud callFunctionInBackground:@"updateSalerMoney" withParameters:dic2 block:^(id object, NSError *error) {
                    if (error) {
                        NSLog(@"error--------- %@",[error description]);
                    }
                    NSLog(@"充值了这么多钱%@",_qianqianqian);
                    [self querendingdanmingxi];
                }] ;
                
            } else {
                // 支付失败或取消
                //            [SVProgressHUD showInfoWithStatus:@"充值失败"];
                //            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
                
                NSLog(@"%@",_qianqianqian);
                NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
            }
            
        }];
    }
    return YES;
    
}




- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"333333%@",url);
    
    [Pingpp handleOpenURL:url withCompletion:^(NSString *result, PingppError *error) {
        if ([result isEqualToString:@"success"]) {
            NSLog(@"祝福成功");
            
            
            NSDictionary *dic2=[NSDictionary dictionaryWithObjectsAndKeys:[[BmobUser getCurrentUser]username],@"username",[NSString stringWithFormat:@"%@",_qianqianqian],@"money", nil];
            
            [BmobCloud callFunctionInBackground:@"updateSalerMoney" withParameters:dic2 block:^(id object, NSError *error) {
                if (error) {
                    NSLog(@"error--------- %@",[error description]);
                }
                NSLog(@"充值了这么多钱%@",_qianqianqian);
                [self querendingdanmingxi];
            }] ;
            
        } else {
            // 支付失败或取消
            //            [SVProgressHUD showInfoWithStatus:@"充值失败"];
            //            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
            
            NSLog(@"%@",_qianqianqian);
            NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
        }
    }];
    return  YES;
}

-(void)querendingdanmingxi{
    
    
    BmobObject  *gameScore = [BmobObject objectWithClassName:@"AcountBean"];
    User *user = [User objectWithoutDatatWithClassName:@"User" objectId:[[BmobUser getCurrentUser]objectForKey:@"objectId"]];
    [gameScore setObject:user forKey:@"aUser"];
    [gameScore setObject:[[BmobUser getCurrentUser]objectId] forKey:@"userId"];
    
    [gameScore setObject:[NSNumber numberWithInt:[_qianqianqian intValue]] forKey:@"money"];
    [gameScore setObject:[NSNumber numberWithInt:FLAG_PAY] forKey:@"type"];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            NSLog(@"这一步更新明细表的~充值多少钱~");
            
        } else if (error){
            
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
