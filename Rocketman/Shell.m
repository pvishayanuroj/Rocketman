//
//  Shell.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/1/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Shell.h"
#import "GameLayer.h"

@implementation Shell

static NSUInteger countID = 0;

+ (id) shellWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;                
        
        sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Alien Idle 01.png"] retain];
        [self addChild:sprite_ z:-1];
        
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
#if DEBUG_DEALLOCS
    NSLog(@"%@ dealloc'd", self);    
#endif
    
    [sprite_ release];
    [idleAnimation_ release];
    
    [super dealloc];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Turtle %d", unitID_];
}    

- (void) initActions
{
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Turtle Idle"];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];	
}                 

- (void) showIdle
{
	[sprite_ stopAllActions];
	[sprite_ runAction:idleAnimation_];	
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
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [gameLayer playSound:kPlop];        
    
    [super showDestroy];
    
    [super bulletHit];
}

- (void) collide
{
    sprite_.visible = NO;    
    
    GameLayer *gameLayer = (GameLayer *)[self parent];
    [gameLayer playSound:kWerr];                
    [gameLayer slowDown:0.66];    
    
    [super showDestroy];
    
    [super collide];    
}

- (void) destroy
{    
    [super destroy];
}

@end
