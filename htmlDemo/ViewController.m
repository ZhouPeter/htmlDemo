//
//  ViewController.m
//  htmlDemo
//
//  Created by 周鹏杰 on 2017/4/5.
//  Copyright © 2017年 周. All rights reserved.
//

#import "ViewController.h"
#import "Download.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController
- (IBAction)download:(UIButton *)sender {
    [[Download shareInstance] downloadWithUrl:@"www.baidu.com"];
    NSString * headerPath =  [NSHomeDirectory() stringByAppendingString: @"/Library/Caches/HTML/"];
    [[Download shareInstance] unzipFileAtPath:[headerPath stringByAppendingString:@"baidu.zip"] toDestination:headerPath];
}
- (IBAction)loadWebView:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    [_webView loadRequest: request];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}



@end
