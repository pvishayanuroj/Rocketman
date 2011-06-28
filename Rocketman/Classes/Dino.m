//
//  Dino.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Dino.h"
#import "TargetedAction.h"
#import "GameLayer.h"
#import "AudioManager.h"
#import "GameManager.h"

@implementation Dino

@synthesize primaryPVCollide = primaryPVCollide_;

static NSUInteger countID = 0;

+ (id) dinoWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;                        
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Dino Idle 01.png"] retain];
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
    [flameAnimation_ release];
    
    [super dealloc];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Dino %d", unitID_];
}    

- (void) initActions
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Dino Idle"];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];		
    
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Dino Attack"];
	flameAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];
}   

- (void) showIdle
{
	[sprite_ stopAllActions];
	[sprite_ runAction:idleAnimation_];	
}

- (void) showAttacking
{
	[sprite_ stopAllActions];	
	
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)flameAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(doneAttacking)];	
	[self runAction:[CCSequence actions:animation, method, nil]];	
}

- (void) doneAttacking
{
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [gameLayer setRocketCondition:kRocketBurning];
    
    [self showIdle];
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
    [[AudioManager audioManager] playSound:kExplosion01];            
    
    [super showDestroy:kBamText];
    
    [super bulletHit];
}

- (void) collide
{
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [[AudioManager audioManager] playSound:kWerr];            
    [gameLayer slowDown:0.66];    
    
    [self showAttacking];
}

- (void) destroy
{
    GameLayer *gameLayer = (GameLayer *)[self parent];    
    [gameLayer removeObstacle:self];    
    
    [super destroy];
}
         
@end
