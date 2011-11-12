//
//  MapTurtle.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "MapTurtle.h"
#import "PointWrapper.h"
#import "TargetedAction.h"
#import "EngineParticleSystem.h"

@implementation MapTurtle

@synthesize delegate = delegate_;

const CGFloat MT_MOVE_AMT = 500.0f;
const CGFloat MT_ENGINE_X = 20.0f;
const CGFloat MT_ENGINE_Y = 15.0f;

+ (id) mapTurtle:(CGPoint)pos speed:(CGFloat)speed side:(MapTurtleSide)side type:(MapTurtleStyle)type
{
    return [[[self alloc] initMapTurtle:pos speed:speed side:side type:type] autorelease];
}

- (id) initMapTurtle:(CGPoint)pos speed:(CGFloat)speed side:(MapTurtleSide)side type:(MapTurtleStyle)type
{
    if ((self = [super init])) {
        
        self.position = pos;
        
        // Sprite
        CCSprite *sprite;
        if (type == kFadedTurtle) {
            sprite = [CCSprite spriteWithSpriteFrameName:@"Map Turtle Faded.png"];
        }
        else {
            sprite = [CCSprite spriteWithSpriteFrameName:@"Map Turtle Sharp.png"];
        }
        sprite.flipX = (side == kMapRight);
        [self addChild:sprite z:2];
        
        // Engine
        EngineParticleSystem *engine = [EngineParticleSystem PSForMapTurtle];
        engine.position = (side == kMapLeft) ? CGPointMake(-MT_ENGINE_X, MT_ENGINE_Y) : CGPointMake(MT_ENGINE_X, MT_ENGINE_Y);
        [self addChild:engine z:1];
        
        // Movement
        CGPoint endPos = (side == kMapLeft) ? CGPointMake(MT_MOVE_AMT, 0.0f) : CGPointMake(-MT_MOVE_AMT, 0.0f);
        CCActionInterval *move = [CCMoveBy actionWithDuration:speed position:endPos];
        CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(doneMoving)];
        [self runAction:[CCSequence actions:move, done, nil]];
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) doneMoving
{
    [delegate_ mapTurtleDoneMoving:self];
}

@end
