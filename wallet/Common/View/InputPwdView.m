//
//  InputPwdView.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/26.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "InputPwdView.h"
#import "WalletManager.h"
#import "MD5Encrypt.h"

@interface InputPwdView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *pswTF;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (assign, nonatomic) CGRect originalFrame;
@property (assign, nonatomic) CGSize superViewSize;

@property (copy, nonatomic) InputPwdHandler handler;

@end

@implementation InputPwdView

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
        [self setUpSubview];
        [self setNoti];
        [IQKeyboardManager sharedManager].enable = NO;
    }
    return self;
}

- (void)setUpSubview {
    
    // 透明，缩放，以做显示动画
    self.alpha = 0;
    self.backgroundColor = [UIColor clearColor];
    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    // 设置阴影
    self.layer.shadowColor = [UIColor blackColor].CGColor;//设置阴影的颜色
    self.layer.shadowOpacity = 0.2;//设置阴影的透明度
    self.layer.shadowOffset = CGSizeMake(1, 1);//设置阴影的偏移量
    self.layer.shadowRadius = 3;//设置阴影的圆角
    
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    self.titleLab.text = kLocalizable(@"请输入钱包密码");
    self.pswTF.placeholder = kLocalizable(@"请输入钱包密码");
    [self.confirmBtn setTitle:kLocalizable(@"确定") forState:UIControlStateNormal];
    [self.cancelBtn setTitle:kLocalizable(@"取消") forState:UIControlStateNormal];
}

- (void)showInView:(UIView *)view handler:(InputPwdHandler)handler{
    
    self.handler = handler;
    
    // 设置frame,并添加到父视图
    self.center = view.center;
    [view addSubview:self];
    
    self.superViewSize = view.frame.size;
    
    [self show];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
}

#pragma mark - 监听

- (void)setNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - 显示与消失动画

- (void)show {
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        // 保存frame
        self.originalFrame = self.frame;
    }];
}

- (void)hidden {
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
        self.transform = CGAffineTransformMakeScale(0.5, 0.5);;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 键盘通知

- (void)keybordWillShow:(NSNotification *)noti{
    
    CGRect keybordRect = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    double duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat offset = 10.;
    
//    wLog(@"height ===================== %f",self.frame.size.height/2. + SCREEN_HEIGHT/2. + keybordRect.size.height + offset);
//    wLog(@"superView height ============= %f",self.superViewSize.height);
    
    if (SCREEN_HEIGHT < self.frame.size.height/2. + SCREEN_HEIGHT/2. + keybordRect.size.height + offset) {
        [UIView animateWithDuration:duration animations:^{
            CGRect frame = self.frame;
            self.frame = CGRectMake(frame.origin.x, frame.origin.y + (SCREEN_HEIGHT - (self.frame.size.height/2. + SCREEN_HEIGHT/2. + keybordRect.size.height)) - offset, frame.size.width, frame.size.height);
            [self layoutIfNeeded];
        }];
    }
}


- (void)keybordWillHidden:(NSNotification *)noti{
    double duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.frame = self.originalFrame;
    }];
}


#pragma mark - btnOnClick

- (IBAction)cancelBtnOnClick:(UIButton *)sender {
    if (self.handler) {
        self.handler(YES, YES, nil);
    }
    [self hidden];
}

- (IBAction)confirmBtnOnClick:(UIButton *)sender {
    
    if (!self.pswTF.hasText) return;
    
    // 确认密码对不对
    Wallet *wallet = kCurrentWallet;
    NSString *encryptStr = [MD5Encrypt MD5ForLower32Bate:self.pswTF.text isSalt:YES];
    
    wLog(@"walletMD5pwd ==== %@",wallet.walletMD5pwd);
    
    if ([wallet.walletMD5pwd isEqualToString:encryptStr]) {
        [self hidden];
        if (self.handler) {
            self.handler(YES, NO, self.pswTF.text);
        }
    }else{
        [MBProgressHUD zj_showViewAfterSecondWithView:[UIApplication sharedApplication].keyWindow title:kLocalizable(@"密码错误") afterSecond:1.5];
    }
}

@end
