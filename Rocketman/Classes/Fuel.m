//
//  Fuel.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Fuel.h"
#import "GameLayer.h"
#import "DataManager.h"
#import "CallFuncWeak.h"
#import "Boundary.h"
#import "StaticMovement.h"

@implementation Fuel

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

+ (id) fuelWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
        unitID_ = countID++;
        obstacleType_ = kFuel;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@.png", name_];         
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        sprite_.scale = 1.0;
        
        self.position = pos;
    
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 20;
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
    [collectAnimation_ release];
    
    [super dealloc];
}

- (void) initActions
{
    CCActionInterval *sDown = [CCScaleTo actionWithDuration:0.3 scale:0.7];    
    CCActionInterval *eDown = [CCEaseIn actionWithAction:sDown rate:1.0];
    CCActionInterval *sUp = [CCScaleTo actionWithDuration:0.3 scale:1.0];
    CCActionInterval *eUp = [CCEaseOut actionWithAction:sUp rate:1.0];    
    CCActionInterval *animate = [CCSequence actions:eDown, eUp, nil];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];		    
    
    CCActionInterval *scaleUp = [CCScaleBy actionWithDuration:0.1f scale:1.5];
    CCActionInterval *scaleDown = [CCScaleBy actionWithDuration:0.05f scale:0.01];    
	CCFiniteTimeAction *method = [CallFuncWeak actionWithTarget:self selector:@selector(death)];	    
    collectAnimation_ = [[CCSequence actions:scaleUp, scaleDown, method, nil] retain];    
}

- (void) showCollect
{
    [sprite_ stopAllActions];
    [sprite_ runAction:collectAnimation_];	        
}

- (void) primaryCollision
{
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [gameLayer collectFuel:self];
    [self showCollect];    
}

- (void) death
{   
    [super flagToDestroy];
}

@end
