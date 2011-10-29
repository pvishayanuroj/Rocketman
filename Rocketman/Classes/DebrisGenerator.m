//
//  DebrisGenerator.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "DebrisGenerator.h"
#import "GameLayer.h"
#import "RockDebris.h"

@implementation DebrisGenerator

+ (void) addDebris:(GameLayer *)gameLayer type:(DoodadType)type pos:(CGPoint)pos
{
    [gameLayer addDoodad:[RockDebris rockDebris:pos arcType:kArc1 arcSide:kRightArc]];
    [gameLayer addDoodad:[RockDebris rockDebris:pos arcType:kArc3 arcSide:kRightArc]];
    [gameLayer addDoodad:[RockDebris rockDebris:pos arcType:kArc2 arcSide:kLeftArc]];
    [gameLayer addDoodad:[RockDebris rockDebris:pos arcType:kArc3 arcSide:kLeftArc]];    
}

@end
