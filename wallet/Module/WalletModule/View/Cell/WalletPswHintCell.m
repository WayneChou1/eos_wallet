//
//  WalletPswCell.m
//  wallet
//
//  Created by 周志伟 on 2018/8/20.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "WalletPswHintCell.h"

@interface WalletPswHintCell ()

@property (weak, nonatomic) IBOutlet UIButton *secureBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation WalletPswHintCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLab.text = kLocalizable(@"密码提示");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


#pragma mark - btnOnClick

- (IBAction)secureBtnOnClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    self.pswHintTF.secureTextEntry = !sender.selected;
}


@end
