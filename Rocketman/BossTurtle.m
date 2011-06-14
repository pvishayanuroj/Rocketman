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
        radius_ = 64;
        radiusSquared_ = radius_*radius_;        
        
        CGSize size = [[CCDirector sharedDirector] winSize];        
        leftCutoff_ = - 0.5 * size.width;
        rightCutoff_ = size.width + 0.5 * size.width;
        yTarget_ = 0.66 * size.height;
        
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

- (void) deployShell
{
    [[GameManager gameManager] addShell:self.position];
}

- (void) addCloud
{
    CCSprite *blastCloud = [CCSprite spriteWithSpriteFrameName:@"Blast Cloud.png"];
    [self addChild:blastCloud];
    blastCloud.scale = 1.2;
}

- (void) addBlast
{
    CCSprite *blast = [CCSprite spriteWithSpriteFrameName:@"Blast.png"];   
    [self addChild:blast];    
}

- (void) addText:(id)node data:(void *)data
{
    EventText text = (EventText)data;
    CCSprite *textSprite;
    
    switch (text) {
        case kBamText:
            textSprite = [CCSprite spriteWithSpriteFrameName:@"Bam Text.png"];            
            break;
        case kPlopText:
            textSprite = [CCSprite spriteWithSpriteFrameName:@"Plop Text.png"];            
            break;            
        default:
            textSprite = [CCSprite spriteWithSpriteFrameName:@"Bam Text.png"];            
    }
    
    [self addChild:textSprite];
    
    textSprite.scale = 0.7;
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
    
    CGPoint p = CGPointMake(dx, dy);
    self.position = ccpAdd(self.position, p);    
}

- (void) bulletHit
{
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [gameLayer playSound:kPlop];        
    
    [self showDamage];
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
