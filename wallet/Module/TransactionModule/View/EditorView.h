//
//  EditorView.h
//  OCR
//
//  Created by Apple on 16/10/12.
//  Copyright © 2016年 Choyea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScanEditorDelegate <NSObject>

- (void)light:(BOOL)on;

@end

@interface EditorView : UIView

@property (weak, nonatomic) id <ScanEditorDelegate> delegate;

- (void)showLightBtn;
- (void)hidLightBtn;

@end
