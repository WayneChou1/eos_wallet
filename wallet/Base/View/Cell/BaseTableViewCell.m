//
//  BaseTableViewCell.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/17.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

+ (NSString *)cellIdentifier {
    return NSStringFromClass(self);
}

@end
