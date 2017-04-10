//
//  FilteredProtocol.m
//  htmlDemo
//
//  Created by 周鹏杰 on 2017/4/5.
//  Copyright © 2017年 周. All rights reserved.
//

#import "FilteredProtocol.h"
#import "Download.h"

@interface FilteredProtocol ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSMutableData  *responseData;
@property (nonatomic, strong) NSURLSession *session;

@end


static NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";

@implementation FilteredProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request{
    NSString *url = request.URL.absoluteString;
    //看看是否已经处理过了，防止无限循环
    if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
        return NO;
    }
    if (![url containsString:@"ttgcdn.tatagou.com.cn"]) {
        NSLog(@"%@", request.URL.absoluteString);
        return NO;
    }
    return  YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request{
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
//    NSURL *fileUrl = [[Download shareInstance] fileUrlWithUrlString:mutableReqeust.URL.absoluteString];
//    mutableReqeust.URL = fileUrl;
    return mutableReqeust;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b{
    return [super requestIsCacheEquivalent:a toRequest:b];
}
//开始加载
- (void)startLoading{

    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    NSURL *fileUrl = [[Download shareInstance] fileUrlWithUrlString:mutableReqeust.URL.absoluteString];
    mutableReqeust.URL = fileUrl;
        //打标签，防止无限循环
    [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:mutableReqeust];
   
    NSURLSessionConfiguration *configure = [NSURLSessionConfiguration defaultSessionConfiguration];
    self.session = [NSURLSession sessionWithConfiguration:configure delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:mutableReqeust];
    [task resume];

}
+(NSMutableURLRequest*)redirectHostInRequset:(NSMutableURLRequest*)request {
    if ([request.URL host].length == 0) {
        return request;
    }
    
    NSString *originUrlString = [request.URL absoluteString];
    NSString *originHostString = [request.URL host];
    NSRange hostRange = [originUrlString rangeOfString:originHostString];
    if (hostRange.location == NSNotFound) {
        return request;
    }
    //定向到bing搜索主页
    NSString * headerPath =  [NSHomeDirectory() stringByAppendingPathComponent: @"/Library/Caches/HTML/upZip/"];
    // 替换域名
    NSString *urlString = [originUrlString stringByReplacingCharactersInRange:hostRange withString:headerPath];
    NSURL *url = [NSURL URLWithString:urlString];
    request.URL = url;
    
    return request;
}
//结束请求
- (void)stopLoading{
    [self.session invalidateAndCancel];
    self.session = nil;
    
}




// MARK: - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if(error) {
        [self.client URLProtocol:self didFailWithError:error];
    }else {
        [self.client URLProtocolDidFinishLoading:self];
    }
}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    completionHandler(NSURLSessionResponseAllow);

}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    [self.client URLProtocol:self didLoadData:data];

}
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask willCacheResponse:(NSCachedURLResponse *)proposedResponse completionHandler:(void (^)(NSCachedURLResponse * _Nullable))completionHandler {
     completionHandler(proposedResponse);
}

@end
