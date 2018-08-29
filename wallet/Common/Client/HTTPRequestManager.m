//
//  HTTPRequestManager.m
//  Underworld
//
//  Created by zhouzhiwei on 2018/7/13.
//  Copyright © 2018年 zijinph. All rights reserved.
//

#import "HTTPRequestManager.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVAssetExportSession.h>
#import "UIImage+Compression.h"

static NSString * const base_url = @"http://mainnet.eoscanada.com/";
static NSString * const eos_monitor_base_url = @"http://eosmonitor.io/api/v1/account/";

static CGFloat delay = 1.5;
static CGFloat timeoutInterval = 10.0;

@implementation HTTPRequestManager

static HTTPRequestManager * defualt_monitor_shareMananger = nil;
static HTTPRequestManager * defualt_shareMananger = nil;

+ (instancetype)shareManager {
    
    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{
        
        if (defualt_shareMananger == nil) {
            defualt_shareMananger = [[self alloc] initWithBaseURL:[NSURL URLWithString:base_url]];
        }
    });
    return defualt_shareMananger;
}

+ (instancetype)shareMonitorManager {

    static dispatch_once_t onceToken;
    _dispatch_once(&onceToken, ^{

        if (defualt_monitor_shareMananger == nil) {
            defualt_monitor_shareMananger = [[self alloc] initWithBaseURL:[NSURL URLWithString:eos_monitor_base_url]];
        }
    });
    wLog(@"eos_monitor_base_url ===== %@",defualt_monitor_shareMananger.baseURL.absoluteString);
    return defualt_monitor_shareMananger;
}

#pragma mark 重写
- (instancetype)initWithBaseURL:(NSURL *)url {
    
    self = [super initWithBaseURL:url];
    if (self) {
        // 设置请求以及相应的序列化器
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        // 设置相应的缓存策略--URL应该加载源端数据，不使用本地缓存数据,忽略缓存直接从原始地址下载。
        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        // 设置超时时间
        self.requestSerializer.timeoutInterval = timeoutInterval;
        
        //注意：默认的Response为json数据
//        AFJSONResponseSerializer *responseSerializer  = [AFJSONResponseSerializer serializer];
        // 在服务器返回json数据的时候，时常会出现null数据。json解析的时候，可能会将这个null解析成NSNull的对象，我们向这个NSNull对象发送消息的时候就会遇到crash的问题。
//        responseSerializer.removesKeysWithNullValues = YES;
        // 设置请求内容的类型-- 复杂的参数类型 需要使用json传值-设置请求内容的类型】
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", @"text/plain", nil];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    return self;
}

#pragma mark - GET 请求网络数据
/**
 *  请求网络数据
 *
 *  @param path             请求的地址
 *  @param paramters        请求的参数
 *  @param success          请求成功的回调
 *  @param failure          请求失败的回调
 */

- (void)get:(NSString *)path paramters:(NSDictionary *)paramters success:(void (^)(BOOL, id))success failure:(void (^)(NSError *))failure superView:(UIView *)view showFaliureDescription:(BOOL)show {
    
    MBProgressHUD *hud;
    if (view) hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    [self GET:path parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (hud) [hud hideAnimated:YES];
        
        wLog(@"responseObject = %@",responseObject);
        if ([HTTPRequestManager validateResponseData:responseObject HttpURLResponse:task.response]) {
            if (IsNilOrNull(success)) return;
            success(YES,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (hud) [hud hideAnimated:YES];
        if (show && view) [MBProgressHUD zj_showViewAfterSecondWithView:view title:error.localizedDescription afterSecond:delay];
        wLog(@"error = %@",error);
        if (failure) failure(error);
    }];
}

- (void)get:(NSString *)path paramters:(NSDictionary *)paramters success:(void (^)(BOOL, id))success failure:(void (^)(NSError *))failure {
    [self get:path paramters:paramters success:success failure:failure superView:nil showFaliureDescription:nil];
}

- (void)get:(NSString *)path paramters:(NSDictionary *)paramters success:(void (^)(BOOL, id))success failure:(void (^)(NSError *))failure superView:(UIView *)view {
    [self get:path paramters:paramters success:success failure:failure superView:view showFaliureDescription:nil];
}

#pragma mark - POST 传送网络数据
/**
 *  传送网络数据
 *
 *  @param path           请求的地址
 *  @param paramters      请求的参数
 *  @param success        请求成功的回调
 *  @param failure        请求失败的回调
 */
- (NSURLSessionDataTask *)post:(NSString *)path
                     paramters:(NSDictionary *)paramters
                       success:(void(^) (BOOL isSuccess, id responseObject))success
                       failure:(void(^) (NSError *error))failure
                     superView:(UIView *)view
        showFaliureDescription:(BOOL)show{
    
    MBProgressHUD *hud;
    if (view) hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    NSURLSessionDataTask *task = [self POST:path parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (hud) [hud hideAnimated:YES];
        
        wLog(@"responseObject = %@",responseObject);
        
        if ([HTTPRequestManager validateResponseData:responseObject HttpURLResponse:task.response]) {
            if (IsNilOrNull(success)) return;
            success(YES,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (hud) [hud hideAnimated:YES];
        if (show && view) [MBProgressHUD zj_showViewAfterSecondWithView:view title:error.localizedDescription afterSecond:delay];
        wLog(@"error = %@",error);
        if (failure) failure(error);
    }];
    
    return task;
}


#pragma mark - POST 传送网络数据
/**
 *  传送网络数据
 *
 *  @param path           请求的地址
 *  @param paramters      请求的参数
 *  @param success        请求成功的回调
 *  @param failure        请求失败的回调
 */
- (NSURLSessionDataTask *)post:(NSString *)path
                     paramters:(NSDictionary *)paramters
                      success:(void(^) (BOOL isSuccess, id responseObject))success
                      failure:(void(^) (NSError *error))failure{
    
    return [self post:path paramters:paramters success:success failure:failure superView:nil showFaliureDescription:NO];
}

- (NSURLSessionDataTask *)post:(NSString *)path
                     paramters:(NSDictionary *)paramters
                     success:(void(^) (BOOL isSuccess, id responseObject))success
                     failure:(void(^) (NSError *error))failure
                   superView:(UIView *)view{
    
    return [self post:path paramters:paramters success:success failure:failure superView:view showFaliureDescription:NO];
}



#pragma mark POST 上传图片
/**
 *  上传图片
 *
 *  @param path           上传的地址---需要填写完整的url
 *  @param paramters      上传图片预留参数---视具体情况而定，可移除
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
                      failure:(void(^) (NSError *error))failure {
    
    [[HTTPRequestManager shareManager] POST:path parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSUInteger i = 0 ;
        
        // 上传图片时，为了用户体验或是考虑到性能需要进行压缩
        for (UIImage *image in imageArray) {
            
            // 压缩图片，指定宽度
            UIImage *resizedImage =  [UIImage imageCompressed:image withdefineWidth:width];
            NSData *imgData = UIImageJPEGRepresentation(resizedImage, 0.5);
            // 拼接Data
            [formData appendPartWithFileData:imgData name:[NSString stringWithFormat:@"picflie%ld",(long)i] fileName:@"image.png" mimeType:@" image/jpeg"];
            i++;
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        wLog(@"downLoadProcess = %@",uploadProgress);
        if (uploadProgress) {
            upLoadProgress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        wLog(@"responseObject = %@",responseObject);
        if (success) {
            success(YES,responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        wLog(@"error = %@",error);
        if (failure) {
            failure(error);
        }
    }];;
    
}

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
                      failure:(void(^) (NSError *error))failure {
    
    // 获取视频资源
    AVURLAsset * avUrlAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:videoPath]];
    // 视频压缩
    //    NSString *const AVAssetExportPreset640x480;
    //    NSString *const AVAssetExportPreset960x540;
    //    NSString *const AVAssetExportPreset1280x720;
    //    NSString *const AVAssetExportPreset1920x1080;
    //    NSString *const AVAssetExportPreset3840x2160;
    
    AVAssetExportSession  *  avAssetExport = [[AVAssetExportSession alloc] initWithAsset:avUrlAsset presetName:AVAssetExportPreset640x480];
    // 获取上传的时间
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    // 转化后直接写入Library---caches
    NSString *  videoWritePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/output-%@.mp4",[formatter stringFromDate:[NSDate date]]]];
    avAssetExport.outputURL = [NSURL URLWithString:videoWritePath];
    avAssetExport.outputFileType =  AVFileTypeMPEG4;
    [avAssetExport exportAsynchronouslyWithCompletionHandler:^{
        
        switch ([avAssetExport status]) {
                
            case AVAssetExportSessionStatusCompleted:
            {
                
                [[HTTPRequestManager shareManager] POST:path parameters:paramters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    //获得沙盒中的视频内容
                    
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:videoWritePath] name:@"write you want to writre" fileName:videoWritePath mimeType:@"video/mpeg4" error:nil];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                    wLog(@"downLoadProcess = %@",uploadProgress);
                    if (uploadProgress) {
                        upLoadProgress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                    }
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                    
                    wLog(@"responseObject = %@",responseObject);
                    if (success) {
                        success(YES,responseObject);
                    }
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    wLog(@"responseObject = %@",error);
                    if (failure) {
                        failure(error);
                    }
                }];
                
                break;
            }
            default:
                break;
        }
    }];
}

#pragma mark DOWNLOAD 文件下载
- (void)requestDownLoadDataWithPath:(NSString *)path
                      withParamters:(NSDictionary *)paramters
                       withSavaPath:(NSString *)savePath
                       withProgress:(void(^) (float progress))downLoadProgress
                            success:(void(^) (BOOL isSuccess, id responseObject))success
                            failure:(void(^) (NSError *error))failure {
    
    [[HTTPRequestManager shareManager] downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]] progress:^(NSProgress * _Nonnull downloadProgress) {
        
        wLog(@"downLoadProcess = %@",downLoadProgress);
        if (downloadProgress) {
            downLoadProgress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return  [NSURL URLWithString:savePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            failure(error);
        }
        
    }];
}

#pragma mark - DELETE 删除资源
- (void)requestDELETEDataWithPath:(NSString *)path
                    withParamters:(NSDictionary *)paramters
                          success:(void (^) (BOOL isSuccess, id responseObject))success
                          failure:(void (^) (NSError *error))failure {
    
    [[HTTPRequestManager  shareManager] DELETE:path parameters:paramters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        wLog(@"success %@",success);
        if (success) {
            success(YES,success);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        wLog(@"failure %@",error);
        if (failure) {
            failure(error);
        }
    }];
    
}

#pragma mark - PUT 更新全部属性
- (void)sendPUTDataWithPath:(NSString *)path
              withParamters:(NSDictionary *)paramters
                    success:(void(^) (BOOL isSuccess, id responseObject))success
                    failure:(void(^) (NSError *error))failure {
    
    [[HTTPRequestManager shareManager] PUT:path parameters:paramters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        wLog(@"success %@",success);
        if (success) {
            success(YES,success);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        wLog(@"failure %@",error);
        if (failure) {
            failure(error);
        }
    }];
}

#pragma  mark - PATCH 改变资源状态或更新部分属性
- (void)sendPATCHDataWithPath:(NSString *)path
                withParamters:(NSDictionary *)paramters
                      success:(void (^) (BOOL isSuccess, id responseObject))success
                      failure:(void (^) (NSError *error))failure {
    [[HTTPRequestManager shareManager] PATCH:path parameters:paramters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        wLog(@"success %@",success);
        if (success) {
            success(YES,success);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        wLog(@"failure %@",error);
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 取消网络请求--全部请求
- (void)cancelAllNetworkRequest {
    
    [[HTTPRequestManager shareManager].operationQueue cancelAllOperations];
}

#pragma mark - 取消网络请求--指定请求
/**
 *  取消指定的url请求
 *
 *  @param type 该请求的请求类型
 *  @param path 该请求的完整url
 */
- (void)cancelHttpRequestWithType:(NSString *)type WithPath:(NSString *)path {
    
    NSError * error;
    // 根据请求的类型 以及 请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求
    NSString *urlToPeCanced = [[[[HTTPRequestManager shareManager].requestSerializer requestWithMethod:type URLString:path parameters:nil error:&error] URL] path];
    
    for (NSOperation *operation in [HTTPRequestManager shareManager].operationQueue.operations) {
        
        // 如果是请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            
            // 请求的类型匹配
            BOOL hasMatchRequestType = [type isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            
            // 请求的url匹配
            BOOL hasMatchRequestUrlString = [urlToPeCanced isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            
            // 两项都匹配的话  取消该请求
            if (hasMatchRequestType&&hasMatchRequestUrlString) {
                [operation cancel];
            }
        }
    }
}

#pragma mark Return the data validation interfaces
+ (BOOL)validateResponseData:(id) returnData HttpURLResponse: (NSURLResponse *)response{
    //获取http 状态码
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSLog(@"HttpCode: %ld", (long)httpResponse.statusCode);
    if(httpResponse.statusCode > 300){
        return NO;
    }
    return YES;
}
@end
