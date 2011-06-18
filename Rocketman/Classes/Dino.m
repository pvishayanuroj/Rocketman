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
        radius_ = 30;
        radiusSquared_ = radius_*radius_;
        
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
    
    // Do not call super collide, so that wobble animation does not override burning animation
    collided_ = YES;
    shootable_ = NO;    
}

- (void) destroy
{
    GameLayer *gameLayer = (GameLayer *)[self parent];    
    [gameLayer removeObstacle:self];    
    
    [super destroy];
}
         
@end
