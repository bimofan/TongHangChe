//
//  SendWXViewController.m
//  TXCar
//
//  Created by ZhuHaikun on 15/11/6.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "SendWXViewController.h"
#import "RSKImageCropViewController.h"
#import "UzysAssetsPickerController.h"
#import "EditPhotoViewController.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobProFile.h>
#import "WXViewController.h"
#import "SVProgressHUD.h"
@interface SendWXViewController ()<UITextViewDelegate,EditPhotoViewDelegate,RSKImageCropViewControllerDelegate,UIActionSheetDelegate,UzysAssetsPickerControllerDelegate>
{
    NSMutableArray *_image_list;
    NSMutableArray *_image_list1;
     NSMutableArray *_image_list2;
    NSInteger _select_imageview_index;
    
    UIImage *addImage;
    
    UITapGestureRecognizer *_tapGesture;
    
}
@end

@implementation SendWXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布";
    
    UIBarButtonItem *submit_btn = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submit_clicked)];
    self.navigationItem.rightBarButtonItem =submit_btn;
    _image_list = [[NSMutableArray alloc]init];
     _image_list1 = [[NSMutableArray alloc]init];
     _image_list2 = [[NSMutableArray alloc]init];
    addImage  = [UIImage imageNamed:@"tianjiazhaopian"];
    
    [_image_list addObject:addImage];
    
    _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resign)];
    
    
     [self reloadPhotoViews];
    
}

-(void)submit_clicked{
    [SVProgressHUD showWithStatus:@"正在发布"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    BmobObject  *gameScore = [BmobObject objectWithClassName:@"Feed"];
    [gameScore setObject:[NSNumber numberWithInt:0] forKey:@"love"];
    [gameScore setObject:[NSNumber numberWithInt:1] forKey:@"flag"];
    [gameScore setObject:_inputTextView.text forKey:@"content"];
    [gameScore setObject:@"IOS" forKey:@"from"];
    BmobUser *author = [BmobUser objectWithoutDatatWithClassName:@"_User" objectId:[[BmobUser getCurrentUser] objectId]];
    [gameScore setObject:author forKey:@"author"];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            BmobObject *post = [BmobObject objectWithoutDatatWithClassName:@"Feed" objectId:gameScore.objectId];

            BmobRelation *relation = [[BmobRelation alloc] init];
   
            [post addRelation:relation forKey:@"relation"];
            
            [post updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"%lu",(unsigned long)_image_list.count);
                    if(_image_list.count>1){
                    [self saveima:gameScore.objectId];
                    }else{
                        [SVProgressHUD dismiss];
                        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                 NSLog(@"successful");
                }else{
                    NSLog(@"error %@",[error description]);
                }
            }];
        } else if (error){
            
            NSLog(@"%@",error);
        } else {
            NSLog(@"Unknow error");
        }
    }];
    
    
    
}

-(void)saveima:(NSString*)sender{
    
    BmobObject *gameScore = [BmobObject objectWithoutDatatWithClassName:@"Feed" objectId:sender];
    NSMutableArray *datasArray = [[NSMutableArray alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *string = [formatter stringFromDate:[NSDate date]];
    for (int i = 0 ; i < _image_list.count -1; i ++) {
        UIImage *image = _image_list[i];
        NSData *imageData =UIImageJPEGRepresentation(image, 0.5);
        NSString *fileName = [NSString stringWithFormat:@"%@%d.jpg",string,i];
        NSDictionary *onefile = @{@"filename":fileName,@"data":imageData};
        [datasArray addObject:onefile];
    }
    [BmobProFile uploadFilesWithDatas:datasArray resultBlock:^(NSArray *filenameArray, NSArray *urlArray, NSArray *bmobFileArray, NSError *error) {
        if (!error) {
            NSLog(@"%@2323",_image_list1);
            [_image_list1 addObjectsFromArray: urlArray];
            NSLog(@"%@45454",_image_list1);
            for(int i=0;i<_image_list1.count;i++){
                NSString *yyyy=@"?t=1&a=a52116a3990792c133814c1b0702a2aa";
                NSString *yyy= [NSString stringWithFormat:@"%@%@",_image_list1[i],yyyy];
                [_image_list2 addObject:yyy];
                NSLog(@"%@7878",_image_list2);
            }
            [gameScore addObjectsFromArray:_image_list2 forKey:@"picList"];
            [gameScore updateInBackground];
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
             [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            NSLog(@"error:%@",error);
            
        }
    } progress:^(NSUInteger index, CGFloat progress) {
        
       // NSLog(@"index:%ld,progress:%f",(long)index,progress);
        
    }];

}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   
}

-(void)resign
{
    [self.view endEditing:YES];
    
    
    [self.view removeGestureRecognizer:_tapGesture];
    
}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    _sayLabel.hidden = YES;
    
    [self.view addGestureRecognizer:_tapGesture];
    
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        
        _sayLabel.hidden = NO;
        
        
    }
    else
    {
        _sayLabel.hidden = YES;
        
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        
        _sayLabel.hidden = NO;
        
        
    }
    
}





- (IBAction)photoButtonAction:(id)sender {
    
    
    [self resign];
    
    
    UIButton *sendButton = (UIButton*)sender;
    
    if (sendButton.tag==_image_list.count && _image_list.count < 9) {
        
        if (_image_list.count < 9) {
            
            UzysAssetsPickerController * picker=[[UzysAssetsPickerController alloc]init];
            picker.delegate=self;
            picker.maximumNumberOfSelectionPhoto= 9 - _image_list.count; //还有多一张加号图片
            
            picker.assetsFilter = [ALAssetsFilter allPhotos];
            
            [self presentViewController:picker animated:YES  completion:nil];
        }
        else
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能选择8张图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }else{
        // NSLog(@"%ld",sender.view.tag+1);
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        [actionSheet addButtonWithTitle:@"拖动、缩放或者旋转图片"];
        [actionSheet addButtonWithTitle:@"马赛克"];
        [actionSheet addButtonWithTitle:@"删除"];
        
        [actionSheet addButtonWithTitle:@"取消"];
        
        actionSheet.cancelButtonIndex = 3;
        actionSheet.tag = sendButton.tag ;
        
        [actionSheet showInView:self.view];
        
        _select_imageview_index=sendButton.tag -1 ;
        
        
    }
}


#pragma mark -UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSInteger imageTag = actionSheet.tag -1;
    
    if (buttonIndex == 0) {
        
        RSKImageCropViewController * image_crop_vc=[[RSKImageCropViewController alloc]initWithImage:_image_list[imageTag]];
        image_crop_vc.delegate=self;
        image_crop_vc.rotationEnabled=YES;
        image_crop_vc.cropMode=RSKImageCropModeSquare;
        image_crop_vc.moveAndScaleLabel.text=@"拖动、缩放或者旋转图片";
        [self presentViewController:image_crop_vc animated:YES completion:nil];
    }
    else if (buttonIndex == 1)
    {
        EditPhotoViewController *_editrVC = [[EditPhotoViewController alloc]init];
        _editrVC.delegate = self;
        
        _editrVC.sourseImg = _image_list[imageTag];
        
        [self presentViewController:_editrVC animated:YES completion:nil];
        
        
        
    }
    else if (buttonIndex == 2)
    {
        
        
        [_image_list removeObjectAtIndex:imageTag];
        
        [self reloadPhotoViews];
        
        
    }
}




- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
//    [RKDropdownAlert title:@"提示 : 选择第一张图片进行编辑" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
//    NSLog(@"可能出错3");
    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"])
    {
        if (assets.count > 0) {
            
            
            //先删掉加号 那张图片
            
            [_image_list removeObjectAtIndex:_image_list.count -1];
            
            for (ALAsset * item in assets) {
                ALAsset * representation = item;
                UIImage * image=[UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                                    scale:representation.defaultRepresentation.scale
                                              orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
                
                //添加图片
                [_image_list addObject:image];
            }
            
            
            //再把加号 放进去
            if (_image_list.count < 9) {
                
                [_image_list addObject:addImage];
                
            }
            
            
            [self reloadPhotoViews];
            
            
         }
        
        
    }
}

- (void)uzysAssetsPickerControllerDidCancel:(UzysAssetsPickerController *)picker
{
     [self reloadPhotoViews];
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能选择8张图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}



#pragma mark - EditPhotoViewDelegate
-(void)doneEditePhoto:(UIImage *)photo
{
    _image_list[_select_imageview_index]=photo;
     [self reloadPhotoViews];
}


#pragma mark - 刷新图片界面
-(void)reloadPhotoViews
{
    
    
    for (int i = 0; i < _image_list.count; i ++) {
        
        UIImage *image = [_image_list objectAtIndex:i];
        
        [self setButtonImageWithTag:i image:image];
        
        
    }
    
    //将没有放置图片的按钮设置成不可点击
    [self setButtonEnAble];
    
}

-(void)setButtonImageWithTag:(NSInteger)tag image:(UIImage*)image
{
    for (UIButton *button in _photoView.subviews) {
        
        if (button.tag == tag +1 ) {
            
            [button setImage:image forState:UIControlStateNormal];
            
        }
    }
}

-(void)setButtonEnAble
{
    for (UIButton *button in _photoView.subviews) {
        
        if (button.tag <= _image_list.count) {
            
            button.enabled = YES;
            
        }
        else
        {
            button.enabled = NO;
            
        }
    }
}

#pragma mark - RSKImageCropViewControllerDelegate
-(void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{

}

-(void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle
{
    _image_list[_select_imageview_index]=croppedImage;
    
    [self reloadPhotoViews];
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
