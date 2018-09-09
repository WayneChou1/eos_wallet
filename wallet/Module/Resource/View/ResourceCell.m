//
//  ResourceCell.m
//  wallet
//
//  Created by 周志伟 on 2018/9/9.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "ResourceCell.h"

@implementation Resource
@end

@interface ResourceCell ()

@property (weak, nonatomic) IBOutlet UILabel *resourceNameLab;
@property (weak, nonatomic) IBOutlet UILabel *shortLab;
@property (weak, nonatomic) IBOutlet UILabel *restLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UILabel *amountLab;

@end

@implementation ResourceCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setResource:(Resource *)resource {
    _resource = resource;
    
    self.resourceNameLab.text = resource.resourceName;
    self.amountLab.text = resource.weight;
    self.detailLab.text = resource.description;
    self.restLab.text = [NSString stringWithFormat:@"%@ %@ / %@ %@",resource.used,resource.unit,resource.max,resource.unit];
}

@end
