//
//  TimerView.m
//  TapeTimer
//
//  Created by Jialiang Xiang on 2014-12-25.
//  Copyright (c) 2014 Jialiang Xiang. All rights reserved.
//

#import "TimerView.h"
#import "RulerScaleLayer.h"

@implementation TimerView
{
    float previousLocation;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        RulerScaleLayer* rulerScale = [RulerScaleLayer newTailWithTimerView:self WithRangeFrom:0 to:10 withScaleFactor:1];
        rulerScale.contentsScale = [[UIScreen mainScreen] scale];
        [self.layer addSublayer:rulerScale];
        [rulerScale setNeedsDisplay];
        
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self addGestureRecognizer:panRecognizer];
        
        self.rulerScrollController = [[RulerScrollController alloc] initWithTimerView:self];
    }
    
    return self;
}

/* why we need to remember previous location: the translation is calculated from the 
 position the pan begins. So the value gets larger and larger as moving further and
 further from the beginning position. 
 */
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Remember original location
    previousLocation = self.rulerScrollController.getCurrentAbsoluteRulerLocation;
}

- (void) handlePan: (UIPanGestureRecognizer*) uigr
{
    CGPoint translation = [uigr translationInView:self]; // pan up or scroll down = negative
    [self.rulerScrollController scrollToAbsoluteRulerLocation:(translation.y + previousLocation)];
}

@end
