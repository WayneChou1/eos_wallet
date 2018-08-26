//
//  WalletSendViewController.m
//  wallet
//
//  Created by 周志伟 on 2018/8/20.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "WalletSendViewController.h"
#import "InputTextField.h"

@interface WalletSendViewController ()

@property (weak, nonatomic) IBOutlet InputTextField *receiverTF;
@property (weak, nonatomic) IBOutlet InputTextField *amountTF;
@property (weak, nonatomic) IBOutlet InputTextField *memoTF;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@end

@implementation WalletSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpSubViews {
    self.receiverTF.textField.placeholder = kLocalizable(@"转账账号");
    self.receiverTF.shadowColor = kMain_Color;
    self.receiverTF.cornerRadius = 5.0;
    self.receiverTF.textField.keyboardType = UIKeyboardTypeASCIICapable;
    
    self.amountTF.textField.placeholder = kLocalizable(@"填写数额");
    self.amountTF.shadowColor = kMain_Color;
    self.amountTF.cornerRadius = 5.0;
    self.amountTF.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.amountTF.textField.secureTextEntry = YES;
    
    self.memoTF.textField.placeholder = kLocalizable(@"添加备注");
    self.memoTF.shadowColor = kMain_Color;
    self.memoTF.cornerRadius = 5.0;
    self.memoTF.textField.keyboardType = UIKeyboardTypeASCIICapable;
    self.memoTF.textField.secureTextEntry = YES;
    
    [self.sendBtn setTitle:kLocalizable(@"确认转账") forState:UIControlStateNormal];
}

#pragma mark - btnOnClick
- (IBAction)sendBtnOnClick:(UIButton *)sender {
}
@end
