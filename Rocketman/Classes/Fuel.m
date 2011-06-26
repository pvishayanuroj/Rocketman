//
//  Fuel.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Fuel.h"
#import "GameLayer.h"
#import "CallFuncWeak.h"

@implementation Fuel

static NSUInteger countID = 0;

+ (id) fuelWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
        unitID_ = countID++;
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Fuel.png"] retain];
        [self addChild:sprite_ z:-1];
        sprite_.scale = 1.0;
        
        self.position = pos;
        
        // Attributes
        shootable_ = NO;
        collision_.radius = 20;
        collision_.radiusSquared = collision_.radius * collision_.radius;
        
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
    
    [sprite_ release];
    [idleAnimation_ release];
    [collectAnimation_ release];
    
    [super dealloc];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Fuel %d", unitID_];
}    

- (void) initActions
{
    CCActionInterval *sDown = [CCScaleTo actionWithDuration:0.3 scale:0.7];    
    CCActionInterval *eDown = [CCEaseIn actionWithAction:sDown rate:1.0];
    CCActionInterval *sUp = [CCScaleTo actionWithDuration:0.3 scale:1.0];
    CCActionInterval *eUp = [CCEaseOut actionWithAction:sUp rate:1.0];    
    CCActionInterval *animate = [CCSequence actions:eDown, eUp, nil];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];		    
    
    CCActionInterval *scaleUp = [CCScaleBy actionWithDuration:0.15 scale:1.5];
    CCActionInterval *scaleDown = [CCScaleBy actionWithDuration:0.1 scale:0.01];    
	CCFiniteTimeAction *method = [CallFuncWeak actionWithTarget:self selector:@selector(destroy)];	    
    collectAnimation_ = [[CCSequence actions:scaleUp, scaleDown, method, nil] retain];
}

- (void) showIdle
{
    [sprite_ stopAllActions];
    [sprite_ runAction:idleAnimation_];	    
}

- (void) showCollect
{
    [sprite_ stopAllActions];
    [sprite_ runAction:collectAnimation_];	        
}

- (void) collide
{
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [gameLayer collectFuel:self];
    [gameLayer removeObstacle:self];
    [self showCollect];    
    
    [super collide];
    
    // Note that destroy is called from the collect animation        
}

- (void) destroy
{   
    [super destroy];
}

@end
