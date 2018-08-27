//
//  ScanQRViewController.m
//  wallet
//
//  Created by 周志伟 on 2018/8/26.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "ScanQRViewController.h"
#import "EditorView.h"
#import "UIImage+Color.h"
#import <AVKit/AVKit.h>

static const char *scan_qr_code_queueName = "scanQRCodeQueueName";
static NSString * const scan_line_move    = @"scanLineMove";

@interface ScanQRViewController ()<AVCaptureMetadataOutputObjectsDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,ScanEditorDelegate>

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//设置输出类型为Metadata，因为这种输出类型中可以设置扫描的类型，譬如二维码
//当启动摄像头开始捕获输入时，如果输入中包含二维码，就会产生输出
@property(nonatomic)AVCaptureMetadataOutput *output;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic,strong)  UIView *viewPreview;
@property (nonatomic,strong) EditorView *boxView;
@property (nonatomic,strong) CALayer *scanLayer;
@property (nonatomic,assign)BOOL isCanReq;

@end

@implementation ScanQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBar];
    [self setNav];
    [self setUpSubview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //页面已经出现时，开始识别
    [self startReading];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //离开界面是，停止识别
    [self stopReading];
}


#pragma mark - 初始化界面

-(void)setUpSubview{
    
    //预览图层
    _viewPreview = [[UIView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_viewPreview];
    [self.view sendSubviewToBack:_viewPreview];
    
    if (![self creatCaptureDevice]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"相机权限已关闭，请到设置中打开" preferredStyle:UIAlertControllerStyleAlert];
        
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
    }
    
    //扫描框
    _boxView = [[EditorView alloc] initWithFrame:CGRectMake(_viewPreview.bounds.size.width * 0.1f, _viewPreview.bounds.size.height * 0.2f, _viewPreview.bounds.size.width * 0.8, _viewPreview.bounds.size.width * 0.8)];
    _boxView.backgroundColor = [UIColor clearColor];
    _boxView.delegate = self;
    [_viewPreview addSubview:_boxView];
    
    //扫描线
    _scanLayer = [[CALayer alloc] init];
    _scanLayer.frame = CGRectMake(0, 0, _boxView.bounds.size.width, 1);
    _scanLayer.backgroundColor = kMain_Color.CGColor;
    
    [_boxView.layer addSublayer:_scanLayer];
    
    [self moveScanLayer];
    
    //黑色透明图层
    UIView *viewTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _boxView.frame.origin.y)];
    viewTop.backgroundColor = [UIColor blackColor];
    viewTop.alpha = 0.5;
    [_viewPreview addSubview:viewTop];
    
    UIView *viewLeft = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(viewTop.frame), _boxView.frame.origin.x, CGRectGetHeight(_boxView.frame))];
    viewLeft.backgroundColor = [UIColor blackColor];
    viewLeft.alpha = 0.5;
    [_viewPreview addSubview:viewLeft];
    
    UIView *viewRight = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_boxView.frame), CGRectGetMaxY(viewTop.frame), _boxView.frame.origin.x, CGRectGetHeight(viewLeft.frame))];
    viewRight.backgroundColor = [UIColor blackColor];
    viewRight.alpha = 0.5;
    [_viewPreview addSubview:viewRight];
    
    
    UIView *viewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_boxView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(_boxView.frame))];
    viewBottom.backgroundColor = [UIColor blackColor];
    viewBottom.alpha = 0.5;
    [_viewPreview addSubview:viewBottom];
}

- (void)setNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Wallet.bundle/wallet/wallet_close"] style:0 target:self action:@selector(closeItemOnClick:)];
}

- (void)setNavigationBar {
    // 设置导航栏透明
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.subviews.firstObject.alpha = 0.0;
}

- (BOOL)creatCaptureDevice{
    
    NSError *error;
    
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!input) {
        wLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    [videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    //4.实例化捕捉会话
    self.session = [[AVCaptureSession alloc] init];
    
    //4.1.将输入流添加到会话
    [self.session addInput:input];
    
    //4.2.将媒体输出流添加到会话中
    if (captureMetadataOutput) {
        [self.session addOutput:captureMetadataOutput];
        NSMutableArray *a = [[NSMutableArray alloc] init];
        
        if ([captureMetadataOutput.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        
        if ([captureMetadataOutput.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        
        if ([captureMetadataOutput.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        
        if ([captureMetadataOutput.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        captureMetadataOutput.metadataObjectTypes = a;
    }
    
    if (videoOutput) {
        [self.session addOutput:videoOutput];
    }
    
    
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create(scan_qr_code_queueName, NULL);
    //5.1.设置代理
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //5.2.设置输出媒体数据类型为QRCode
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //6.实例化预览图层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    
    //7.设置预览图层填充方式
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    //8.设置图层的frame
    [self.previewLayer setFrame:_viewPreview.layer.bounds];
    
    //9.将图层添加到预览view的图层上
    [_viewPreview.layer addSublayer:self.previewLayer];
    
    //10.设置扫描范围
    CGRect rect = CGRectMake (0.1f,0.1f, SCREEN_WIDTH * 0.8f/SCREEN_HEIGHT,0.8f);
    
    captureMetadataOutput.rectOfInterest = rect;
    
    //10.开始扫描
    [self.session startRunning];
    
    return YES;
}

- (void)moveScanLayer {
    
    CGFloat x = _scanLayer.position.x;
    
    //位置变化
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(x,CGRectGetHeight(_boxView.frame))];
    moveAnimation.repeatCount = MAXFLOAT;
    moveAnimation.duration = 2;
    //透明度变化
    CABasicAnimation * opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.1];
    opacityAnimation.duration = 2;
    opacityAnimation.repeatCount = MAXFLOAT;
    
    CAAnimationGroup *groupAnnimation = [CAAnimationGroup animation];
    groupAnnimation.duration = 2;
    //    groupAnnimation.autoreverses = YES;
    groupAnnimation.animations = @[moveAnimation, opacityAnimation];
    groupAnnimation.repeatCount = MAXFLOAT;
    [self.scanLayer addAnimation:groupAnnimation forKey:scan_line_move];
}

-(void)startReading{
    self.isCanReq = YES;
    self.scanLayer.opacity = 1.;
    [self moveScanLayer];
}


-(void)stopReading{
    self.isCanReq = NO;
    [self.scanLayer removeAnimationForKey:scan_line_move];
    self.scanLayer.opacity = 0.;
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
//metadataObjects ：把识别到的内容放到该数组中
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    //停止扫描
    [self.session stopRunning];
    if ([metadataObjects count] >= 1) {
        //数组中包含的都是AVMetadataMachineReadableCodeObject 类型的对象，该对象中包含解码后的数据
        AVMetadataMachineReadableCodeObject *qrObject = [metadataObjects lastObject];
        //拿到扫描内容在这里进行个性化处理
        NSLog(@"识别成功%@",qrObject.stringValue);
    }
}

#pragma mark AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    
    wLog(@"%f",brightnessValue);
    
    // 根据brightnessValue的值来打开和关闭闪光灯
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    BOOL result = [device hasTorch];
    // 判断设备是否有闪光灯
    if ((brightnessValue < 0) && result) {
        [_boxView showLightBtn];
    }else if((brightnessValue > 0) && result) {
        // 如果已经开启，不隐藏按钮
        if (!device.torchActive) {
            [_boxView hidLightBtn];
        }
    }
}

#pragma mark - ScanEditorDelegate
- (void)light:(BOOL)on {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (on) {
        // 打开闪光灯
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOn];
        //开
        [device unlockForConfiguration];
    }else{
        // 关闭闪光灯
        [device lockForConfiguration:nil];
        [device setTorchMode: AVCaptureTorchModeOff];
        //关
        [device unlockForConfiguration];
    }
}

#pragma mark - btnOnClick

- (void)closeItemOnClick:(UIBarButtonItem *)item {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
