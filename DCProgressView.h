///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCProgressView.h
//  iOSTester
//
//  Created by Dalton Cherry on 4/20/13.
//  Copyright 2013 Basement Krew. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import <UIKit/UIKit.h>

@interface DCProgressView : UIView
{
    float animateProgress;
}

//your fill (background) color
@property(nonatomic,strong)UIColor* fillColor;

//your tint (bar) color
@property(nonatomic,strong)UIColor* tintColor;

//the width of the border
@property(nonatomic,assign)CGFloat borderWidth;

//the width of the border
@property(nonatomic,strong)UIColor* borderColor;

//the amount to round the corners
@property(nonatomic,assign)CGFloat rounding;

//the corners to round
@property(nonatomic,assign)UIRectCorner corners;

//the progress of the bar
@property(nonatomic,assign)CGFloat progress;

//set the progress bar with animation
-(void)setProgress:(CGFloat)pro animated:(BOOL)animated;

@end
