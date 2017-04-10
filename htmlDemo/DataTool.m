//
//  DataTool.m
//  ttjx
//
//  Created by 周鹏杰 on 2017/3/10.
//  Copyright © 2017年 周. All rights reserved.
//

#import "DataTool.h"
#import "AppDelegate.h"
@implementation DataTool

+(void)getDataWithUrl: (NSString*) urlString parameters:(NSDictionary*) parameters success:(void(^)(NSDictionary* data)) success failure:(void(^)(NSError* error)) failure{
    NSMutableString *strM = [[NSMutableString alloc] init];
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 服务器接收参数的 key 值.
        NSString *paramaterKey = key;
        
        // 参数内容
        NSString *paramaterValue = obj;
        
        // appendFormat :可变字符串直接拼接的方法!
        [strM appendFormat:@"%@=%@&",paramaterKey,paramaterValue];
    }];
    
    urlString = [NSString stringWithFormat:@"%@?%@",urlString,strM];
    // 截取字符串的方法!
    urlString = [urlString substringToIndex:urlString.length - 1];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 10;
    request.HTTPMethod = @"GET";
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil){
            failure(error);
            return;
        }else{
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(jsonData);
            });
        }
    }];
    [task resume];
   
    
    
}

@end
