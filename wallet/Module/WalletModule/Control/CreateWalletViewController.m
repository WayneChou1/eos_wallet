//
//  CreateWalletViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/18.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "CreateWalletViewController.h"
#import "ImportAccountViewController.h"
#import "InputTextField.h"
#import "Wallet.h"
#import "WalletManager.h"
#import "MD5Encrypt.h"

@interface CreateWalletViewController ()

@property (weak, nonatomic) IBOutlet InputTextField *walletNameTF;
@property (weak, nonatomic) IBOutlet InputTextField *walletPasswordTF;
@property (weak, nonatomic) IBOutlet InputTextField *walletConfirmTF;
@property (weak, nonatomic) IBOutlet InputTextField *walletHintTF;

@property (weak, nonatomic) IBOutlet UIButton *createBtn;

@end

@implementation CreateWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"创建钱包");
    [self setUpSubViews];
    [self setUpNav];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)setUpSubViews {
    self.walletNameTF.textField.placeholder = kLocalizable(@"钱包名称");
    self.walletNameTF.shadowColor = kMain_Color;
    self.walletNameTF.cornerRadius = 5.0;
    self.walletNameTF.textField.keyboardType = UIKeyboardTypeASCIICapable;
    
    self.walletPasswordTF.textField.placeholder = kLocalizable(@"钱包密码");
    self.walletPasswordTF.shadowColor = kMain_Color;
    self.walletPasswordTF.cornerRadius = 5.0;
    self.walletPasswordTF.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.walletPasswordTF.textField.secureTextEntry = YES;
    
    self.walletConfirmTF.textField.placeholder = kLocalizable(@"请确认钱包密码");
    self.walletConfirmTF.shadowColor = kMain_Color;
    self.walletConfirmTF.cornerRadius = 5.0;
    self.walletConfirmTF.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.walletConfirmTF.textField.secureTextEntry = YES;
    
    self.walletHintTF.textField.placeholder = kLocalizable(@"请输入密码提示");
    self.walletHintTF.shadowColor = kMain_Color;
    self.walletHintTF.cornerRadius = 5.0;
    
    [self.createBtn setTitle:kLocalizable(@"创建钱包") forState:UIControlStateNormal];
}


- (void)setUpNav {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Wallet.bundle/wallet/wallet_close"] style:0 target:self action:@selector(closeItemOnClick:)];
}


#pragma mark - 更新钱包到数据库

- (void)creatrWallet:(void(^)(BOOL success, NSString *walletUUID))success {
    
    NSString *password = [MD5Encrypt MD5ForLower32Bate:self.walletPasswordTF.textField.text isSalt:YES];
    NSString *UUID = [NSUUID UUID].UUIDString;
    
    Wallet *model = [[Wallet alloc] init];
    model.walletName = self.walletNameTF.textField.text;
    model.walletMD5pwd = password;
    model.walletUUID = UUID;
    model.createTime = [NSDate date];
    model.pswHint = self.walletHintTF.textField.text;
    BOOL ret = [[WalletManager shareManager] insertWallets:@[model]];
    
    if (success) {
        success(ret,UUID);
    }
}

- (void)gotoImportKeys {
    ImportAccountViewController *importVC = [[ImportAccountViewController alloc] init];
    [self.navigationController pushViewController:importVC animated:YES];
}


#pragma mark - btnOnClick

- (IBAction)createBtnOnClick:(UIButton *)sender {
    if (IsStrEmpty(self.walletNameTF.textField.text)) {
        [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"钱包名称不能为空!") afterSecond:1.5];
        return;
    }
    if (IsStrEmpty(self.walletPasswordTF.textField.text)) {
        [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"密码不能为空!") afterSecond:1.5];
        return;
    }
    if (![self.walletPasswordTF.textField.text isEqualToString:self.walletConfirmTF.textField.text]) {
        [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"两次输入的密码不一致!") afterSecond:1.5];
        return;
    }
    
    // 查重本地钱包名不可重复
    NSArray <Wallet *> *walletsArr = [[WalletManager shareManager] selectAllWallets];
    for (Wallet *model in walletsArr) {
        if ([model.walletName isEqualToString:self.walletNameTF.textField.text]) {
            [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"本地钱包名不可重复!") afterSecond:1.5];
            return;
        }
    }
    
    [self creatrWallet:^(BOOL success, NSString *walletUUID) {
        if (success) {
            [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"创建成功！") afterSecond:1.5];
            
            // 保存uuid，作为最新钱包
            [kUserDefault setObject:walletUUID forKey:kCurrent_wallet];
            
            [self performSelector:@selector(gotoImportKeys) withObject:nil afterDelay:1.5];
        }
    }];
}

- (void)closeItemOnClick:(UIBarButtonItem *)item {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
