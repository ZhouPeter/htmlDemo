//
//  ViewController.m
//  htmlDemo
//
//  Created by 周鹏杰 on 2017/4/5.
//  Copyright © 2017年 周. All rights reserved.
//

#import "ViewController.h"
#import "Download.h"
#import "DataTool.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController
- (IBAction)download:(UIButton *)sender {
    [[Download shareInstance] downloadWithUrlString:@"https://ttgcdn.tatagou.com.cn/h5/20170406-AAAAAA.zip" forceUpdate:NO];

}

- (IBAction)versionCheck:(UIButton *)sender {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDictionary *parameters = @{ @"code" : [def valueForKey:@"versionCode"] };
    [DataTool getDataWithUrl:@"https://testapi.tatagou.com.cn/v2/packageInfo" parameters:parameters success:^(NSDictionary *data) {
        if ([data[@"code"] integerValue] == 200) {
            if ([data[@"data"][@"versionCode"] integerValue] > [[def valueForKey:@"versionCode" ] integerValue]) {
                [[Download shareInstance] downloadWithUrlString:data[@"data"][@"versionUrl"] forceUpdate:data[@"data"][@"forceUpdate"]];
            }
            
        }
    } failure:^(NSError *error) {
        
    }];
}
- (IBAction)clean:(UIButton *)sender {
    [[Download shareInstance] cleanHtml];
}

- (IBAction)loadWebView:(UIButton *)sender {
    [self loadWebView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setInteger:100 forKey:@"versionCode"];
    [def synchronize];
    
}


- (void)loadWebView{
    NSString *urlString = @"https://ttgcdn.tatagou.com.cn/h5/index.html";
    NSURL *url = [[Download shareInstance] fileUrlWithUrlString:urlString];
    //NSURL *url = [[NSURL alloc]initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [_webView loadRequest: request];
}



@end
