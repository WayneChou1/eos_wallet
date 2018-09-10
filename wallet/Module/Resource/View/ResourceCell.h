//
//  ResourceCell.h
//  wallet
//
//  Created by 周志伟 on 2018/9/9.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface Resource : NSObject

@property (copy, nonatomic) NSString *resourceName;
@property (copy, nonatomic) NSString *max;
@property (copy, nonatomic) NSString *used;
@property (copy, nonatomic) NSString *weight;
@property (copy, nonatomic) NSString *unit;
@property (copy, nonatomic) NSString *dec;

@end


@interface ResourceCell : BaseTableViewCell

@property (strong, nonatomic) Resource *resource;

@end
