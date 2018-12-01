//
//  PuzzleView.m
//  PuzzleDemo
//
//  Created by BoTingDing on 2018/11/19.
//  Copyright © 2018年 btding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PuzzleView.h"

@implementation PuzzleView
- (void)drawRect:(CGRect)rect {
    NSMutableArray *contentArray = [self.delegate contentForView:self];
    // get context
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat rectWidth = rect.size.width / 8;
    CGFloat rectHeight = rect.size.height / 8;
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextAddRect(context, self.bounds);
    CGContextSetLineWidth(context, 2.0);
    CGContextDrawPath(context, kCGPathFillStroke);
    for (int i=0; i<=7; i++) {
        for (int j=0; j<=7; j++) {
            CGContextSetFillColorWithColor(context,[[UIColor yellowColor] CGColor]);
            CGContextSetLineWidth(context, 2.0);
            CGContextAddRect(context, CGRectMake(rectWidth*i, rectHeight*j, rectWidth, rectHeight));
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
    if ([contentArray count] > 0) {
        for (int i=0; i<=7; i++) {
            for (int j=0; j<=7; j++) {
                NSString *drawStr = [contentArray objectAtIndex:(i * 8) + j ];
                CGSize sizeText = [drawStr boundingRectWithSize:self.bounds.size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{
                                               NSKernAttributeName:@25,//文字之间的字距
                                            }
                                            context:nil].size;
                NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                style.alignment = NSTextAlignmentCenter;
                [drawStr drawInRect:CGRectMake(rectWidth*i, rectHeight * j + (rectHeight - sizeText.height*2) / 2 ,rectWidth, rectHeight)
                         withAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],
                                          NSFontAttributeName:[UIFont systemFontOfSize:25],
                                          NSParagraphStyleAttributeName: style
                                         }
                ];
            }
        }
    }
}
@end

