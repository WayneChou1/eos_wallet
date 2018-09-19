//
//  TencentContactViewController.m
//  wallet
//
//  Created by zhouzhiwei on 2018/9/19.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "TencentContactViewController.h"

@interface TencentContactViewController ()

@property (assign, nonatomic) TencentContactType type;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLab;
@property (weak, nonatomic) IBOutlet UIImageView *gourpQRImgV;

@end

@implementation TencentContactViewController

- (instancetype)initWithContact:(TencentContactType)type {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setUpSubViews {
    switch (self.type) {
        case TencentContactTypeQQ:
        {
            self.descriptionLab.text = kLocalizable(@"通过扫描群QQ群二维码来联系我们");
            self.gourpQRImgV.image = [UIImage imageNamed:@"Wallet.bundle/profile/faq/faq_qq_group"];
            self.title = kLocalizable(@"QQ群");
        }
            break;
        case TencentContactTypeWechat:
        {
            self.descriptionLab.text = kLocalizable(@"通过扫描群微信群二维码来联系我们");
            self.gourpQRImgV.image = [UIImage imageNamed:@"Wallet.bundle/profile/faq/faq_qq_group"];
            self.title = kLocalizable(@"微信群");
        }
            break;
        default:
            break;
    }
}

@end
