//
//  WalletSendViewController.m
//  wallet
//
//  Created by 周志伟 on 2018/8/20.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "WalletSendViewController.h"
#import "ExchangeDetailViewController.h"
#import "ScanQRViewController.h"
#import "NavigationViewController.h"
#import "InputTextField.h"
#import "InputPwdView.h"
#import "AccountManager.h"
#import "BlockChain.h"
#import "NSDate+ExFoundation.h"
#import "NSData+CommonCrypto.h"
#import "NSObject+Extension.h"
#import "AESCrypt.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface WalletSendViewController ()

@property (weak, nonatomic) IBOutlet InputTextField *receiverTF;
@property (weak, nonatomic) IBOutlet InputTextField *amountTF;
@property (weak, nonatomic) IBOutlet InputTextField *memoTF;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (strong, nonatomic) Account *account;
@property (nonatomic, strong) JSContext *context;
@property (nonatomic, copy) NSString *ref_block_prefix;
@property (nonatomic, copy) NSString *ref_block_num;
@property (nonatomic, strong) NSData *chain_Id;
@property (nonatomic, copy) NSString *expiration;
@property (nonatomic, copy) NSString *required_Publickey;
@property (nonatomic, copy) NSString *binargs;

@property (nonatomic, copy) NSString *password;

@end

@implementation WalletSendViewController

- (instancetype)initWithAccount:(Account *)account {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.account = account;
        self.title = @"EOS";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalizable(@"转账");
    [self setUpSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpSubViews {
    self.receiverTF.textField.placeholder = kLocalizable(@"转账账号");
    self.receiverTF.shadowColor = kMain_Color;
    self.receiverTF.cornerRadius = 5.0;
    self.receiverTF.textField.keyboardType = UIKeyboardTypeASCIICapable;
    [self.receiverTF addTarget:self action:@selector(scanBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.receiverTF  setImageForActionBtn:[UIImage imageNamed:@"Wallet.bundle/transation/transation_qr"] forState:UIControlStateNormal];
    [self.receiverTF setWidthForActionBtn:40.0];
    
    self.amountTF.textField.placeholder = kLocalizable(@"填写数额");
    self.amountTF.shadowColor = kMain_Color;
    self.amountTF.cornerRadius = 5.0;
    self.amountTF.textField.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.memoTF.textField.placeholder = kLocalizable(@"添加备注");
    self.memoTF.shadowColor = kMain_Color;
    self.memoTF.cornerRadius = 5.0;
    self.memoTF.textField.keyboardType = UIKeyboardTypeASCIICapable;
    
    [self.sendBtn setTitle:kLocalizable(@"确认转账") forState:UIControlStateNormal];
}

#pragma mark - transaction

- (void)transfer {
    
    [self getBinargs:^(id response) {
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSDictionary *d = (NSDictionary *)response;
            self.binargs = [d objectForKey:@"binargs"];
            
            [self getInfoSuccess:^(id response) {
                BlockChain *model = [BlockChain yy_modelWithDictionary:response];// [@"data"]
                self.expiration = [[[NSDate dateFromString: model.head_block_time] dateByAddingTimeInterval: 30] formatterToISO8601];
                self.ref_block_num = [NSString stringWithFormat:@"%@",model.head_block_num];
                
                NSString *js = @"function readUint32( tid, data, offset ){var hexNum= data.substring(2*offset+6,2*offset+8)+data.substring(2*offset+4,2*offset+6)+data.substring(2*offset+2,2*offset+4)+data.substring(2*offset,2*offset+2);var ret = parseInt(hexNum,16).toString(10);return(ret)}";
                [self.context evaluateScript:js];
                JSValue *n = [self.context[@"readUint32"] callWithArguments:@[@8,VALIDATE_STRING(model.head_block_id) , @8]];
                self.ref_block_prefix = [n toString];
                self.chain_Id = [NSData convertHexStrToData:model.chain_id];
                wLog(@"get_block_info_success:%@, %@---%@-%@", self.expiration , self.ref_block_num, self.ref_block_prefix, self.chain_Id);
                
                [self getRequiredPublicKeyRequestOperationSuccess:^(id response) {
                    if ([response isKindOfClass:[NSDictionary class]]) {
                        self.required_Publickey = response[@"required_keys"][0];
                        [self pushTransactionRequestOperationSuccess:^(id response) {
                            if ([response isKindOfClass:[NSDictionary class]]) {
                                ExchangeDetailViewController *VC = [[ExchangeDetailViewController alloc] initWithTransactionId:[response objectForKey:@"transaction_id"]];
                                [self.navigationController pushViewController:VC animated:YES];
                            }
                        }];
                    }
                }];
            }];
        }
    }];
}

#pragma mark - 获取行动代码

- (void)getBinargs:(void(^)(id response))handler {
    
    MBProgressHUD *hud1 = [MBProgressHUD zj_showHUDAddedToView:self.view title:nil animated:YES];
    [[HTTPRequestManager shareManager] post:eos_abi_json_to_bin paramters:[self getAbiJsonToBinParamters] success:^(BOOL isSuccess, id responseObject) {
        [hud1 hideAnimated:YES];
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        [hud1 hideAnimated:YES];
    } superView:self.view showFaliureDescription:YES];
}

#pragma mark - 获取最新区块

- (void)getInfoSuccess:(void(^)(id response))handler {
    MBProgressHUD *hud2 = [MBProgressHUD zj_showHUDAddedToView:self.view title:kLocalizable(@"获取最新区块") animated:YES];
    [[HTTPRequestManager shareManager] post:eos_get_info paramters:nil success:^(BOOL isSuccess, id responseObject) {
        [hud2 hideAnimated:YES];
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        [hud2 hideAnimated:YES];
        wLog(@"URL_GET_INFO_ERROR ==== %@",error.description);
    } superView:self.view showFaliureDescription:YES];
}

#pragma mark - 获取公钥

- (void)getRequiredPublicKeyRequestOperationSuccess:(void(^)(id response))handler {
    wLog(@"URL_GET_REQUIRED_KEYS parameters ============ %@",[[self getPramatersForRequiredKeys] yy_modelToJSONString]);
    MBProgressHUD *hud3 = [MBProgressHUD zj_showHUDAddedToView:self.view title:kLocalizable(@"获取相关公钥") animated:YES];
    [[HTTPRequestManager shareManager] post:eos_get_required_keys paramters:[self getPramatersForRequiredKeys] success:^(BOOL isSuccess, id responseObject) {
        [hud3 hideAnimated:YES];
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        [hud3 hideAnimated:YES];
        wLog(@"URL_GET_REQUIRED_KEYS ==== %@",error.description);
    } superView:self.view showFaliureDescription:YES];
}

#pragma mark -

- (void)pushTransactionRequestOperationSuccess:(void(^)(id response))handler {
    
    NSDictionary *transacDic = [self getPramatersForRequiredKeys];
    
    Account *accout = [[AccountManager shareManager] selectAccountsFromAccountName:self.account.accountName];
    
    NSString *wif;
    if ([accout.ownerPublickKey isEqualToString:self.required_Publickey]) {
        wif = [AESCrypt decrypt:accout.ownerPrivatekKey password:self.password];
    }else if ([accout.activePublickKey isEqualToString:self.required_Publickey]) {
        wif = [AESCrypt decrypt:accout.activePrivatekKey password:self.password];
    }else{
        return;
    }
    
    const int8_t *private_key = [[EosEncode getRandomBytesDataWithWif:wif] bytes];
    if (!private_key) {
        [MBProgressHUD zj_showViewAfterSecondWithView:self.view title:kLocalizable(@"请检查私钥是否正确") afterSecond:1];
        return;
    }
    
    wLog(@"getPramatersForRequiredKeys ============= %@",[self getPramatersForRequiredKeys]);
    
    NSData *d = [EosByteWriter getBytesForSignature:self.chain_Id andParams:[[self getPramatersForRequiredKeys] objectForKey:@"transaction"] andCapacity:255];
    NSString *signatureStr = [EosSignature initWithbytesForSignature:d privateKey:private_key];
    NSString *packed_trxHexStr = [[EosByteWriter getBytesForSignature:nil andParams:[[self getPramatersForRequiredKeys] objectForKey:@"transaction"] andCapacity:512] hexadecimalString];
    
    NSMutableDictionary *pushDic = [NSMutableDictionary dictionary];
    [pushDic setObject:VALIDATE_STRING(packed_trxHexStr) forKey:@"packed_trx"];
    [pushDic setObject:@[signatureStr] forKey:@"signatures"];
    [pushDic setObject:@"none" forKey:@"compression"];
    [pushDic setObject:@"00" forKey:@"packed_context_free_data"];
    
    MBProgressHUD *hud4 = [MBProgressHUD zj_showHUDAddedToView:self.view title:kLocalizable(@"签名交易") animated:YES];
    
    [[HTTPRequestManager shareManager] post:eos_push_transaction paramters:pushDic success:^(BOOL isSuccess, id responseObject) {
        [hud4 hideAnimated:YES];
        if (isSuccess) {
            handler(responseObject);
        }
    } failure:^(NSError *error) {
        [hud4 hideAnimated:YES];
    } superView:self.view showFaliureDescription:YES];
}

#pragma mark - Get Paramter

- (NSDictionary *)getAbiJsonToBinParamters {
    // 交易JSON序列化
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject: @"eosio.token" forKey:@"code"];
    [params setObject:@"transfer" forKey:@"action"];
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    [args setObject:VALIDATE_STRING(self.account.accountName) forKey:@"from"];
    [args setObject:VALIDATE_STRING(self.receiverTF.textField.text) forKey:@"to"];
    [args setObject:VALIDATE_STRING(self.memoTF.textField.text) forKey:@"memo"];
    [args setObject:[NSString stringWithFormat:@"%.4f EOS", self.amountTF.textField.text.doubleValue] forKey:@"quantity"];
    [params setObject:args forKey:@"args"];
    return params;
}

- (NSDictionary *)getPramatersForRequiredKeys {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *transacDic = [NSMutableDictionary dictionary];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_prefix) forKey:@"ref_block_prefix"];
    [transacDic setObject:VALIDATE_STRING(self.ref_block_num) forKey:@"ref_block_num"];
    [transacDic setObject:VALIDATE_STRING(self.expiration) forKey:@"expiration"];
    
    [transacDic setObject:@[] forKey:@"context_free_data"];
    [transacDic setObject:@[] forKey:@"signatures"];
    [transacDic setObject:@[] forKey:@"context_free_actions"];
    [transacDic setObject:@0 forKey:@"delay_sec"];
    [transacDic setObject:@0 forKey:@"max_kcpu_usage"];
    [transacDic setObject:@0 forKey:@"max_net_usage_words"];
    
    
    NSMutableDictionary *actionDict = [NSMutableDictionary dictionary];
    [actionDict setObject:@"eosio.token" forKey:@"account"];
    [actionDict setObject:@"transfer" forKey:@"name"];
    [actionDict setObject:VALIDATE_STRING(self.binargs) forKey:@"data"];
    
    NSMutableDictionary *authorizationDict = [NSMutableDictionary dictionary];
    [authorizationDict setObject:self.account.accountName forKey:@"actor"];
    [authorizationDict setObject:@"active" forKey:@"permission"];
    [actionDict setObject:@[authorizationDict] forKey:@"authorization"];
    [transacDic setObject:@[actionDict] forKey:@"actions"];
    
    [params setObject:transacDic forKey:@"transaction"];
    
    [params setObject:@[self.account.ownerPublickKey,self.account.activePublickKey] forKey:@"available_keys"];
    return params;
}


#pragma mark - btnOnClick
- (IBAction)sendBtnOnClick:(UIButton *)sender {
    
    WEAK_SELF(weakSelf)
    InputPwdView *inputView = [[InputPwdView alloc]initWithFrame:CGRectMake(0, 0, inputViewWidth, inputViewHeight)];
    [inputView showInView:self.view handler:^(BOOL pwdValied, BOOL isCanceled, NSString *psw) {
        if (!isCanceled) {
            if (pwdValied) {
                weakSelf.password = psw;
                [weakSelf transfer];
            }
        }
    }];
}

- (void)scanBtnOnClick {
    WEAK_SELF(weakSelf)
    ScanQRViewController *VC = [[ScanQRViewController alloc] initWithHandler:^(BOOL success, NSString *codeString) {
        if (success) {
            weakSelf.receiverTF.textField.text = codeString;
        }
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    NavigationViewController *naVC = [[NavigationViewController alloc] initWithRootViewController:VC];
    [self presentViewController:naVC animated:YES completion:nil];
}


#pragma mark - getter

- (JSContext *)context {
    if (!_context) {
        _context = [[JSContext alloc] init];
    }
    return _context;
}

@end
