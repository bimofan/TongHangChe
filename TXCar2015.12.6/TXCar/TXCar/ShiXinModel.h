//
//  ShiXinModel.h
//  TXCar
//
//  Created by ZhuHaikun on 15/12/9.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONModel.h"

@interface ShiXinModel : JSONModel
@property (nonatomic,strong)NSString *id;
@property (nonatomic,assign ) NSInteger Sourceid;
@property (nonatomic,strong) NSString *Uniqueno;
@property (nonatomic,strong) NSString *Name;
@property (nonatomic,strong) NSString *Liandate;
@property (nonatomic,strong ) NSString *Anno;
@property (nonatomic,strong ) NSString *Orgno;
@property (nonatomic,strong ) NSString *Ownername;
@property (nonatomic,strong ) NSString *Executegov;
@property (nonatomic,strong ) NSString *Province;
@property (nonatomic,strong ) NSString *Executeunite;
@property (nonatomic,strong ) NSString *Yiwu;
@property (nonatomic,strong ) NSString *Executestatus;
@property (nonatomic,strong ) NSString *Actionremark;
@property (nonatomic,strong ) NSString *Publicdate;
@property (nonatomic,assign)  NSInteger Follows;
@property (nonatomic,assign ) NSInteger Age;
@property (nonatomic,strong) NSString *Sexy;

@property (nonatomic,strong ) NSString *Updatedate;
@property (nonatomic,strong ) NSString *Executeno;
@property (nonatomic,strong ) NSString *Performedpart;
@property (nonatomic,strong ) NSString *Unperformpart;
@property (nonatomic,assign ) BOOL    Isperson;
@property (nonatomic,strong ) NSString *Createdate;


@property (nonatomic,strong ) NSString *ExecuteGov;
@property (nonatomic,strong ) NSString *Biaodi;
@property (nonatomic,strong ) NSString *Status;
@property (nonatomic,strong ) NSString *PartyCardNum;




@property (nonatomic)   NSInteger type;  // 1 失信    2 执行



@end
