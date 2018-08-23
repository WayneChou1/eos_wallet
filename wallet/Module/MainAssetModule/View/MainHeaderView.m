//
//  MainHeaderView.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/17.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "MainHeaderView.h"

@interface MainHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *totalAssetLab;
@property (weak, nonatomic) IBOutlet UILabel *incomeLab;
@property (weak, nonatomic) IBOutlet UILabel *expenseLab;

@end

@implementation MainHeaderView

- (instancetype)initHeaderViewWithFrame:(CGRect)frame {
    
    NSArray *viewArr = [[NSBundle mainBundle] loadNibNamed:@"MainHeaderView" owner:nil options:nil];
    
    if (viewArr.count != 0 && viewArr) {
        self = viewArr.firstObject;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
