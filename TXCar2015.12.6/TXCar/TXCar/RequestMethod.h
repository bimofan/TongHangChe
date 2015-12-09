//
//  RequestMethod.h
//  TXCar
//
//  Created by ZhuHaikun on 15/12/9.
//  Copyright © 2015年 BH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface RequestMethod : NSObject

+(void)requestWithURL:(NSString*)url  params:(NSDictionary*)params results:(void(^)(BOOL success,id results))block;
                                                                            
@end
