//
//  BossTurtle.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "BossTurtle.h"
#import "TargetedAction.h"
#import "GameLayer.h"
#import "GameManager.h"
#import "EngineParticleSystem.h"
#import "AudioManager.h"
#import "BlastCloud.h"

@implementation BossTurtle

static NSUInteger countID = 0;

#pragma mark - Object Lifecycle

+ (id) bossTurtleWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;                
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"BossTurtle Fly 01.png"] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        HP_ = 8;
        collision_.radius = 64;
        collision_.radiusSquared = collision_.radius * collision_.radius;        
        
        CGSize size = [[CCDirector sharedDirector] winSize];        
        leftCutoff_ = - 0.5 * size.width;
        rightCutoff_ = size.width + 0.5 * size.width;
        yTarget_ = 0.80 * size.height;
        
        movingLeft_ = YES;
        deployedShells_ = NO;
        sprite_.flipX = YES;
        numShells_ = 0;
        maxShells_ = 6;
        
        [self initActions];
        [self showIdle];        
        
        [self initEngineFlame];
        [self engineFlameGoingRight:YES];
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
    [damageAnimation_ release];
    [engineFlame_ release];
    
    [super dealloc];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Boss Turtle %d", unitID_];
}    

- (void) initActions
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"BossTurtle Fly"];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];
	
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"BossTurtle Damage"];
	damageAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];    
}                 

- (void) showIdle
{
	[sprite_ stopAllActions];
	[sprite_ runAction:idleAnimation_];	
}

- (void) showDamage
{
	[sprite_ stopAllActions];	
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:0.5];
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)damageAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(showIdle)];	
	[self runAction:[CCSequence actions:animation, delay, method, nil]];	
}

- (void) startShellSequence
{
    CCActionInterval *delay = [CCDelayTime actionWithDuration:0.1];
    CCFiniteTimeAction *deploy = [CCCallFunc actionWithTarget:self selector:@selector(deployShell)];
    CCActionInterval *seq = [CCSequence actions:deploy, delay, nil];
    [self runAction:[CCRepeat actionWithAction:seq times:maxShells_]];
}

- (void) startDeathSequence
{
    CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:0.05];
    CCFiniteTimeAction *blast = [CCCallFunc actionWithTarget:self selector:@selector(addBlast)];
    CCFiniteTimeAction *seq = [CCSequence actions:blast, delay, nil];
    CCFiniteTimeAction *repeat = [CCRepeat actionWithAction:seq times:100];
    CCFiniteTimeAction *end = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
    [self runAction:[CCSequence actions:repeat, end, nil]];
}

- (void) deployShell
{
    [[GameManager gameManager] addShell:self.position];
}

- (void) addBlast
{
    CGPoint pos;
    
    // Randomize
    NSInteger x = 150;
    NSInteger y = 100;
    pos.x = arc4random() % x;
    pos.y = arc4random() % y;
    // Weirdest issue - combining these two operations does not seem to work
    pos.x -= x/2;
    pos.y -= y/2;
    
    BlastCloud *blast = [BlastCloud blastCloudAt:pos size:1.0 text:kBamText];
    [self addChild:blast];
    
    if (arc4random() % 100 < 25) {
        [[AudioManager audioManager] playSound:kExplosion01];
    }
}

- (void) fall:(CGFloat)speed
{
    CGFloat dx;
    CGFloat dy = 0;

    if (movingLeft_) {
        if (self.position.x < leftCutoff_) {
            movingLeft_ = NO;
            sprite_.flipX = NO;           
            deployedShells_ = NO;            
            [self engineFlameGoingRight:NO];
        }
        else {
            dx = -3;
        }
    }
    else {
        if (self.position.x > rightCutoff_) {
            movingLeft_ = YES;
            sprite_.flipX = YES; 
            deployedShells_ = NO;
            [self engineFlameGoingRight:YES];            
        }
        else {
            dx = 3;
        }
    }
        
    // Only launch shells if not in death sequence
    if (shootable_) {
        if (self.position.y > yTarget_) {
            dy = -1;
        }
        // Deploy shells each turn
        else {
            if (!deployedShells_) {
                CGFloat xTrigger = 160;
                if ((movingLeft_ && self.position.x < xTrigger) || (!movingLeft_ && self.position.x > xTrigger)) {
                    deployedShells_ = YES;
                    [self startShellSequence];                
                }
            }
        }
    }
    
    // When dying, slow down
    if (!shootable_) {
        dx *= 0.3;
    }
        
    CGPoint p = CGPointMake(dx, dy);
    self.position = ccpAdd(self.position, p);    
}

- (void) bulletHit
{
    // Creature death
    if (--HP_ == 0) {
        shootable_ = NO;         
        engineFlame_.emissionRate = 0;
        [self startDeathSequence];
    }
    else {
        [self showDamage];        
    }
}

- (void) collide
{    
    [super collide];    
}

- (void) destroy
{    
    GameLayer *gameLayer = (GameLayer *)[self parent];    
    [gameLayer removeObstacle:self];     
    
    [super destroy];
}

#pragma mark - Particle System

- (void) initEngineFlame
{
    engineFlame_ = [[EngineParticleSystem PSForBossTurtleFlame] retain];
	[self addChild:engineFlame_ z:-2];
}

- (void) engineFlameGoingRight:(BOOL)right
{
    if (right) {
        engineFlame_.gravity = ccp(50, 0);
        engineFlame_.position = ccp(80, 27);
    }
    else {
        engineFlame_.gravity = ccp(-50, 0);
        engineFlame_.position = ccp(-80, 27);
    }
}

@end
