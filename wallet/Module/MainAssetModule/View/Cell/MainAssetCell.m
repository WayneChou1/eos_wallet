//
//  MainAssetCell.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/31.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "MainAssetCell.h"
#import "Account.h"

@interface MainAssetCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *assetNameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *assetCountLab;
@property (weak, nonatomic) IBOutlet UILabel *actualAssetLab;
@property (weak, nonatomic) IBOutlet UIView *shadowView;

@end

@implementation MainAssetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    wLog(@"cell frame == %@",NSStringFromCGRect(self.shadowView.frame));
    
//    self.shadowView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.shadowView.bounds].CGPath; // 设置阴影路径，防止卡顿
    // 设置阴影
    self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;//设置阴影的颜色
    self.shadowView.layer.shadowOpacity = 0.1;//设置阴影的透明度
    self.shadowView.layer.shadowOffset = CGSizeMake(3, 3);//设置阴影的偏移量
    self.shadowView.layer.shadowRadius = 3;//设置阴影的圆角
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setInfo:(Account *)info {
    _info = info;
    
    self.iconImgV.image = [UIImage imageNamed:@"Wallet.bundle/main/asset_eos"];
    self.assetNameLab.text = @"EOS";
    self.addressLab.text = info.ownerPublickKey;
//    self.addressLab.text = info.localAccout.ownerPublickKey;
//    self.assetCountLab.text = info.core_liquid_balance;
    self.actualAssetLab.text = @"";
}

@end
