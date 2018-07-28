

#import "MyHTTPClient.h"
#import "AFNetworking.h"

@implementation MyHTTPClient

+ (instancetype)shareClient
{
    static MyHTTPClient *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

// 普通 GET/POST
- (NSURLSessionTask *)REQUEST:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                   httpMethod:(MyNetworkRequestMethod)httpMethod
                  requestType:(MyNetworkRequestType)requestType
                 responseType:(MyNetworkResponseType)responseType
                      success:(MyNetworkResponseSuccess)success
                      failure:(MyNetworkResponseFail)failure
{
    AFHTTPSessionManager *manager = [self configWithTimeOut:30.0 requestType:requestType responseType:responseType];
    NSString *requestURL = [self requestURLString:URLString];
    // 发起网络请求
    NSURLSessionTask *sessionTask = nil;
    if (httpMethod == MyNetworkRequestMethod_GET) {//GET请求
        sessionTask = [manager GET:requestURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }else if (httpMethod == MyNetworkRequestMethod_POST){//POST请求
        sessionTask = [manager POST:requestURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
    }
    return sessionTask;
}

// 上传二进制数据
- (NSURLSessionDataTask *)UPLOAD:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                     requestType:(MyNetworkRequestType)requestType
                    responseType:(MyNetworkResponseType)responseType
                           datas:(NSArray<MyUploadData *> *)datas
                           files:(NSArray<MyUploadFile *> *)files
                        progress:(MyNetworkProgress)progress
                         success:(MyNetworkResponseSuccess)success
                         failure:(MyNetworkResponseFail)failure
{
    AFHTTPSessionManager *manager = [self configWithTimeOut:30.0 requestType:requestType responseType:responseType];
    NSString *requestURL = [self requestURLString:URLString];
    // 发起网络请求
    return [manager POST:requestURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 批量上传二进制数据
        if (datas.count > 0) {
            for (MyUploadData *data in datas) {
                [formData appendPartWithFileData:data.data name:data.name fileName:data.fileName mimeType:data.fileType];
            }
        }
        // 批量上传文件
        if (files.count > 0) {
            for (MyUploadFile *file in files) {
                [formData appendPartWithFileURL:file.URL name:file.name fileName:file.fileName mimeType:file.fileType error:nil];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - SessionManager 配置
- (AFHTTPSessionManager *)configWithTimeOut:(double)timeOut
                                requestType:(MyNetworkRequestType)requestType
                               responseType:(MyNetworkResponseType)responseType

{
    //1、初始化：
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2、设置请求超时时间：
    manager.requestSerializer.timeoutInterval = timeOut;
    //3、设置请求和响应数据格式:需要注意的是,默认提交请求的数据是二进制的,返回格式是JSON
    switch (requestType) {
        case MyNetworkRequestType_JSON:
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case MyNetworkRequestType_Data:
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        default:
            break;
    }
    switch (responseType) {
        case MyNetworkResponseType_JSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case MyNetworkResponseType_XML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case MyNetworkResponseType_Data:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    //4、设置允许接收返回数据类型：
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",@"text/html",@"text/json",@"text/plain",@"text/javascript",@"text/xml",@"image/*"]];
    //5、是否有请求头
    if (_HTTPHeader) {
        for (NSString *key in _HTTPHeader.allKeys) {
            if (_HTTPHeader[key] != nil) {
                [manager.requestSerializer setValue:_HTTPHeader[key] forHTTPHeaderField:key];
            }
        }
    }
    return manager;
}

#pragma mark - URL处理
- (NSString *)requestURLString:(NSString *)URLString {
    //兼容单独的http链接请求
    NSRange range = [URLString rangeOfString:@"http"];
    if (range.length != 0) {
        return [self URLDecodedWithText:URLString];
    }else if (_baseURL != nil) {
        return [_baseURL stringByAppendingString:URLString];
    }
    return URLString;
}

- (NSString *)URLDecodedWithText:(NSString *)text
{
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)text, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}

@end

/***上传文件类***/
@implementation MyUploadData

@end

@implementation MyUploadFile

@end
/*************/
