///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//  DCProgressView.m
//  iOSTester
//
//  Created by Dalton Cherry on 4/20/13.
//  Copyright 2013 Basement Krew. All rights reserved.
//
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#import "DCProgressView.h"
#import <math.h>

@implementation DCProgressView

@synthesize tintColor,borderColor,borderWidth,fillColor,corners,rounding,progress;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self sharedInit];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInit];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)sharedInit
{
    self.borderWidth = 1;
    self.rounding = 4;
    self.corners = UIRectCornerAllCorners;
    self.backgroundColor = [UIColor clearColor];
    animateProgress = -1;
    self.tintColor = [UIColor colorWithRed:0/255.0f green:136/255.0f blue:204/255.0f alpha:1];
    // Initialization code
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)drawRect:(CGRect)rect
{
    if(!self.fillColor)
        self.fillColor = [UIColor colorWithWhite:0.97 alpha:1];
    if(!self.borderColor)
        self.borderColor = [UIColor colorWithWhite:0.90 alpha:1];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    //draw the border
    if(self.borderWidth > 0)
    {
        frame = CGRectInset(frame, 0.5, 0.5);
        CGContextSaveGState(ctx);
        CGContextSetStrokeColorWithColor(ctx, self.borderColor.CGColor);
        CGContextSetLineWidth(ctx, self.borderWidth);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        
        CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:frame
                                               byRoundingCorners:self.corners
                                                     cornerRadii:CGSizeMake(self.rounding, self.rounding)].CGPath;
        CGContextAddPath(ctx, path);
        
        CGContextStrokePath(ctx);
        CGContextRestoreGState(ctx);
    }
    
    // draws background
    CGContextSaveGState(ctx);
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:frame
                                           byRoundingCorners:self.corners
                                                 cornerRadii:CGSizeMake(self.rounding, self.rounding)].CGPath;
    
    CGContextAddPath(ctx, path);
    CGContextClip(ctx);
    
    NSArray* newGradientColors = [NSArray arrayWithObjects:
                                  (id)[UIColor colorWithWhite:0.92 alpha:1].CGColor,
                                  (id)self.fillColor.CGColor,
                                  (id)self.fillColor.CGColor, nil];
    CGFloat newGradientLocations[] = {0.0,0.12, 1.0};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)newGradientColors, newGradientLocations);
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(self.borderWidth, 0), CGPointMake(self.borderWidth, frame.size.height), 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(ctx);
    
    //draw the fill
    CGContextSaveGState(ctx);
    float current = animateProgress;
    if(current <= -1)
        current = self.progress;
    CGRect tintFrame = frame;
    tintFrame.size.width = tintFrame.size.width*current;
    
    UIRectCorner tintCorners = self.corners;
    if(current+0.02 < 1 && self.corners & UIRectCornerAllCorners)
        tintCorners = UIRectCornerBottomLeft | UIRectCornerTopLeft;
    
    path = [UIBezierPath bezierPathWithRoundedRect:tintFrame
                                 byRoundingCorners:tintCorners
                                       cornerRadii:CGSizeMake(self.rounding, self.rounding)].CGPath;
    
    CGContextAddPath(ctx, path);
    CGContextClip(ctx);
    
    NSArray* fillGradientColors = [NSArray arrayWithObjects:
                                  (id)self.tintColor.CGColor,
                                  (id)[self adjustColor:self.tintColor point:-0.12].CGColor, nil];
    CGFloat fillGradientLocations[] = {0.0, 1.0};
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)fillGradientColors, fillGradientLocations);
    CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, 0), CGPointMake(0, frame.size.height+self.borderWidth), 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    CGContextRestoreGState(ctx);
    if(animateProgress > -1 && (animateProgress+0.01 < self.progress || animateProgress-0.01 > self.progress) )
    {
        if(animateProgress < self.progress)
            animateProgress += 0.01;
        else
            animateProgress -= 0.01;
        [self performSelector:@selector(reloadView) withObject:nil afterDelay:0.01];
    }
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setProgress:(CGFloat)pro
{
    if(pro > 1)
        pro = 1;
    if(pro < 0)
        pro = 0;
    animateProgress = -1;
    progress = floor(pro * 100) / 100;
    [self setNeedsDisplay];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setProgress:(CGFloat)pro animated:(BOOL)animated
{
    if(pro > 1)
        pro = 1;
    if(pro < 0)
        pro = 0;
    if(animated)
        animateProgress = progress;
    else
        animateProgress = -1;
    progress = floor(pro * 100) / 100;
    [self setNeedsDisplay];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)reloadView
{
    [self setNeedsDisplay];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(UIColor*)adjustColor:(UIColor*)color point:(CGFloat)point
{
    int totalComponents = CGColorGetNumberOfComponents(color.CGColor);
    BOOL isGreyscale = totalComponents == 2 ? YES : NO;
    
    CGFloat* oldComponents = (CGFloat*)CGColorGetComponents(color.CGColor);
    CGFloat newComponents[4];
    
    if (isGreyscale)
    {
        newComponents[0] = [self checkValue:oldComponents[0]+point point:point];
        newComponents[1] = [self checkValue:oldComponents[0]+point point:point];
        newComponents[2] = [self checkValue:oldComponents[0]+point point:point];
        newComponents[3] = oldComponents[1];
    }
    else
    {
        newComponents[0] = [self checkValue:oldComponents[0]+point point:point];
        newComponents[1] = [self checkValue:oldComponents[1]+point point:point];
        newComponents[2] = [self checkValue:oldComponents[2]+point point:point];
        newComponents[3] = oldComponents[3];
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
    
	UIColor *retColor = [UIColor colorWithCGColor:newColor];
	CGColorRelease(newColor);
    
    return retColor;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(CGFloat)checkValue:(CGFloat)current point:(CGFloat)point
{
    if(point < 0)
        return [self checkNeg:current];
    return [self checkPos:current];
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(CGFloat)checkPos:(CGFloat)current
{
    return current > 1.0 ? 1.0 : current;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(CGFloat)checkNeg:(CGFloat)current
{
    return current < 0.0 ? 0.0 : current;
}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
