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

const NSInteger CM_TARGET_COUNT = 9;

@implementation ComboModule

+ (id) comboModule
{
    return [[[self alloc] initComboModule] autorelease];
}

- (id) initComboModule
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        
        
        comboCount_ = 0;
        
    }
    return self;
}

- (void) step:(ccTime)dt
{
    
}

- (void) enemyKilled:(ObstacleType)type pos:(CGPoint)pos
{
    comboCount_++;
    
    NSString *text = [NSString stringWithFormat:@"+%d", comboCount_];
    EventText *eventText = [EventText eventTextWithString:text];
    eventText.position = CGPointMake(pos.x, pos.y + 20);
    [[GameManager gameManager] addGameLayerText:eventText];
}

@end
