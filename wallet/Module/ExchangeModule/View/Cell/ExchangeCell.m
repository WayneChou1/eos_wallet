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
    
//    self.tokenLab.text = [exchange.action_trace.act.data.quantity componentsSeparatedByString:@" "].lastObject;
//    
//    // 时间格式化
//    NSDate *blockDate = [NSDate dateFromISO8601String:exchange.block_time];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
//    self.timeLab.text = [dateFormatter stringFromDate:blockDate];
//    
//    // 判断是否是本地账号
//    BOOL isReceive = NO;
//    NSArray <Account *> *accountArr = [[AccountManager shareManager] selectAllAccounts];
//    for (Account *a in accountArr) {
//        if ([a.accountName isEqualToString:exchange.action_trace.act.data.to]) {
//            isReceive = YES;
//        }else if ([a.accountName isEqualToString:exchange.action_trace.act.data.from]) {
//            isReceive = NO;
//        }
//    }
//    
//    if (isReceive) {
//        self.amoutLab.textColor = kMain_Color;
//        self.amoutLab.text = [NSString stringWithFormat:@"+%@",exchange.action_trace.act.data.quantity];
//    }else{
//        self.amoutLab.textColor = kWarning_Text_Color;
//        self.amoutLab.text = [NSString stringWithFormat:@"-%@",exchange.action_trace.act.data.quantity];
//    }
}

@end
