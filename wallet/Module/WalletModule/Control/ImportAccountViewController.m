//
//  ImportAccountViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/26.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "ImportAccountViewController.h"
#import "InputPwdView.h"
#import "InputTextField.h"
#import "NSString+Hash.h"
#import "NSString+RegularExp.h"
#import "AccountInfo.h"
#import "Account.h"
#import "AccountManager.h"
#import "AESCrypt.h"

@interface ImportAccountViewController (){
    NSString *_psw;
}

@property (weak, nonatomic) IBOutlet InputTextField *accountTF;
@property (weak, nonatomic) IBOutlet InputTextField *ownerTF;
@property (weak, nonatomic) IBOutlet InputTextField *activeTF;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *contentView;
@end

@implementation ImportAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"导入私钥");
    [self setUpSubviews];
    
    // 默认选中
    self.selectBtn.selected = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)setUpSubviews {
    [self.selectBtn setImage:[UIImage imageNamed:@"Wallet.bundle/wallet/unselect"] forState:UIControlStateNormal];
    [self.selectBtn setImage:[UIImage imageNamed:@"Wallet.bundle/wallet/select"] forState:UIControlStateSelected];
    
    [self.agreeBtn setTitle:kLocalizable(@"我已经仔细阅读并同意服务及隐私条款") forState:UIControlStateNormal];
    [self.createBtn setTitle:kLocalizable(@"导入") forState:UIControlStateNormal];
    
    self.accountTF.textField.placeholder = kLocalizable(@"输入账号");
    self.accountTF.shadowColor = kMain_Color;
    self.accountTF.cornerRadius = 5.0;
    self.accountTF.textField.keyboardType = UIKeyboardTypeASCIICapable;
    
    self.ownerTF.textField.placeholder = kLocalizable(@"输入ownerkey");
    self.ownerTF.shadowColor = kMain_Color;
    self.ownerTF.cornerRadius = 5.0;
    self.ownerTF.textField.keyboardType = UIKeyboardTypeASCIICapable;
    
    self.activeTF.textField.placeholder = kLocalizable(@"输入activekey");
    self.activeTF.shadowColor = kMain_Color;
    self.activeTF.cornerRadius = 5.0;
    self.activeTF.textField.keyboardType = UIKeyboardTypeASCIICapable;
}

#pragma mark - btnOnClcik

- (IBAction)selectBtnOnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
}

- (IBAction)agreeBtnOnClick:(UIButton *)sender {
}

- (IBAction)importBtnOnClick:(UIButton *)sender {
    if (!self.selectBtn.selected) {
        [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"请先勾选同意条款") afterSecond:1.5];
        return;
    }
    
    WEAK_SELF(weakSelf)
    InputPwdView *inputView = [[InputPwdView alloc]initWithFrame:CGRectMake(0, 0, inputViewWidth, inputViewHeight)];
    [inputView showInView:self.view handler:^(BOOL pwdValied, BOOL isCanceled, NSString *psw) {
        if (!isCanceled) {
            if (pwdValied) {
                self->_psw = psw;
                [weakSelf validateAccount];
            }
        }
    }];
}

- (void)validateAccount {
    if (![EosValidate validateAccount:self.accountTF.textField.text]) {
        [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"账号名输入错误") afterSecond:1.5];
        return;
    }
    
    wLog(@"active key ====== %@",self.activeTF.textField.text);
    wLog(@"owner key ====== %@",self.ownerTF.textField.text);
    
    if (![EosValidate validateWif:self.activeTF.textField.text] || ![EosValidate validateWif:self.ownerTF.textField.text]) {
        [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"私钥格式有误") afterSecond:1.5];
        return;
    }
    
    [self checkPublicKey];
}

- (void)checkPublicKey {
    NSString *public_active_key = [EosEncode eos_publicKey_with_wif:self.activeTF.textField.text];
    NSString *public_owner_key = [EosEncode eos_publicKey_with_wif:self.ownerTF.textField.text];
    
    __block BOOL validateOwnerKey = NO;
    __block BOOL validateAcitveKey = NO;
    
    wLog(@"public_active_key == %@ \n public_owner_key == %@",public_active_key,public_owner_key);
    
    NSDictionary *dic = @{@"account_name":VALIDATE_STRING(self.accountTF.textField.text)};
    [[HTTPRequestManager shareManager] post:eos_get_account paramters:dic success:^(BOOL isSuccess, id responseObject) {
        if (isSuccess) {
            AccountInfo *info = [AccountInfo yy_modelWithJSON:responseObject];
            // 判断公钥是否相等
            for (Permission *p in info.permissions) {
                if ([p.perm_name isEqualToString:@"owner"]) {
                    if (p.required_auth.keys.count > 0) {
                        if ([p.required_auth.keys.firstObject.key isEqualToString:public_owner_key]) {
                            validateOwnerKey = YES;
                        }
                    }
                }
                
                if ([p.perm_name isEqualToString:@"active"]) {
                    if (p.required_auth.keys.count > 0) {
                        if ([p.required_auth.keys.firstObject.key isEqualToString:public_active_key]) {
                            validateAcitveKey = YES;
                        }
                    }
                }
            }
            
            if (!validateOwnerKey) {
                [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"Owner key 输入有误") afterSecond:1.5];
                return;
            }
            
            if (!validateAcitveKey) {
                [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"Active key 输入有误") afterSecond:1.5];
                return;
            }
            [self insertAccount:self.accountTF.textField.text ownerPublicKey:public_owner_key ownerPrivateKey:self.ownerTF.textField.text activePublicKey:public_active_key activePrivateKey:self.activeTF.textField.text];
        }
    } failure:nil superView:self.view showFaliureDescription:YES];
}


- (void)insertAccount:(NSString *)accountName
       ownerPublicKey:(NSString *)ownerPublicKey
      ownerPrivateKey:(NSString *)ownerPrivateKey
      activePublicKey:(NSString *)activePublicKey
     activePrivateKey:(NSString *)activePrivateKey{
    // 私钥、账号入库
    Account *account = [[Account alloc]init];
    account.accountName = accountName;
    account.ownerPublickKey = ownerPublicKey;
    account.ownerPrivatekKey = [AESCrypt encrypt:ownerPrivateKey password:_psw];
    account.activePublickKey = activePublicKey;
    account.activePrivatekKey = [AESCrypt encrypt:activePrivateKey password:_psw];
    account.walletID = kCurrentWallet_UUID;
    
    [[AccountManager shareManager] insertAccounts:@[account]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
