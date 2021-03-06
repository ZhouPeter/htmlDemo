//
//  Download.m
//  htmlDemo
//
//  Created by 周鹏杰 on 2017/4/5.
//  Copyright © 2017年 周. All rights reserved.
//

#import "Download.h"
#import "SSZipArchive.h"



#define headerPath [NSHomeDirectory() stringByAppendingPathComponent: @"/Library/Caches/HTML/upZip/"]

@implementation Download



+ (Download*)shareInstance {
    
    static Download *download = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        download  = [[Download alloc] init];
    });
    return  download;
}
- (void)unzipFileAtPath:(NSString *)path toDestination:(NSString *)destination {
    
    [SSZipArchive unzipFileAtPath:path toDestination:destination overwrite:YES password:nil error:nil delegate:nil];
}
- (void)downloadWithUrlString:(NSString *)urlString  forceUpdate:(BOOL) forceUpdate{
    //文件管理对象
    NSFileManager *manager = [NSFileManager defaultManager];
    //强制更新先删除
    if (forceUpdate) {
        [manager removeItemAtPath: headerPath error: nil];
    }
    //判断路径是否存在 第一次创建文件
    if (![manager fileExistsAtPath:headerPath]) {
        [manager createDirectoryAtPath:headerPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //判断是否请求成功
        if (!error) {
            NSString *fullPath = [headerPath stringByAppendingPathComponent:response.suggestedFilename];
            if ([manager fileExistsAtPath:fullPath]) {
                [manager removeItemAtPath:fullPath error:nil];
            }
            //剪切到指定位置
            [manager moveItemAtURL:location toURL:[NSURL fileURLWithPath:fullPath] error:nil];
            [self unzipFileAtPath:fullPath toDestination:headerPath];
            [manager removeItemAtPath: fullPath error: nil];

        }
    }];
    //提交请求
    [downloadTask resume];
}
- (void)cleanHtml {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSLog(@"%@", headerPath);
    [manager removeItemAtPath: headerPath error: nil];
}
- (NSURL *)fileUrlWithUrlString:(NSString *)urlString{

    //文件管理者
    NSFileManager *manager = [NSFileManager defaultManager];
    NSRange range = [urlString rangeOfString:@"h5"];
    //文件路径
    NSString *fileName = [urlString substringFromIndex:range.location + range.length + 1];
    //总路径
    NSString *filePath = [headerPath stringByAppendingPathComponent:fileName];
    NSURL *url;
    //判断文件是否在本地存在 存在返回本地地址 不存在返回网络地址
    if ( [urlString containsString:@"ttg"] && [manager fileExistsAtPath:filePath] ) {
        url = [NSURL fileURLWithPath:filePath];

    }else{
        url = [NSURL URLWithString:urlString];
    }
    return url;
}
@end
