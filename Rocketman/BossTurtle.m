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
#import "EngineParticleSystem.h"

@implementation BossTurtle

static NSUInteger countID = 0;

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
        radius_ = 16;
        radiusSquared_ = radius_*radius_;        
        
        CGSize size = [[CCDirector sharedDirector] winSize];        
        leftCutoff_ = - 0.5 * size.width;
        rightCutoff_ = size.width + 0.5 * size.width;
        yTarget_ = 0.66 * size.height;
        
        movingLeft_ = YES;
        sprite_.flipX = YES;
        
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
            [self engineFlameGoingRight:YES];            
        }
        else {
            dx = 3;
        }
    }
    
    if (self.position.y > yTarget_) {
        dy = -1;
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

- (void) initEngineFlame
{
	engineFlame_ = [[EngineParticleSystem engineParticleSystem:500] retain];
	[self addChild:engineFlame_ z:-2];
    
    ccColor4B purple = ccc4(255, 20, 147, 255);
    ccColor4F c1 = ccc4FFromccc4B(purple);
    engineFlame_.startColor = c1;
    engineFlame_.endColor = c1;
    
    engineFlame_.startSize = 25.0f;
    engineFlame_.startSizeVar = 5.0f;
    engineFlame_.endSize = kCCParticleStartSizeEqualToEndSize;    
    
    // life of particles
    engineFlame_.life = 0.4f;
    engineFlame_.lifeVar = 0.1f;
    
    // emits per seconds
    engineFlame_.emissionRate = engineFlame_.totalParticles/engineFlame_.life;
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
