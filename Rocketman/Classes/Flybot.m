//
//  Flybot.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Flybot.h"
#import "GameLayer.h"
#import "AudioManager.h"

@implementation Flybot

@synthesize primaryPVCollide = primaryPVCollide_;

static NSUInteger countID = 0;

+ (id) flyBotWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;                
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Flybot Idle 01.png"] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        primaryPVCollide_ = defaultPVCollide_;
        primaryPVCollide_.radius = 30;
        primaryPVCollide_.radiusSquared = primaryPVCollide_.radius * primaryPVCollide_.radius;                                  
        
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
    return [NSString stringWithFormat:@"Flybot %d", unitID_];
}    

- (void) initActions
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Flybot Idle"];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];	
}                 

- (void) showIdle
{
	[sprite_ stopAllActions];
	[sprite_ runAction:idleAnimation_];	
}

- (void) primaryCollision
{
    primaryPVCollide_.collideActive = NO;
    primaryPVCollide_.hitActive = NO;
    [self collide];
}

- (void) primaryHit
{
    primaryPVCollide_.collideActive = NO;
    primaryPVCollide_.hitActive = NO;
    [self bulletHit];
}

- (void) bulletHit
{
    [[AudioManager audioManager] playSound:kPlop];        
    
    [super showDestroy:kBamText];
    
    [super bulletHit];
}

- (void) collide
{
    sprite_.visible = NO;    
    
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [[AudioManager audioManager] playSound:kWerr];                
    [gameLayer slowDown:0.66];    
    
    [super showDestroy:kPlopText];
    
    [super collide];    
}

- (void) destroy
{    
    GameLayer *gameLayer = (GameLayer *)[self parent];    
    [gameLayer removeObstacle:self];      
    
    [super destroy];
}

@end
