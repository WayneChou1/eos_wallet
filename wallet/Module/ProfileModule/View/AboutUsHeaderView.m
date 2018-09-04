//
//  AboutUsHeaderView.m
//  wallet
//
//  Created by zhouzhiwei on 2018/9/4.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "AboutUsHeaderView.h"

@interface AboutUsHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *versionLab;
@property (weak, nonatomic) IBOutlet UILabel *introduceLab;

@end

@implementation AboutUsHeaderView

- (instancetype)initHeaderViewWithFrame:(CGRect)frame {
    NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:@"AboutUsHeaderView" owner:nil options:nil];
    if (viewArr.count != 0 && viewArr) {
        self = viewArr.firstObject;
        self.frame = frame;
        [self setUpSubViews];
    }
    return self;
}

- (void)setUpSubViews {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLab.text = [NSString stringWithFormat:@"%@ %@",kLocalizable(@"当前版本"),app_Version];
    self.introduceLab.text = kLocalizable(@"Wallet Eos 是一款移动端轻钱包APP，它旨在为普通用户提供一款安全、可靠、功能强大的数字资产钱包应用。目前钱包仅支持EOS，后续将添加ETH、BTC等，功能不断完善中，敬请期待");
}

@end
