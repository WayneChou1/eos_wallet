//
//  WalletExportCell.m
//  wallet
//
//  Created by zhouzhiwei on 2018/9/14.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "WalletExportCell.h"
#import "Account.h"
#import "UIImage+Filter.h"

@implementation Export
@end

@interface WalletExportCell ()

@property (weak, nonatomic) IBOutlet UILabel *permissionLab;
@property (weak, nonatomic) IBOutlet UIButton *publicBtn;
@property (weak, nonatomic) IBOutlet UIButton *privateBtn;
@property (weak, nonatomic) IBOutlet UIButton *exchangeBtn;

@property (weak, nonatomic) IBOutlet UILabel *permissionTipLab;
@property (weak, nonatomic) IBOutlet UILabel *publickTipLab;
@property (weak, nonatomic) IBOutlet UILabel *privateTipLab;
@end

@implementation WalletExportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setUpSubviews {
    self.permissionTipLab.text = kLocalizable(@"角色");
    self.publickTipLab.text = kLocalizable(@"公钥");
    self.privateTipLab.text = kLocalizable(@"私钥");
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
}

#pragma mark - btnOnClick

- (IBAction)publicBtnOnClick:(UIButton *)sender {
    [MBProgressHUD zj_showViewAfterSecondWithView:[UIApplication sharedApplication].keyWindow title:kLocalizable(@"复制成功") afterSecond:1.5];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.exp.publicKey;
}

- (IBAction)privateBtnOnClick:(UIButton *)sender {
    [MBProgressHUD zj_showViewAfterSecondWithView:[UIApplication sharedApplication].keyWindow title:kLocalizable(@"复制成功") afterSecond:1.5];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.exp.privateKey;
}

- (IBAction)exchangeBtnOnClick:(UIButton *)sender {
    self.exp.showQR = !self.exp.showQR;
    if ([self.delegate respondsToSelector:@selector(refreshCell:)]) {
        [self.delegate refreshCell:self];
    }
}

- (void)reloadPrivate {
    if (self.exp.showQR) {
        [self.exchangeBtn setTitle:kLocalizable(@"明文") forState:UIControlStateNormal];
        [self.privateBtn setImage:[[UIImage createImageWithString:self.exp.privateKey filterWithName:CIQRCode] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [self.privateBtn setTitle:nil forState:UIControlStateNormal];
        self.privateBtn.userInteractionEnabled = NO;
    }else{
        [self.exchangeBtn setTitle:kLocalizable(@"二维码") forState:UIControlStateNormal];
        [self.privateBtn setTitle:self.exp.privateKey forState:UIControlStateNormal];
        [self.privateBtn setImage:nil forState:UIControlStateNormal];
        self.privateBtn.userInteractionEnabled = YES;
    }
}


#pragma mark - setter

- (void)setExp:(Export *)exp {
    _exp = exp;
    self.permissionLab.text = exp.permission;
    [self.publicBtn setTitle:exp.publicKey forState:UIControlStateNormal];
    
    [self reloadPrivate];
}

@end
