//
//  Boost.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Boost.h"
#import "GameLayer.h"

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
        shootable_ = NO;
        collision_.circular = NO;
        collision_.size.width = 50;
        collision_.size.height = 10;
        
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

- (void) showIdle
{
    [sprite_ stopAllActions];
    [sprite_ runAction:idleAnimation_];	    
}

- (void) collide
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
