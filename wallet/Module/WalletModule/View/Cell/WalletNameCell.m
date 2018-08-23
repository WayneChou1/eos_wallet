//
//  WalletNameCell.m
//  wallet
//
//  Created by 周志伟 on 2018/8/20.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "WalletNameCell.h"

@interface WalletNameCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation WalletNameCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLab.text = kLocalizable(@"钱包名称");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
