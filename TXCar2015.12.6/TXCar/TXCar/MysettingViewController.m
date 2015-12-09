//
//  MysettingViewController.m
//  TXCar
//
//  Created by jack on 15/9/23.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import "MysettingViewController.h"
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobProFile.h>
#import <BmobSDK/BmobFile.h>
#import "SVProgressHUD.h"
#import "RKDropdownAlert.h"
#import "User.h"
#import "gerenxinxiTableViewController.h"
#import "BaoZhengJinTableViewController.h"
#import "UIImageView+WebCache.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>
@interface MysettingViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,baozhengjinDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *touxiang;
@property (weak, nonatomic) IBOutlet UITextField *wodenicheng;
@property (weak, nonatomic) IBOutlet UITextField *gexingqianming;
@property (weak, nonatomic) IBOutlet UILabel *lianxirendianhua;
@property (weak, nonatomic) IBOutlet UITextField *lianxiren;
@property (weak, nonatomic) IBOutlet UIImageView *aaaa;
@property (weak, nonatomic) IBOutlet UILabel *bbbb;

@property(nonatomic, strong) NSData *fileData;

@property(nonatomic,copy)NSString *car_user_id;
@end

@implementation MysettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 10,15)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"navbar_return_normal.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(dismiss2) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  
    _lianxiren.delegate=self;
    _wodenicheng.delegate=self;
    _gexingqianming.delegate=self;
    _touxiang.layer.masksToBounds=YES;
    _wodenicheng.borderStyle=UITextBorderStyleNone;
    _gexingqianming.borderStyle=UITextBorderStyleNone;
    _lianxiren.borderStyle=UITextBorderStyleNone;
    _wodenicheng.returnKeyType=UIReturnKeyDone;
    _gexingqianming.returnKeyType=UIReturnKeyDone;
    _lianxiren.returnKeyType=UIReturnKeyDone;
    
    
    NSString * userid=[[BmobUser getCurrentUser]objectId];
    BmobQuery *query = [BmobUser query];
    [query whereKey:@"objectId" equalTo:userid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobUser *user in array) {
            if([[user objectForKey:@"hasPayFund"]intValue]==1){
                _aaaa.image=[UIImage imageNamed:@"shouye_baozhang"];
                _bbbb.text=@"已缴纳保证金";
                _bbbb.textColor=[UIColor colorWithRed:39/255.0 green:151/255.0 blue:1/255.0 alpha:1];
                
            }
           }
          }];

    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    singleTap.numberOfTapsRequired=1;
    _touxiang.userInteractionEnabled = YES;
    [_touxiang addGestureRecognizer:singleTap];
    
    NSString * imageuser=[[BmobUser getCurrentUser]objectForKey:@"avatar"];
        NSURL *URL = [NSURL URLWithString:imageuser];
    [_touxiang sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"gerenshezhi_touxiang"]];
    
        _car_user_id=[[BmobUser getCurrentUser]objectId];
    _lianxirendianhua.text=[[BmobUser getCurrentUser]objectForKey:@"username"];
    
    if ([[BmobUser getCurrentUser]objectForKey:@"nick"]!=nil) {
        _wodenicheng.placeholder=[[BmobUser getCurrentUser]objectForKey:@"nick"];
    }else{
        _wodenicheng.placeholder=@"请输入昵称";
    }
    
    if ([[BmobUser getCurrentUser]objectForKey:@"contact"]!=nil) {
        _lianxiren.placeholder=[[BmobUser getCurrentUser]objectForKey:@"contact"];
    }else{
        _lianxiren.placeholder=@"请输入联系人姓名";
    }
    
    if ([[BmobUser getCurrentUser]objectForKey:@"sign"]!=nil) {
        _gexingqianming.placeholder=[[BmobUser getCurrentUser]objectForKey:@"sign"];
    }else{
        _gexingqianming.placeholder=@"请输入个性签名,让别人更了解你";
    }
    
}

-(void)change:(NSString *)aaa{
    _aaaa.image=[UIImage imageNamed:@"shouye_baozhang"];
    _bbbb.text=@"已缴纳保证金";
    _bbbb.textColor=[UIColor colorWithRed:39/255.0 green:151/255.0 blue:1/255.0 alpha:1];
}

- (IBAction)asdas:(UIButton *)sender {
    BaoZhengJinTableViewController * dertail=[self.storyboard instantiateViewControllerWithIdentifier:@"baobao"];
    dertail.delegate=self;
     [self.navigationController pushViewController:dertail animated:YES];
}


-(void)handleSingleTap{
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择文件来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机",@"本地相册",nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0://照相机
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
       
        case 1://本地相簿
        {
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //            [self presentModalViewController:imagePicker animated:YES];
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
            break;
     
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    //    NSLog(@"保存头像！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.png"];
   // NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
        UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
 //   UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    //    [userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
    _touxiang.image = selfPhoto;
    
    
    
//    NSBundle    *bundle = [NSBundle mainBundle];
//    NSString *fileString = [NSString stringWithFormat:@"%@/cs.txt" ,[bundle bundlePath]];
//    BmobObject *obj = [[BmobObject alloc] initWithClassName:@"GameScore"];
    BmobFile *file1 = [[BmobFile alloc] initWithFilePath:imageFilePath];
    [file1 saveInBackground:^(BOOL isSuccessful, NSError *error) {
        //如果文件保存成功，则把文件添加到filetype列
        if (isSuccessful) {
            BmobUser *bUser = [BmobUser getCurrentUser];
 
            [bUser setObject:file1.url forKey:@"avatar"];
            [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
             
            }];
            NSLog(@"file1 url %@",file1.url);
        }else{
        }
    }];
    
    
    
    
    
    
    
    
    
    
    

//    [BmobProFile uploadFileWithPath:imageFilePath block:^(BOOL isSuccessful, NSError *error, NSString *filename, NSString *url,BmobFile *bmobFile) {
//        if (isSuccessful) {
//            NSLog(@"%d",isSuccessful);
//            //上传成功后返回文件名及url
//            BmobUser *bUser = [BmobUser getCurrentUser];
//            //更新number为30
//            [bUser setObject:url forKey:@"avatar"];
//            [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                NSLog(@"____________error %@",[error description]);
//            }];
//            NSLog(@"filename111:%@",filename);
//            NSLog(@"url1111:%@",url);
//            NSLog(@"bmobFile1111:%@\n",bmobFile);
//        } else{
//            if(error){
//                NSLog(@"error%@",error);
//            }
//        }
//    } progress:^(CGFloat progress) {
//        //上传进度，此处可编写进度条逻辑
//        NSLog(@"progress %f",progress);
//    }];
}

- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == _wodenicheng) {
        [_wodenicheng resignFirstResponder];
        [self update2];
    return YES;
    }else if (textField == _gexingqianming){
        [_gexingqianming resignFirstResponder];
        [self update1];
        return YES;
    }else{
        [_lianxiren resignFirstResponder];
        [self update];
        return YES;
    }
}

-(void)update{
    BmobUser * bUser=[BmobUser getCurrentUser];
    [bUser setObject:_lianxiren.text forKey:@"contact"];
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"修改联系人姓名成功");
    }];
}
-(void)update1{
    BmobUser * bUser=[BmobUser getCurrentUser];
    [bUser setObject:_gexingqianming.text forKey:@"sign"];
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"修改个性签名成功");
    }];
    
}
-(void)update2{
    BmobUser * bUser=[BmobUser getCurrentUser];
    [bUser setObject:_wodenicheng.text forKey:@"nick"];
    [bUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        NSLog(@"修改昵称成功");
    }];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_lianxiren resignFirstResponder];
    [_gexingqianming resignFirstResponder];
    [_wodenicheng resignFirstResponder];

}
- (IBAction)wodezhanghu:(UIButton *)sender {
    [self performSegueWithIdentifier:@"wodezhanghu2" sender:self];
}

- (IBAction)wodezhuye:(UIButton *)sender {
    [self performSegueWithIdentifier:@"wodezhuye" sender:self];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqual:@"wodezhuye"]){
        gerenxinxiTableViewController * view=segue.destinationViewController;
                view.tagg=1;
       
    }
}




-(void)dismiss2{
    NSLog(@"111");
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
