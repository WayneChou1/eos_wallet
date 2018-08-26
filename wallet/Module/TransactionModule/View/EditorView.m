//
//  EditorView.m
//  OCR
//
//  Created by Apple on 16/10/12.
//  Copyright © 2016年 Choyea. All rights reserved.
//

#import "EditorView.h"

#define editLineH 20
#define cornerLineW 4
#define lineW 2

@interface EditorView(){
//    BOOL _canScale;
    NSInteger _currentCorner;
    CGPoint  _lastPoint;
}

@end

@implementation EditorView


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
    }
    
    return self;
    
}


-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentMode = UIViewContentModeRedraw;
    }
    
    return self;
    
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, lineW);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);

    CGContextAddRect(context, rect);
    
    CGContextDrawPath(context, kCGPathStroke);
    

    CGPoint aPoints[2];
    CGPoint bPoints[2];
    CGPoint cPoints[2];
    CGPoint dPoints[2];
    CGPoint ePoints[2];
    CGPoint fPoints[2];
    CGPoint gPoints[2];
    CGPoint hPoints[2];
    
    
    aPoints[0] =CGPointMake(0, 0);//坐标1
    aPoints[1] =CGPointMake(0, editLineH);//坐标2
    
    bPoints[0] =CGPointMake(0, 0);//坐标1
    bPoints[1] =CGPointMake(editLineH, 0);//坐标2
    
    cPoints[0] =CGPointMake(rect.size.width - editLineH, 0);//坐标1
    cPoints[1] =CGPointMake(rect.size.width, 0);//坐标2
    
    dPoints[0] =CGPointMake(rect.size.width, 0);//坐标1
    dPoints[1] =CGPointMake(rect.size.width, editLineH);//坐标2
    
    ePoints[0] =CGPointMake(rect.size.width, rect.size.height - editLineH);//坐标1
    ePoints[1] =CGPointMake(rect.size.width, rect.size.height);//坐标2=
    
    fPoints[0] =CGPointMake(rect.size.width, rect.size.height);//坐标1
    fPoints[1] =CGPointMake(rect.size.width - editLineH, rect.size.height);//坐标2
    
    gPoints[0] =CGPointMake(editLineH, rect.size.height);//坐标1
    gPoints[1] =CGPointMake(0, rect.size.height);//坐标2
    
    hPoints[0] =CGPointMake(0, rect.size.height);//坐标1
    hPoints[1] =CGPointMake(0, rect.size.height - editLineH);//坐标2
    
    CGContextSetStrokeColorWithColor(context, kMain_Color.CGColor);
    CGContextSetLineWidth(context, cornerLineW);
    
    CGContextAddLines(context, aPoints, 2);
    CGContextAddLines(context, bPoints, 2);
    CGContextAddLines(context, cPoints, 2);
    CGContextAddLines(context, dPoints, 2);
    CGContextAddLines(context, ePoints, 2);
    CGContextAddLines(context, fPoints, 2);
    CGContextAddLines(context, gPoints, 2);
    CGContextAddLines(context, hPoints, 2);
    
    
    CGContextDrawPath(context, kCGPathStroke);
}


@end
