//
//  Alien.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Alien.h"
#import "TargetedAction.h"
#import "GameLayer.h"

@implementation Alien

+ (id) alienWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Alien Idle 01.png"] retain];
        [self addChild:sprite_];
        
        self.position = pos;
        
        // Attributes
        radius_ = 20;
        radiusSquared_ = radius_*radius_;        
        
        [self initActions];
        [self showIdle];        
        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [idleAnimation_ release];
    [destroyAnimation_ release];
    
    [super dealloc];
}

- (void) initActions
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Alien Idle"];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];	
	
	CCFiniteTimeAction *m1 = [CCCallFunc actionWithTarget:self selector:@selector(addCloud)];     
	CCFiniteTimeAction *m2 = [CCCallFunc actionWithTarget:self selector:@selector(addBlast)];
    //CCFiniteTimeAction *m3 = [CCDelayTime actionWithDuration:0.15];
	CCFiniteTimeAction *m4 = [CCCallFunc actionWithTarget:self selector:@selector(addText)];    
    CCFiniteTimeAction *m5 = [CCDelayTime actionWithDuration:0.3];    
	CCFiniteTimeAction *m6 = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];    
    destroyAnimation_ = [[CCSequence actions:m1, m2, m4, m5, m6, nil] retain];  
}                 

- (void) showIdle
{
	[sprite_ stopAllActions];
	[sprite_ runAction:idleAnimation_];	
}

- (void) showDestroy
{
	[sprite_ stopAllActions];
	[sprite_ runAction:destroyAnimation_];	    
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

- (void) addText
{
    CCSprite *text = [CCSprite spriteWithSpriteFrameName:@"Bam Text.png"];
    [self addChild:text];
    
    text.scale = 0.7;
}

- (void) bulletHit
{
    sprite_.visible = NO;
    shootable_ = NO;
    
    [self showDestroy];
}

- (void) collide
{
    [super collide];
    
    sprite_.visible = NO;
    
    [self showDestroy];
}

- (void) destroy
{
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [gameLayer removeObstacle:self];    
    
    [self removeFromParentAndCleanup:YES];
    
    [super destroy];
}

@end
