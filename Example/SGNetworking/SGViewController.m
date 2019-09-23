//
//  SGViewController.m
//  SGNetworking
//
//  Created by SG on 09/17/2019.
//  Copyright (c) 2019 SG. All rights reserved.
//

#import "SGViewController.h"
#import "SGMacros.h"

typedef NS_ENUM(NSUInteger, WMClientRequestCachePolicy){
    WMClientReturnCacheDataThenLoad = 0,///< 有缓存就先返回缓存，同步请求数据
    WMClientReloadIgnoringLocalCacheData, ///< 忽略缓存，重新请求
    WMClientReturnCacheDataElseLoad,///< 有缓存就用缓存，没有缓存就重新请求(用于数据不变时)
    WMClientReturnCacheDataDontLoad,///< 有缓存就用缓存，没有缓存就不发请求，当做请求出错处理（用于离线模式）
};

/*
 一 封装的目的:
 1. 集约管理,如需更换网络管理工具可以轻松应对
 2. 单例的 AFHTTPSessionManager 实例避免内存泄漏,
 3. 单例可以共享 NSURLSession 中的 TCP 通道避免多次握手
 
 二 目前只有四种网络请求方式:
 1. 普通的服务器接口API GET请求
 2. 普通的服务器API POST请求
 3. 资源文件的上传根据文件路径
 4. 资源文件的上传根据 NSData
 
 三 设置BaseURL
 设置BaseURL可以使在此目标服务器的地址,带不带域名都可以
 
 四 注意:
 如果需要修改 AFManager 的序列化配置来进行请求的话(比如进行图片下载),
 请增加另外一个AFHTTPSessionManager实例, 避免在多线程的情况下修改 AFManager 造成线程不安全.
 */

@interface SGViewController ()

@end

@implementation SGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = UIColor.whiteColor;

    NSLog(@"%@", SG_PathDocumentAppend(@"GUI"));
}

@end
