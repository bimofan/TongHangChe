//
//  RequestMethod.m
//  TXCar
//
//  Created by ZhuHaikun on 15/12/9.
//  Copyright © 2015年 BH. All rights reserved.
//

#import "RequestMethod.h"

@implementation RequestMethod

+(void)requestWithURL:(NSString*)url  params:(NSDictionary*)params results:(void(^)(BOOL success,id results))block
{
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"sucess,url:%@,params:%@, response:%@",url,params,operation.responseString);
        
        
        if (block) {
            
            block(YES,responseObject);
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        NSLog(@"fail,url:%@,params:%@, response:%@",url,params,operation.responseString);
        
        
        if (block) {
            
            block(NO,nil);
            
        }
    }];
    
    
}
@end
