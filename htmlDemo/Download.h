//
//  Download.h
//  htmlDemo
//
//  Created by 周鹏杰 on 2017/4/5.
//  Copyright © 2017年 周. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Download : NSObject

/**
 单例方法

 @return 单例对象
 */
+(Download*)shareInstance;
-(void)downloadWithUrl:(NSString*)url;

/**
 返回新的url

 @param urlString 获取的http的字符串
 @return 本地或者网络的url
 */
-(NSURL *)fileUrlWithUrlString:(NSString *)urlString;

/**
 解压方法

 @param path 压缩文件路径
 @param destination 解压目的路径
 */
-(void)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination;
@end
