//
//  ExchangeCell.m
//  wallet
//
//  Created by 周志伟 on 2018/8/29.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "ExchangeCell.h"
#import "AccountManager.h"

@interface ExchangeCell ()

@property (weak, nonatomic) IBOutlet UILabel *tokenLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *amoutLab;


@end

@implementation ExchangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setExchange:(Exchange *)exchange {
    _exchange = exchange;
    
    self.tokenLab.text = [exchange.quantity componentsSeparatedByString:@" "].lastObject;
    self.timeLab.text = exchange.expiration;
    
    // 判断是否是本地账号
    BOOL isReceive = NO;
    NSArray <Account *> *accountArr = [[AccountManager shareManager] selectAllAccounts];
    for (Account *a in accountArr) {
        if ([a.accountName isEqualToString:exchange.to]) {
            isReceive = YES;
        }else if ([a.accountName isEqualToString:exchange.from]) {
            isReceive = NO;
        }
    }
    
    if (isReceive) {
        self.amoutLab.textColor = kMain_Color;
        self.amoutLab.text = [NSString stringWithFormat:@"+%@",exchange.quantity];
    }else{
        self.amoutLab.textColor = kWarning_Text_Color;
        self.amoutLab.text = [NSString stringWithFormat:@"-%@",exchange.quantity];
    }
}

@end
