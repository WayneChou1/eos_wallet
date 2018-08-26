//
//  InputTextField.m
//  wallet
//
//  Created by zhouzhiwei on 2018/7/25.
//  Copyright © 2018年 eos. All rights reserved.
//

#import "InputTextField.h"

@interface InputTextField () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionBtnWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toActionBtnConstraint;

@end

@implementation InputTextField

- (instancetype)initViewWithFrame:(CGRect)frame {
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpSubViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setUpSubViews];
    }
    return self;
}

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self.actionBtn addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setTitleForActionBtn:(NSString *)title forState:(UIControlState)state {
    [self.actionBtn setTitle:title forState:state];
}

- (void)setImageForActionBtn:(UIImage *)img forState:(UIControlState)state {
    [self.actionBtn setImage:img forState:state];
}

- (void)setWidthForActionBtn:(CGFloat)width {
    self.actionBtnWidthConstraint.constant = width;
    if (width == 0) {
        self.toActionBtnConstraint.constant = 0.0;
    }else{
        self.toActionBtnConstraint.constant = 10.0;
    }
}

- (void)setUpSubViews {
    [[NSBundle mainBundle] loadNibNamed:@"InputTextField" owner:self options:nil];
    [self addSubview:self.contentView];
    
    // 默认约束
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    // 默认actionBtn宽度为0
    self.actionBtnWidthConstraint.constant = 0.0;
    self.toActionBtnConstraint.constant = 0.0;
}


#pragma mark - 设置阴影

- (void)setShadow:(BOOL)show {
    
    if (show) {
        // 设置阴影
        self.layer.shadowColor = self.shadowColor.CGColor;//设置阴影的颜色
        self.layer.shadowOpacity = 0.8;//设置阴影的透明度
        self.layer.shadowOffset = CGSizeMake(1, 1);//设置阴影的偏移量
        self.layer.shadowRadius = 3;//设置阴影的圆角
    }else{
        // 取消阴影
        self.layer.shadowColor = nil;
        self.layer.shadowOpacity = 0;
        self.layer.shadowOffset = CGSizeZero;
        self.layer.shadowRadius = 0;
    }
    
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self setShadow:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self setShadow:NO];
}


#pragma mark - setter

- (void)setShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.contentView.layer.cornerRadius = cornerRadius;
}

- (void)setEdgeInset:(UIEdgeInsets)edgeInset {
    _edgeInset = edgeInset;
}

@end
