//
//  PuzzleView.h
//  PuzzleDemo
//
//  Created by BoTingDing on 2018/11/19.
//  Copyright © 2018年 btding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class PuzzleView;
@protocol PuzzleViewDelegate
- (NSMutableArray*)contentForView:(PuzzleView *)view;
@end
@interface PuzzleView: UIView
@property (nonatomic,weak) id<PuzzleViewDelegate> delegate;
@end
