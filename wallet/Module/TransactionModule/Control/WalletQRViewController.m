//
//  WalletQRViewController.m
//  wallet
//
//  Created by 周志伟 on 2018/8/20.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "WalletQRViewController.h"
#import "QRModalTransition.h"
#import "QRModelPanInteractiveTransition.h"
#import "WalletQRView.h"

static CGFloat alpha = 0.9;

//static CGFloat qrViewHeight = 475.0;
//static CGFloat qrViewOffset = 20.0;

@interface WalletQRViewController () <UIViewControllerTransitioningDelegate>

@property (strong, nonatomic) UIVisualEffectView *visualView;
@property (strong, nonatomic) WalletQRView *qrView;
@property (copy, nonatomic) NSString *account;

@property (strong, nonatomic) QRModalTransition *presentTransition;
@property (strong, nonatomic) QRModalTransition *dismissTransition;
@property (strong, nonatomic) QRModelPanInteractiveTransition *percentTransition;

@end

@implementation WalletQRViewController

- (void)dealloc {
    
}

- (instancetype)initWithAccount:(NSString *)account {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.account = account;
        
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.presentTransition = [QRModalTransition transitionWithType:kQRModalTransitionPresent duration:duration];
        self.dismissTransition = [QRModalTransition transitionWithType:kQRModalTransitionDismiss duration:duration];
        self.percentTransition = [[QRModelPanInteractiveTransition alloc] init];
        
        WEAK_SELF(weakSelf);
        [self.percentTransition panToDismiss:self handler:^(UIPanGestureRecognizer *gesture) {
            if (weakSelf.qrView) {
                [weakSelf.qrView panGestureAction:gesture];
            }
        }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self setUpSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpSubviews {

    // 设置毛玻璃背景
    self.visualView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.visualView.alpha = 0.0; // 控制模糊程度
    self.visualView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.visualView];
    
    [self.visualView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    UIVibrancyEffect *vibrancyView = [UIVibrancyEffect effectForBlurEffect:(UIBlurEffect *)self.visualView.effect];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyView];
    visualEffectView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.visualView.contentView addSubview:visualEffectView];
    
    // 设置二维码
    self.qrView = [[WalletQRView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) codeString:self.account];
    [self.view addSubview:self.qrView];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.presentTransition;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dismissTransition;
}

- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return self.percentTransition.interactiveDismiss ? self.percentTransition : nil;
}

#pragma mark - public

- (void)show:(NSTimeInterval)duration present:(BOOL)present completion:(void(^)(void))completion{
    
    if (present) [self.qrView showQRWithDuration:duration isShow:YES];
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.visualView.alpha = alpha;
    } completion:^(BOOL finished) {
        if (finished) {
            if (completion) {
                completion();
            }
        }
    }];
}

- (void)dismiss:(NSTimeInterval)duration completion:(void (^)(void))completion {
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.visualView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            if (completion) {
                completion();
            }
        }
    }];
}

- (void)panViewController:(CGFloat)percent {
    self.visualView.alpha = (1 - percent)*0.9;
}


@end
