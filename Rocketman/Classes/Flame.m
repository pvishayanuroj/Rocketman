//
//  Flame.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Flame.h"
#import "DataManager.h"
#import "TargetedAction.h"
#import "Boundary.h"
#import "GameManager.h"

@implementation Flame

@synthesize flameDelegate = flameDelegate_;

static NSUInteger countID = 0;

+ (void) resetID
{
    countID = 0;
}

#pragma mark - Object Lifecycle

+ (id) flameWithPos:(CGPoint)pos flameDirection:(FlameDirection)flameDirection flameDuration:(CGFloat)flameDuration
{
    return [[[self alloc] initWithPos:pos flameDirection:flameDirection flameDuration:flameDuration] autorelease];    
}

+ (id) repeatingFlameWithPos:(CGPoint)pos flameDirection:(FlameDirection)flameDirection flameDuration:(CGFloat)flameDuration
{
    return [[[self alloc] initWithPos:pos flameDirection:flameDirection flameDuration:flameDuration] autorelease];
}

- (id) initWithPos:(CGPoint)pos flameDirection:(FlameDirection)flameDirection flameDuration:(CGFloat)flameDuration
{
	if ((self = [super init])) {
        
		unitID_ = countID++;                
        obstacleType_ = kFlame;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@ Idle 01.png", name_];           
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        sprite_.flipX = (flameDirection == kFlameLeft);
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        flameDuration_ = flameDuration;
        flameDelegate_ = nil;      
        
        PVCollide collide = defaultPVCollide_;
        collide.circular = NO;
        collide.size.width = 120;
        collide.size.height = 25;
        collide.hitActive = NO;
        collide.collideActive = NO;
        
        boundary_ = [[Boundary boundary:self colStruct:collide] retain];
        
        // Bounding box setup
        [boundaries_ addObject:boundary_];
        
        [self initAnimations];
        [self initActions];
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
    [startAnimation_ release];
    [flamingAnimation_ release];
    [endAnimation_ release];
    [boundary_ release];
    
    [super dealloc];
}

#pragma mark - Initialization Methods

- (void) initAnimations
{
    // Start animation        
    NSString *name = [NSString stringWithFormat:@"Flame Start"];
    // If it doesn't exist, create it
    if ([[CCAnimationCache sharedAnimationCache] animationByName:name] == nil) {
        NSMutableArray *frames = [NSMutableArray arrayWithCapacity:2];
        CGFloat delay = 0.15f;
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Flame Idle 02.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Flame Idle 03.png"]];    
        CCAnimation *animation = [CCAnimation animationWithFrames:frames delay:delay];    
        [[CCAnimationCache sharedAnimationCache] addAnimation:animation name:name];    
    }
    
    // "Flaming" animation
    name = [NSString stringWithFormat:@"Flame Flaming"];
    // If it doesn't exist, create it
    if ([[CCAnimationCache sharedAnimationCache] animationByName:name] == nil) {
        NSMutableArray *frames = [NSMutableArray arrayWithCapacity:2];
        CGFloat delay = 0.15f;
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Flame Idle 04.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Flame Idle 05.png"]];    
        CCAnimation *animation = [CCAnimation animationWithFrames:frames delay:delay];    
        [[CCAnimationCache sharedAnimationCache] addAnimation:animation name:name];    
    }
    
    // End animation
    name = [NSString stringWithFormat:@"Flame End"];
    // If it doesn't exist, create it
    if ([[CCAnimationCache sharedAnimationCache] animationByName:name] == nil) {
        NSMutableArray *frames = [NSMutableArray arrayWithCapacity:2];
        CGFloat delay = 0.15f;
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Flame Idle 03.png"]];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Flame Idle 02.png"]];    
        CCAnimation *animation = [CCAnimation animationWithFrames:frames delay:delay];    
        [[CCAnimationCache sharedAnimationCache] addAnimation:animation name:name];    
    }    
}

- (void) initActions
{
    NSString *animationName = [NSString stringWithFormat:@"%@ Start", name_];
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	startAnimation_ = [[CCAnimate actionWithAnimation:animation] retain]; 
    
    animationName = [NSString stringWithFormat:@"%@ Flaming", name_];
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];    
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	flamingAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];	    
    
    animationName = [NSString stringWithFormat:@"%@ End", name_];
    animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	endAnimation_ = [[CCAnimate actionWithAnimation:animation] retain]; 
}

#pragma mark - Object Methods

- (void) startFlame
{
    [sprite_ stopAllActions];
    [self stopAllActions];
    [self enableCollision];
    
    TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:startAnimation_];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(showFlaming)];
    [self runAction:[CCSequence actions:animation, done, nil]];
}

- (void) showFlaming
{   
	[sprite_ stopAllActions];
	[sprite_ runAction:flamingAnimation_];	    
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:flameDuration_];
    CCActionInstant *end = [CCCallFunc actionWithTarget:self selector:@selector(endFlame)];
    [self runAction:[CCSequence actions:delay, end, nil]];
}

- (void) endFlame
{
    [sprite_ stopAllActions];
    TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:endAnimation_];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(flameFinished)];
    [self runAction:[CCSequence actions:animation, done, nil]];    
}

- (void) flameFinished
{
    [self disableCollision];
    [sprite_ setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Flame Idle 01.png"]];
    if ([flameDelegate_ respondsToSelector:@selector(flameFinished)]) {
        [flameDelegate_ flameFinished];
    }
}

- (void) cutFlame
{
    [self stopAllActions];
    [sprite_ stopAllActions];
    [self disableCollision];
    [sprite_ setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"Flame Idle 01.png"]];    
}

- (void) enableCollision
{
    PVCollide c = boundary_.collide;
    c.collideActive = YES;
    boundary_.collide = c;        
}

- (void) disableCollision
{
    PVCollide c = boundary_.collide;
    c.collideActive = NO;
    boundary_.collide = c;    
}

#pragma mark - Delegate Methods

- (void) boundaryCollide:(NSInteger)boundaryID
{
    if ([[GameManager gameManager] isRocketInvincible]) {
     
    }
    else {  
        [[GameManager gameManager] rocketBurn];
    } 
}


@end
