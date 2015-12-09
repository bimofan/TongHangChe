//
//  CarInputViewController.m
//  TXCar
//
//  Created by jack on 15/9/21.
//  Copyright (c) 2015年 BH. All rights reserved.
//

#import "CarInputViewController.h"
#import "RKDropdownAlert.h"
#import <BmobSDK/Bmob.h>
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobProFile.h>
#import "CarSelectViewController.h"
#import "CarImg.h"
#import "CarDetail.h"
#import "UUDatePicker.h"
#import "SVProgressHUD.h"
#import "CityViewController.h"
#import "RSKImageCropViewController.h"
#import "UzysAssetsPickerController.h"
#import "User.h"
#import "EditPhotoViewController.h"
@interface CarInputViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate,UzysAssetsPickerControllerDelegate,RSKImageCropViewControllerDelegate,RSKImageCropViewControllerDataSource,UUDatePickerDelegate,UIActionSheetDelegate,EditPhotoViewDelegate>


@property(nonatomic,copy)NSMutableArray * image_list;
@property(nonatomic,strong)UITextField * select_textfield;
@property(nonatomic,strong)UITextView * select_textview;
@property(nonatomic,assign)int select_imageview_index;
@property(nonatomic,copy)NSMutableArray * car_image_filename;
@property(nonatomic,copy)NSMutableArray * car_image_fileurl;
@property(nonatomic,assign)float gonglishu;
@property(nonatomic,assign)float jiage;
@property(nonatomic,copy)NSString * kong1;
@property(nonatomic,copy)NSString * kong2;
@property(nonatomic,copy)NSString * urlpic;
@property(nonatomic,copy)NSString * car_user_id;
@property(nonatomic,copy)NSString * phone;
@property(nonatomic,copy)NSString *contactName1;
@property(nonatomic,copy)NSString *uurrll1;
@property(nonatomic,copy)NSString *uurrll;
@property(nonatomic,copy)NSString *shangpaishijian;
@property(nonatomic,copy)NSString *carNotes1;
@end

@implementation CarInputViewController{
    BmobQuery   *bquery;
    UITextField *SpecifiedTime;
    CarImg * modelimg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _gonglishu=0;
    _jiage=0;
    self.title = @"转车";
    _image_list=[[NSMutableArray alloc]init];
    _car_image_filename=[[NSMutableArray alloc]init];
    _car_image_fileurl=[[NSMutableArray alloc]init];
    _select_imageview_index=-1;
    UIImage * imaaa=[UIImage imageNamed:@"tianjiazhaopian"];
    [_image_list addObject:imaaa];
    _tableview_input.delegate = self;
    _tableview_input.dataSource = self;
    _car_user_id= [BmobUser getCurrentUser].objectId;
    _phone=[[BmobUser getCurrentUser]objectForKey:@"username"];
    if ([[BmobUser getCurrentUser]objectForKey:@"contact"]!=nil) {
        _contactName1=[[BmobUser getCurrentUser]objectForKey:@"contact"];
    }
   
    
    
    
    
    UIBarButtonItem *submit_btn = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(submit_clicked)];
    self.navigationItem.rightBarButtonItem =submit_btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)submit_clicked{
    [_select_textview resignFirstResponder];
    [_select_textfield resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, 0);
    }];
 
    if (_image_list.count == 1) {
        [RKDropdownAlert title:@"提示: 请选择图片进行上传" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    if (_cainfo==nil) {
        [RKDropdownAlert title:@"提示: 请选择车辆类型" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    if (_suozaidi==nil) {
        [RKDropdownAlert title:@"提示: 请选择车辆所在地" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    
//    if (_gonglishu == 0) {
//        [RKDropdownAlert title:@"提示: 请输入行驶里程" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
//        return;
//    }
    if (_dihzi==nil) {
        [RKDropdownAlert title:@"提示: 请选择车辆原籍" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
//    if (_jiage == 0) {
//        [RKDropdownAlert title:@"提示: 请输入转让价格" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
//        return;
//    }
    if (_shangpaishijian==nil) {
        [RKDropdownAlert title:@"提示: 请选择上牌日期" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    
    if ([_phone isEqual:@""]) {
        [RKDropdownAlert title:@"提示: 请输入联系人电话" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }
    
    if ([_contactName1 isEqual:@""]) {
        [RKDropdownAlert title:@"提示: 请输入联系人" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
        return;
    }


  
   
  
//    
    [SVProgressHUD showWithStatus:@"正在发布"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
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
        [SVProgressHUD dismiss];
        if (!error) {
            [_car_image_filename addObjectsFromArray:filenameArray];
            [_car_image_fileurl addObjectsFromArray: urlArray];
            
            for(int i=0;i<self.car_image_fileurl.count;i++){
                //        NSLog(@"%@",self.car_image_fileurl[i]);
                NSString *yyyy=@"?t=1&a=a52116a3990792c133814c1b0702a2aa";
                NSString *yyy= [NSString stringWithFormat:@"%@%@", self.car_image_fileurl[i],yyyy];
                NSLog(@"yyy%@",yyy);
                NSLog(@"%@11",_car_image_fileurl[i]);
                _car_image_fileurl[i]=yyy;
                NSLog(@"%@22",_car_image_fileurl[i]);
            }
            _urlpic=self.car_image_fileurl[0];
            NSLog(@"yyy%@",_urlpic);
            [self save_bmob_cardetail];
        }
        else
        {
            NSLog(@"error:%@",error);
            
        }
        
        
        
    } progress:^(NSUInteger index, CGFloat progress) {
        
        NSLog(@"index:%ld,progress:%f",(long)index,progress);
        
    }];
}
-(void)save_bmob_cardetail{
    BmobObject  *bmob_object = [BmobObject objectWithClassName:@"CarDetail"];
    [bmob_object setObject:_cainfo forKey:@"carInfo"];
    [bmob_object setObject:_urlpic forKey: @"carPic"];
    [bmob_object setObject:_phone forKey: @"contactPhone"];
    [bmob_object setObject:_car_user_id forKey: @"userId"];
    [bmob_object setObject:0 forKey: @"publishTime"];
    [bmob_object setObject:_contactName1 forKey: @"contactName"];
    [bmob_object setObject:_dihzi forKey: @"carColor"];
    [bmob_object setObject:_suozaidi forKey:@"carLocation"];
    [bmob_object setObject:_carNotes1 forKey:@"carNotes"];
    [bmob_object setObject:[NSNumber numberWithFloat:_jiage]  forKey: @"carPrice"];
    [bmob_object setObject:@"selling" forKey: @"carState"];
    [bmob_object setObject:_shangpaishijian forKey: @"carYearCheck"];
    [bmob_object setObject:[NSNumber numberWithInt:0] forKey: @"flag"];
    [bmob_object setObject:[NSNumber numberWithFloat:_gonglishu] forKey: @"carDistance"];
     BmobUser *sUser = [BmobUser objectWithoutDatatWithClassName:@"_User" objectId:[[BmobUser getCurrentUser]objectId]];
    [bmob_object setObject:sUser forKey:@"cUser"];
    
    
    BmobQuery *bmob_query = [BmobQuery queryWithClassName:@"CarDetail"];
    [bmob_query countObjectsInBackgroundWithBlock:^(int count,NSError  *error){
        int car_num=count;
        int car_num1=car_num+10000;
        NSString * jjj=[NSString stringWithFormat:@"TX%d",car_num1];
        [bmob_object setObject:jjj forKey:@"carNumber"];
        [bmob_object saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                
                [self save_bmob_carimg:bmob_object.objectId];
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"发布成功"];
                [RKDropdownAlert title:@"发布成功" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
                [self.navigationController popToRootViewControllerAnimated:YES];
             } else if (error){
                NSLog(@"%@",error);
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:@"发布失败"];
                [RKDropdownAlert title:@"发布失败" backgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] time:1];
                
            }
        }];
    }];
    
}

- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [RKDropdownAlert title:@"提示 : 选择第一张图片进行编辑" backgroundColor:[UIColor orangeColor] textColor:[UIColor whiteColor] time:1];
    NSLog(@"可能出错3");
    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"])
    {
        for (ALAsset * item in assets) {
            ALAsset * representation = item;
            UIImage * image=[UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                                scale:representation.defaultRepresentation.scale
                                          orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
            [_image_list insertObject:image atIndex:0];
        }
        [_tableview_input reloadData];
        
    }
}

- (void)uzysAssetsPickerControllerDidCancel:(UzysAssetsPickerController *)picker
{
    [_tableview_input reloadData];
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"最多只能选择8张图片" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}


-(void)save_bmob_carimg:(NSString*)id_key{
    NSLog(@"可能出错2");
    BmobObject *bmob_object = [BmobObject objectWithClassName:@"CarImg"];
    for(int i=0;i<_car_image_fileurl.count;i++){
        _uurrll=[_car_image_filename objectAtIndex:i];
        _uurrll1=[_car_image_fileurl objectAtIndex:i];
        [bmob_object setObject:id_key forKey: @"carId"];
        [bmob_object setObject:_uurrll forKey: @"imgName"];
        [bmob_object setObject:_uurrll1 forKey: @"url"];
        [bmob_object saveInBackground];
    }
}

-(void)tap_image:(UITapGestureRecognizer *)sender{
    if (sender.view.tag==_image_list.count-1) {
        UzysAssetsPickerController * picker=[[UzysAssetsPickerController alloc]init];
        picker.delegate=self;
        picker.maximumNumberOfSelectionPhoto=8;
        picker.maximumNumberOfSelectionVideo=0;
        [_image_list removeAllObjects];
        [_image_list addObject:[UIImage imageNamed:@"tianjiazhaopian"]];
        [self presentViewController:picker animated:YES  completion:nil];
    }else{
        // NSLog(@"%ld",sender.view.tag+1);
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        
        [actionSheet addButtonWithTitle:@"拖动、缩放或者旋转图片"];
        [actionSheet addButtonWithTitle:@"马赛克"];
        
        [actionSheet addButtonWithTitle:@"取消"];
        
        actionSheet.cancelButtonIndex = 2;
        actionSheet.tag = sender.view.tag;
        
        [actionSheet showInView:self.view];
        
        _select_imageview_index=(int)sender.view.tag;

    }
    
}
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
{
    self.image_list[_select_imageview_index]=croppedImage;
    [_tableview_input reloadData];
   [controller dismissViewControllerAnimated:YES completion:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {
        return 98;
    }
    else if(indexPath.section == 3 && indexPath.row == 2)
    {
        return 120;
    }
    else
    {
        return 45;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(section == 0)
    {
        return 15;
    }
    else
    {
        return 5;
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
    
    
}
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0)
    {
        return 1;
    }
    else if(section == 1)
    {
        return 4;
    }
    else if(section == 2)
    {
        return 2;
    }
    else
    {
        return 3;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"take_photo_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        UIScrollView * scroll_view = (UIScrollView*)[cell viewWithTag:1];
        
        for (UIView * view in scroll_view.subviews)
        {
            UIView * sub = view;
            
            [sub removeFromSuperview];
        }
        
        for(int i = 0 ; i < _image_list.count ; i++)
        {
            
            UIImageView * image_view = [[UIImageView alloc] initWithFrame:CGRectMake(9 + 113 * i, 8, 102, 81)];
            
            image_view.image = _image_list[i];
            
            image_view.contentMode = UIViewContentModeScaleToFill;
            
            image_view.userInteractionEnabled = YES;
            
            
            
            
            UITapGestureRecognizer *tap_image=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap_image:)];
            tap_image.numberOfTapsRequired = 1;
            image_view.tag =  i;
            [image_view addGestureRecognizer:tap_image];
            [scroll_view addSubview:image_view];
            
        }
        
        scroll_view.contentSize = CGSizeMake(114 * _image_list.count,97);
        
        return cell;
    }
    else if(indexPath.section == 1 && indexPath.row == 0)
    {
        static NSString * cellID = @"car_type_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        UITextField * text_field = (UITextField*)[cell viewWithTag:1];
        //加model
        text_field.text = _cainfo;
        
        return cell;
    }
    else if(indexPath.section == 1 && indexPath.row == 1)
    {
        static NSString * cellID = @"location_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        UITextField * text_field = (UITextField*)[cell viewWithTag:1];
        
        
        text_field.text = _suozaidi;
        
        return cell;
    }
    else if(indexPath.section == 1 && indexPath.row == 2)
    {
        static NSString * cellID = @"distance_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        UITextField * text_field = (UITextField*)[cell viewWithTag:1];
        //改
        if (_gonglishu != 0)
        {
            text_field.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:_gonglishu]];
            
        }
        
        text_field.delegate = self;
        
        return cell;
    }
    else if(indexPath.section == 1 && indexPath.row == 3)
    {
        static NSString * cellID = @"oringe_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        UITextField * text_field = (UITextField*)[cell viewWithTag:1];
        
        text_field.text = _dihzi;
        
        return cell;
    }
    else if(indexPath.section == 2 && indexPath.row == 0)
    {
        static NSString * cellID = @"money_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        UITextField * text_field = (UITextField*)[cell viewWithTag:1];
        
        if (_jiage != 0)
        {
            text_field.text = [NSString stringWithFormat:@"%@",[NSNumber numberWithFloat:_jiage]];
        }
        
        text_field.delegate = self;
        
        return cell;
    }
    else if(indexPath.section == 2 && indexPath.row == 1)
    {
        static NSString * cellID = @"date_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        UITextField * text_field = (UITextField*)[cell viewWithTag:1];
        
        text_field.text = _model.carYearCheck;
        
        return cell;
    }
    else if(indexPath.section == 3 && indexPath.row == 0)
    {
        static NSString * cellID = @"contact_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        UITextField * text_field = (UITextField*)[cell viewWithTag:1];
        
        text_field.tag=111;
        text_field.text = _contactName1;
        text_field.delegate = self;
        
        return cell;
    }
    else if(indexPath.section == 3 && indexPath.row == 1)
    {
        static NSString * cellID = @"telephone_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        UITextField * text_field = (UITextField*)[cell viewWithTag:1];
        text_field.tag=110;
        text_field.text =_phone;
        text_field.delegate = self;
        
        return cell;
    }
    else
    {
        static NSString * cellID = @"discription_cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        UITextView * text_view =(UITextView*)[cell viewWithTag:1];
        text_view.delegate = self;
        
        return cell;
    }
    
}
- (IBAction)textfield_distance:(UITextField *)sender {
    _gonglishu=[sender.text floatValue];
    [_tableview_input reloadData];
}
- (IBAction)textfield_price:(UITextField *)sender {
    _jiage = [sender.text floatValue];
    NSLog(@"%@",[NSNumber numberWithFloat:_jiage] );
    
    [_tableview_input reloadData];
    
}
- (IBAction)textfield_contact:(UITextField *)sender {
   
    _contactName1=sender.text;
     NSLog(@"222%@", _contactName1);
    [_tableview_input reloadData];
    
}
- (IBAction)textfield_phone_num:(UITextField *)sender {
    _phone=sender.text;
    NSLog(@"111!%@", _phone);
    [_tableview_input reloadData];
    
}
- (IBAction)lalalalallalala:(UITextField *)sender {
    [sender resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, 0);
    }];
}
- (IBAction)shangpaishijian:(UITextField *)sender {
    _shangpaishijian=sender.text;
     [_tableview_input reloadData];
 
}
- (IBAction)asdad:(UITextField *)sender {
    
    [self bubububu];
    

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [_select_textfield resignFirstResponder];
    [_select_textview resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, 0);
    }];
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _select_textfield=textField;
    UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
    NSIndexPath * index=[_tableview_input indexPathForCell:cell];
    [_tableview_input scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    if (index.section == 3 && index.row == 0)
    {
        [UIView animateWithDuration:0.4 animations:^{
            self.view.transform=CGAffineTransformMakeTranslation(0, -160);
        }];
    }
    if (index.section == 3 && index.row == 1)
    {
        
        [UIView animateWithDuration:0.4 animations:^{
            self.view.transform=CGAffineTransformMakeTranslation(0, -160);
        }];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_select_textfield resignFirstResponder];
    [_select_textview resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, 0);
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [_select_textfield resignFirstResponder];
    [_select_textview resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, 0);
    }];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    _select_textview=textView;
    [UIView animateWithDuration:0.4 animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, -190);
    }];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    _carNotes1=textView.text;
    [_tableview_input reloadData];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITextField * lable7=( UITextField*)[self.view viewWithTag:100];
    if (indexPath.section == 2 && indexPath.row == 1)
    {
    
    }else {
        [lable7 resignFirstResponder];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.select_textfield resignFirstResponder];
    [self.select_textview resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.transform=CGAffineTransformMakeTranslation(0, 0);
    }];
    if (indexPath.section == 1 && indexPath.row == 0) {
        CarSelectViewController * view=[self.storyboard instantiateViewControllerWithIdentifier:@"car_select_view"];
        view.type_info=@"转车—车型选择";
        [self.navigationController pushViewController:view animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        CityViewController * view=[self.storyboard instantiateViewControllerWithIdentifier:@"city_select_view"];
        view.city_select_type=@"转车—所在地";
        [self.navigationController pushViewController:view animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
        CityViewController * view=[self.storyboard instantiateViewControllerWithIdentifier:@"city_select_view"];
        view.city_select_type=@"转车—车辆原籍";
        [self.navigationController pushViewController:view animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 1)
    {
      
    }
}
-(void)bubububu{
    
    UITextField * lable7=( UITextField*)[self.view viewWithTag:100];
    UUDatePicker *datePicker
    = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, 320, 200)
                             PickerStyle:1
                             didSelected:^(NSString *year,
                                           NSString *month,
                                           NSString *day,
                                           NSString *hour,
                                           NSString *minute,
                                           NSString *weekDay) {
                                 lable7.text = [NSString stringWithFormat:@"%@-%@",year,month];
                             }];
    lable7.inputView = datePicker;
    
}
- (void)uuDatePicker:(UUDatePicker *)datePicker
                year:(NSString *)year
               month:(NSString *)month
                 day:(NSString *)day
                hour:(NSString *)hour
              minute:(NSString *)minute
             weekDay:(NSString *)weekDay
{

}


#pragma mark -UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        
        RSKImageCropViewController * image_crop_vc=[[RSKImageCropViewController alloc]initWithImage:_image_list[_select_imageview_index]];
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
        
        _editrVC.sourseImg = _image_list[_select_imageview_index];
        
        [self presentViewController:_editrVC animated:YES completion:nil];
        
        
        
    }
}


#pragma mark - EditPhotoViewDelegate
-(void)doneEditePhoto:(UIImage *)photo
{
    self.image_list[_select_imageview_index]=photo;
    [_tableview_input reloadData];
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//  
//    [super touchesBegan:touches withEvent:event];
//    [self.view endEditing:YES];
//}
@end
