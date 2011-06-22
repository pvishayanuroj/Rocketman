//
//  Angel.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Angel.h"
#import "TargetedAction.h"
#import "GameLayer.h"
#import "AudioManager.h"

@implementation Angel

static NSUInteger countID = 0;

+ (id) angelWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;                        
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Angel2 Idle 01.png"] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        shootable_ = NO;
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
    [slapAnimation_ release];
    
    [super dealloc];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Angel %d", unitID_];
}    

- (void) initActions
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Angel2 Idle"];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];		
    
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Angel2 Kiss"];
	slapAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];
}   

- (void) showIdle
{
	[sprite_ stopAllActions];
	[sprite_ runAction:idleAnimation_];	
}

- (void) showAttacking
{
	[sprite_ stopAllActions];	

    //CCActionInterval *delay = [CCDelayTime actionWithDuration:0.5];
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)slapAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(doneAttacking)];	
	[self runAction:[CCSequence actions:animation, method, nil]];	
}

- (void) doneAttacking
{
    CCActionInterval *delay = [CCDelayTime actionWithDuration:0.7];
    CCActionInstant *method = [CCCallFunc actionWithTarget:self selector:@selector(showIdle)];
    [self runAction:[CCSequence actions:delay, method, nil]];
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
    [gameLayer setRocketCondition:kRocketHearts];
    [gameLayer engageFixedBoost:12 amt:12 rate:0 time:3.0];
    
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
