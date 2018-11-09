//
//  ViewController.m
//  YSHTTPClient
//
//  Created by Yuns on 2018/7/28.
//  Copyright © 2018年 Yuns. All rights reserved.
//

#import "ViewController.h"
#import "MyHTTPClient.h"

static NSString * const kBaseURL = @"http://gank.io";
static NSString * const kIOSApiURL = @"/api/data/iOS/10/1";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置baseURL
    [MyHTTPClient shareClient].baseURL = kBaseURL;
}

- (IBAction)requestAction:(id)sender {
    // 发起请求
    [[MyHTTPClient shareClient] REQUEST:kIOSApiURL
                             parameters:nil
                             httpMethod:MyNetworkRequestMethod_GET
                            requestType:MyNetworkRequestType_JSON
                           responseType:MyNetworkResponseType_JSON
                                success:^(id response) {
                                    NSLog(@"请求成功：%@", response);
                                }
                                failure:^(NSError *error) {
                                    NSLog(@"请求失败：%@", error);
                                }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
