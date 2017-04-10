//
//  DataTool.h
//  ttjx
//
//  Created by 周鹏杰 on 2017/3/10.
//  Copyright © 2017年 周. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataTool : NSObject
+(void)getDataWithUrl: (NSString*) urlString parameters:(NSDictionary*) parameters success:(void(^)(NSDictionary* data)) success failure:(void(^)(NSError* error)) failure;

@end
