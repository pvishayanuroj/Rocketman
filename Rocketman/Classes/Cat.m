//
//  Cat.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Cat.h"
#import "GameLayer.h"
#import "CallFuncWeak.h"
#import "Boundary.h"
#import "StaticMovement.h"

@implementation Cat

static NSUInteger countID = 0;

+ (id) catWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;                     
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Cat Idle 01.png"] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
                                                
        // Attributes
        PVCollide collide = defaultPVCollide_;
        collide.radius = 16;
        collide.hitActive = NO;
        
        // Bounding box setup
        [boundaries_ addObject:[Boundary boundaryWithTarget:self collide:@selector(primaryCollision) hit:nil colStruct:collide]];        
        
        // This gets released in the death function
        movement_ = [[StaticMovement staticMovement:self] retain];        
        
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
    return [NSString stringWithFormat:@"Cat %d", unitID_];
}    

- (void) initActions
{
    CCActionInterval *animate = [CCRotateBy actionWithDuration:2.0 angle:360];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];		    
    
    CCActionInterval *scaleUp = [CCScaleBy actionWithDuration:0.15 scale:2.0];
    CCActionInterval *scaleDown = [CCScaleBy actionWithDuration:0.1 scale:0.01];    
	CCFiniteTimeAction *method = [CallFuncWeak actionWithTarget:self selector:@selector(destroy)];	    
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
    [gameLayer collectCat:self];    
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
