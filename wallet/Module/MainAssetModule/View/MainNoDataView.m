//
//  MainNoDataView.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/17.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "MainNoDataView.h"

@interface MainNoDataView (){
    BOOL _isNoWallet;
    BOOL _isNoAccount;
}

@property (weak, nonatomic) IBOutlet UILabel *emptyLab;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UIView *btnBackgroudView;

@end

@implementation MainNoDataView

- (instancetype)initHeaderViewWithFrame:(CGRect)frame noWallet:(BOOL)noWallet noAccount:(BOOL)noAccount{
    
    NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:@"MainNoDataView" owner:nil options:nil];
    
    if (viewArr.count != 0 && viewArr) {
        self = viewArr.firstObject;
        _isNoWallet = noWallet;
        _isNoAccount = noAccount;
        [self setUpSubViews];
    }
    return self;
}


- (void)setUpSubViews {
    
    if (_isNoWallet) {
        self.emptyLab.text = kLocalizable(@"没有相关资产！");
        [self.createBtn setTitle:kLocalizable(@"创建钱包") forState:UIControlStateNormal];
    }else if (_isNoAccount) {
        self.emptyLab.text = kLocalizable(@"没有相关账号！");
        [self.createBtn setTitle:kLocalizable(@"导入账号") forState:UIControlStateNormal];
    }
    
    
    // 设置阴影
    self.btnBackgroudView.layer.shadowColor = [UIColor blackColor].CGColor;//设置阴影的颜色
    self.btnBackgroudView.layer.shadowOpacity = 0.8;//设置阴影的透明度
    self.btnBackgroudView.layer.shadowOffset = CGSizeMake(1, 1);//设置阴影的偏移量
    self.btnBackgroudView.layer.shadowRadius = 3;//设置阴影的圆角
    
}

- (IBAction)createBtnOnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(needCreateWallet)]) {
        [self.delegate needCreateWallet];
    }
}
@end
