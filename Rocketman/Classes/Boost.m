//
//  Boost.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Boost.h"
#import "GameLayer.h"
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
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Boost Ring.png"] retain];
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
    
    [super dealloc];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Boost %d", unitID_];
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
    [gameLayer removeObstacle:self];
    
    [super collide];
    
    [self destroy];
}

- (void) destroy
{   
    [super destroy];
}


@end
