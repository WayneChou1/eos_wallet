//
//  HTTPRequestManager.h
//  Underworld
//
//  Created by zhouzhiwei on 2018/7/13.
//  Copyright © 2018年 zijinph. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef NS_ENUM(NSUInteger, HTTPMethod) {
    HTTPMethodGET = 0,
    HTTPMethodPOST,
    HTTPMethodpUT,
    HTTPMethodPATCH,
    HTTPMethodDELETE,
};

@interface HTTPRequestManager : AFHTTPSessionManager

/**
 *  单例
 *
 *  @return 实例对象
 */
+ (instancetype)shareManager;
#pragma mark - GET 请求网络数据
/**
 *  请求网络数据
 *
 *  @param path             请求的地址
 *  @param paramters        请求的参数
 *  @param downLoadProgress 进度
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 */
- (void)requestGETDataWithPath:(NSString *)path
                 withParamters:(NSDictionary *)paramters
                  withProgress:(void(^) (float progress))downLoadProgress
                       success:(void(^) (BOOL isSuccess, id responseObject))success
                       failure:(void(^) (NSError *error))failure;

#pragma mark - POST 传送网络数据
/**
 *  传送网络数据
 *
 *  @param path           请求的地址
 *  @param paramters      请求的参数
 *  @param upLoadProgress 进度
 *  @param success        请求成功的回调
 *  @param failure        请求失败的回调
 */
- (NSURLSessionDataTask *)sendPOSTDataWithPath:(NSString *)path
               withParamters:(NSDictionary *)paramters
                withProgress:(void(^) (float progress))upLoadProgress
                     success:(void(^) (BOOL isSuccess, id responseObject))success
                     failure:(void(^) (NSError *error))failure
               loadingInView:(UIView *)view
      showFaliureDescription:(BOOL)show;

- (NSURLSessionDataTask *)sendPOSTDataWithPath:(NSString *)path
               withParamters:(NSDictionary *)paramters
                     success:(void(^) (BOOL isSuccess, id responseObject))success
                     failure:(void(^) (NSError *error))failure;

- (NSURLSessionDataTask *)sendPOSTDataWithPath:(NSString *)path
               withParamters:(NSDictionary *)paramters
                     success:(void(^) (BOOL isSuccess, id responseObject))success
                     failure:(void(^) (NSError *error))failure inView:(UIView *)view;

- (NSURLSessionDataTask *)sendPOSTDataWithPath:(NSString *)path
               withParamters:(NSDictionary *)paramters
                     success:(void(^) (BOOL isSuccess, id responseObject))success
                     failure:(void(^) (NSError *error))failure
                      inView:(UIView *)view
      showFaliureDescription:(BOOL)show;

#pragma mark POST 上传图片
/**
 *  上传图片
 *
 *  @param path           上传的地址--需要填写完整的url
 *  @param paramters      上传图片预留参数--根据具体需求而定，可以出
 *  @param imageArray     上传的图片数组
 *  @param width          图片要被压缩到的宽度
 *  @param upLoadProgress 进度
 *  @param success        请求成功的回调
 *  @param failure        请求失败的回调
 */
- (void)sendPOSTImageWithPath:(NSString *)path
                withParamters:(NSDictionary *)paramters
               withImageArray:(NSArray *)imageArray
              withtargetWidth:(CGFloat )width
                 withProgress:(void(^) (float progress))upLoadProgress
                      success:(void(^) (BOOL isSuccess, id responseObject))success
                      failure:(void(^) (NSError *error))failure;

#pragma mark POST 上传视频
/**
 *  上传视频
 *
 *  @param path           上传的地址--需要填写完整的url
 *  @param videoPath      上传的视频--本地沙盒的路径
 *  @param paramters      上传视频预留参数--根据具体需求而定，可以出
 *  @param upLoadProgress 进度
 *  @param success        请求成功的回调
 *  @param failure        请求失败的回调
 */
- (void)sendPOSTImageWithPath:(NSString *)path
                withVideoPath:(NSString *)videoPath
                withParamters:(NSDictionary *)paramters
                 withProgress:(void(^) (float progress))upLoadProgress
                      success:(void(^) (BOOL isSuccess, id responseObject))success
                      failure:(void(^) (NSError *error))failure;

#pragma mark DOWNLOAD 文件下载
- (void)requestDownLoadDataWithPath:(NSString *)path
                      withParamters:(NSDictionary *)paramters
                       withSavaPath:(NSString *)savePath
                       withProgress:(void(^) (float progress))downLoadProgress
                            success:(void(^) (BOOL isSuccess, id responseObject))success
                            failure:(void(^) (NSError *error))failure;

#pragma mark - DELETE 删除资源
- (void)requestDELETEDataWithPath:(NSString *)path
                    withParamters:(NSDictionary *)paramters
                          success:(void (^) (BOOL isSuccess, id responseObject))success
                          failure:(void (^) (NSError *error))failure;

#pragma mark - PUT 更新全部属性
- (void)sendPUTDataWithPath:(NSString *)path
              withParamters:(NSDictionary *)paramters
                    success:(void(^) (BOOL isSuccess, id responseObject))success
                    failure:(void(^) (NSError *error))failure;

#pragma  mark - PATCH 改变资源状态或更新部分属性
- (void)sendPATCHDataWithPath:(NSString *)path
                withParamters:(NSDictionary *)paramters
                      success:(void (^) (BOOL isSuccess, id responseObject))success
                      failure:(void (^) (NSError *error))failure;

#pragma mark - 取消网络请求--全部请求
- (void)cancelAllNetworkRequest;

#pragma mark - 取消网络请求--指定请求
/**
 *  取消指定的url请求
 *
 *  @param type 该请求的请求类型
 *  @param path 该请求的完整url
 */
- (void)cancelHttpRequestWithType:(NSString *)type WithPath:(NSString *)path;


/**
 判断返回数据是否

 @param returnData returnData description
 @param response response description
 @return return value description
 */
+ (BOOL)validateResponseData:(id) returnData HttpURLResponse: (NSURLResponse *)response;


@end
