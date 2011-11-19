//
//  ComboModule.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/19/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "ComboModule.h"

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

- (void) enemyKilled:(ObstacleType)type pos:(CGPoint)pos
{
    
}

@end
