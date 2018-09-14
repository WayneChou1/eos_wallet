//
//  WalletChangePSWViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/9/14.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "WalletChangePSWViewController.h"
#import "InputTextField.h"
#import "WalletManager.h"
#import "MD5Encrypt.h"

@interface WalletChangePSWViewController ()

@property (weak, nonatomic) IBOutlet InputTextField *currentTF;
@property (weak, nonatomic) IBOutlet InputTextField *NewTF;
@property (weak, nonatomic) IBOutlet InputTextField *RepeatTF;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;

@property (strong, nonatomic) Wallet *wallet;
@end

@implementation WalletChangePSWViewController

- (instancetype)initWithWallet:(Wallet *)wallet {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.wallet = wallet;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"修改密码");
    [self setUpSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpSubviews {
    self.currentTF.textField.placeholder = kLocalizable(@"当前密码");
    self.currentTF.shadowColor = kMain_Color;
    self.currentTF.cornerRadius = 5.0;
    self.currentTF.textField.keyboardType = UIKeyboardTypeASCIICapable;
    
    self.NewTF.textField.placeholder = kLocalizable(@"新密码");
    self.NewTF.textField.secureTextEntry = YES;
    self.NewTF.shadowColor = kMain_Color;
    self.NewTF.cornerRadius = 5.0;
    self.NewTF.textField.keyboardType = UIKeyboardTypeASCIICapable;
    
    self.RepeatTF.textField.placeholder = kLocalizable(@"重复新密码");
    self.RepeatTF.textField.secureTextEntry = YES;
    self.RepeatTF.shadowColor = kMain_Color;
    self.RepeatTF.cornerRadius = 5.0;
    self.RepeatTF.textField.keyboardType = UIKeyboardTypeASCIICapable;
    
    [self.changeBtn setTitle:kLocalizable(@"修改") forState:UIControlStateNormal];
}


#pragma mark - btnOnClick

- (IBAction)changeBtnOnClick:(UIButton *)sender {
    
    /* 判空 */
    if (IsStrEmpty(self.currentTF.textField.text)) {
        [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"密码不能为空!") afterSecond:1.5];
        return;
    }
    if (IsStrEmpty(self.NewTF.textField.text)) {
        [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"密码不能为空!") afterSecond:1.5];
        return;
    }
    if (IsStrEmpty(self.RepeatTF.textField.text)) {
        [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"密码不能为空!") afterSecond:1.5];
        return;
    }
    
    /* check */
    if (![self.wallet.walletMD5pwd isEqualToString:[MD5Encrypt MD5ForLower32Bate:self.currentTF.textField.text isSalt:YES]]) {
        [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"旧密码错误") afterSecond:1.5];
        return;
    }
    
    if (![self.NewTF.textField.text isEqualToString:self.RepeatTF.textField.text]) {
        [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"两次输入的密码不一致!") afterSecond:1.5];
        return;
    }
    
    NSString *password = [MD5Encrypt MD5ForLower32Bate:self.NewTF.textField.text isSalt:YES];
    self.wallet.walletMD5pwd = password;
    if ([[WalletManager shareManager] updateWallet:self.wallet]) {
        [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"修改密码成功") afterSecond:1.5];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"修改密码失败") afterSecond:1.5];
    }
}

@end
