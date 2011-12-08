//
//  ComboModule.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/19/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "ComboModule.h"
#import "EventText.h"
#import "GameManager.h"

@implementation ComboModule

@synthesize delegate = delegate_;

+ (id) comboModule:(NSInteger)maxCount maxInterval:(double)maxInterval
{
    return [[[self alloc] initComboModule:maxCount maxInterval:maxInterval] autorelease];
}

- (id) initComboModule:(NSInteger)maxCount maxInterval:(double)maxInterval
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        comboCount_ = 0;
        maxComboCount_ = maxCount;
        maxComboInterval_ = maxInterval;
        
    }
    return self;
}

- (void) step:(ccTime)dt
{
    // Combo count can only decrement is it is non-zero and not at max
    // Decrement only a certain interval has passed without any more kills
    if (comboCount_ > 0 && comboCount_ < maxComboCount_) {
        // Calculate difference from last time combo was incremented        
        if (CACurrentMediaTime() - lastComboTimestamp_ > maxComboInterval_) {
            [self setComboCount:comboCount_ - 1];
        }
    }
}

- (void) enemyKilled:(ObstacleType)type pos:(CGPoint)pos
{
    // This will assign to the combo count
    [self setComboCount:comboCount_ + 1];
    
    NSString *text = [NSString stringWithFormat:@"+%d", comboCount_];
    EventText *eventText = [EventText eventTextWithString:text];
    eventText.position = CGPointMake(pos.x, pos.y + 20);
    [[GameManager gameManager] addGameLayerText:eventText];
}

- (void) setComboCount:(NSInteger)count
{
    if (count >= 0) {
    
        NSInteger origComboCount = comboCount_;
        lastComboTimestamp_ = CACurrentMediaTime();
        comboCount_ = count;
        [delegate_ comboCountUpdate:comboCount_];
        
        // Check if the combo max has been reached
        if (comboCount_ == maxComboCount_) {
            [delegate_ comboActivated];
        }
        // Check if combo has been lost or used
        else if (origComboCount >= maxComboCount_ && comboCount_ < maxComboCount_) {
            [delegate_ comboDeactivated];
        }
    }
}

- (void) comboUsed
{
    [self setComboCount:0];
}

- (void) rocketCollision
{
    [self setComboCount:0];
}

@end
