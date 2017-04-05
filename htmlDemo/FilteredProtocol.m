//
//  FilteredProtocol.m
//  htmlDemo
//
//  Created by 周鹏杰 on 2017/4/5.
//  Copyright © 2017年 周. All rights reserved.
//

#import "FilteredProtocol.h"
#import "Download.h"
@implementation FilteredProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSString *url = [[request URL] absoluteString];
    if (![url containsString:@"v2"]) {
        return NO;
    }
    return  YES;
}
+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    NSString *url = [[request URL] absoluteString];
    NSURL *fileUrl = [[Download shareInstance] fileUrlWithUrlString:url];
    NSMutableURLRequest *fileReqeust = [request mutableCopy];
    [fileReqeust setURL:fileUrl];
    return fileReqeust;
}
+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b{
    return YES;
}
- (void)startLoading{
    
}
- (void)stopLoading{
    
}
@end
