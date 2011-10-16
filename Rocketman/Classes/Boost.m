//
//  Boost.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Boost.h"
#import "GameLayer.h"
#import "DataManager.h"
#import "Boundary.h"
#import "StaticMovement.h"

@implementation Boost

static NSUInteger countID = 0;

+ (id) boostWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
        unitID_ = countID++;
        obstacleType_ = kBoost;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@.png", name_]; 
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;

        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.circular = NO;
        collide.size.width = 50;
        collide.size.height = 10;
        collide.hitActive = NO;
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundaryWithTarget:self collide:@selector(primaryCollision) hit:nil colStruct:collide]];        
        
        // Setup the way this obstacle moves
        [movements_ addObject:[StaticMovement staticMovement:self]];        
        
        [self initActions];
        [self showIdle];
    }
    return self;
}

- (void) dealloc
{
#if DEBUG_DEALLOCS
    NSLog(@"%@ dealloc'd", self);    
#endif
    
    [name_ release];
    [sprite_ release];
    [idleAnimation_ release];
    
    [super dealloc];
}

- (void) initActions
{
    CCActionInterval *scaleDown = [CCScaleTo actionWithDuration:0.5 scaleX:0.7 scaleY:1.0];
    CCActionInterval *scaleUp = [CCScaleTo actionWithDuration:0.5 scaleX:1.0 scaleY:1.0];    
    CCActionInterval *seq = [CCSequence actions:scaleDown, scaleUp, nil];
	idleAnimation_ = [[CCRepeatForever actionWithAction:seq] retain];		    
}

- (void) primaryCollision
{
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [gameLayer collectBoost:self];
    
    [super collide];
    
    [super flagToDestroy];
}

@end
