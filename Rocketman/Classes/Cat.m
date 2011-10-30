//
//  Cat.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Cat.h"
#import "GameLayer.h"
#import "DataManager.h"
#import "CallFuncWeak.h"
#import "Boundary.h"
#import "StaticMovement.h"

@implementation Cat

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

+ (id) catWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;                     
        obstacleType_ = kCat;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];         
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
                                                
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 16;
        collide.hitActive = NO;
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundary:self colStruct:collide]];        
        
        // Setup the way this obstacle moves
        [movements_ addObject:[StaticMovement staticMovement]];           
        
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
    CCActionInterval *animate = [CCRotateBy actionWithDuration:2.0 angle:360];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];		    
    
    CCActionInterval *scaleUp = [CCScaleBy actionWithDuration:0.15 scale:2.0];
    CCActionInterval *scaleDown = [CCScaleBy actionWithDuration:0.1 scale:0.01];    
	CCFiniteTimeAction *method = [CallFuncWeak actionWithTarget:self selector:@selector(death)];	    
    collectAnimation_ = [[CCSequence actions:scaleUp, scaleDown, method, nil] retain];
}

- (void) showCollect
{
    [sprite_ stopAllActions];
    [sprite_ runAction:collectAnimation_];	        
}

- (void) boundaryCollide:(NSInteger)boundaryID
{
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [gameLayer collectCat:self];    
    [self showCollect];
}

- (void) death
{   
    [super flagToDestroy];
}

@end
