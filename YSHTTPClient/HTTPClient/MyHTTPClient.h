

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MyNetworkRequestMethod) {
    MyNetworkRequestMethod_GET = 1,   //GET
    MyNetworkRequestMethod_POST= 2    //POST
};

typedef NS_ENUM(NSUInteger, MyNetworkRequestType) {
    MyNetworkRequestType_JSON = 1,    // 默认
    MyNetworkRequestType_Data = 2     // 二进制格式
};

typedef NS_ENUM(NSUInteger, MyNetworkResponseType) {
    MyNetworkResponseType_JSON = 1,   // 默认
    MyNetworkResponseType_XML  = 2,   // XML
    MyNetworkResponseType_Data = 3,   // 二进制格式
};

typedef void (^MyNetworkResponseSuccess)(id response);
typedef void (^MyNetworkResponseFail)(NSError *error);
typedef void (^MyNetworkProgress)(NSProgress *loadProgress);

/***上传文件类***/
@interface MyUploadData: NSObject
@property (nonatomic, strong) NSData *data;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileType;
@end

@interface MyUploadFile: NSObject
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *fileType;
@end
/*************/

@interface MyHTTPClient : NSObject

/**baseUrl*/
@property (nonatomic, copy) NSString *baseURL;
/**header*/
@property (nonatomic, strong) NSDictionary *HTTPHeader;

+ (instancetype)shareClient;

/**
 普通 GET/POST

 @param URLString 请求地址
 @param parameters 请求参数
 @param httpMethod 请求方式（GET/POST）
 @param requestType 请求数据类型
 @param responseType 响应数据类型
 @param success 成功回调
 @param failure 失败回调
 */
- (NSURLSessionTask *)REQUEST:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                   httpMethod:(MyNetworkRequestMethod)httpMethod
                  requestType:(MyNetworkRequestType)requestType
                 responseType:(MyNetworkResponseType)responseType
                      success:(MyNetworkResponseSuccess)success
                      failure:(MyNetworkResponseFail)failure;

/**
 批量上传二进制数据/文件

 @param URLString 请求地址
 @param parameters 请求参数
 @param requestType 请求数据类型
 @param responseType 响应数据类型
 @param datas 二进制数据【数组】
 @param files 文件数据【数组】
 @param progress 上传进度回调
 @param success 成功回调
 @param failure 失败回调
 */
- (NSURLSessionDataTask *)UPLOAD:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                     requestType:(MyNetworkRequestType)requestType
                    responseType:(MyNetworkResponseType)responseType
                           datas:(NSArray<MyUploadData *> *)datas
                           files:(NSArray<MyUploadFile *> *)files
                        progress:(MyNetworkProgress)progress
                         success:(MyNetworkResponseSuccess)success
                         failure:(MyNetworkResponseFail)failure;
@end
