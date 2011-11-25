//
//  EndScene.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "EndScene.h"
#import "EndLayer.h"
#import "EngineParticleSystem.h"
#import "IncrementingText.h"

@implementation EndScene

const CGFloat ES_SCORE_TIME = 2.0f;

+ (id) endSceneWithLevel:(NSUInteger)levelNum score:(NSUInteger)score
{
    return [[[self alloc] initEndSceneWithLevel:levelNum score:score] autorelease];
}

- (id) initEndSceneWithLevel:(NSUInteger)levelNum score:(NSUInteger)score
{
    if ((self = [super init])) {
    
        // Add background sky
        NSString *backgroundName = [NSString stringWithFormat:@"Sky Background.png"];
        CCSprite *bg = [CCSprite spriteWithFile:backgroundName];
        [self addChild:bg z:0];
        bg.anchorPoint = CGPointZero;        
        
        // Add foreground element
        NSString *foregroundName = [NSString stringWithFormat:@"Mountains Parallax.png"];
        CCSprite *fg = [CCSprite spriteWithFile:foregroundName];
        fg.anchorPoint = CGPointZero;
        [self addChild:fg z:1];

        // Wrecked ship & smoke
        CCParticleSystem *smoke = [EngineParticleSystem PSForBrokenRocket];
        smoke.position = CGPointMake(200, 15);
        [self addChild:smoke z:2];        
        
        CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Rocket2 Stuck"];
        CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
        CCAction *wreckedAnimation = [CCRepeatForever actionWithAction:animate];	
        
        CCSprite *wreck = [CCSprite spriteWithSpriteFrameName:@"Rocket2 Stuck 01.png"];
        [self addChild:wreck z:3];
        wreck.position = CGPointMake(200, 15);
        [wreck runAction:wreckedAnimation];
        
        // Game over text
		CGSize size = [[CCDirector sharedDirector] winSize];        
        CCSprite *text = [CCSprite spriteWithFile:R_GAME_OVER_TEXT];
        text.position = CGPointMake(size.width * 0.5, size.height * 0.65);
        [self addChild:text z:3];
        
        // Score
        IncrementingText *scoreText = [IncrementingText incrementingText:score font:R_DARK_FONT alignment:kCenterAligned isTime:NO];
        scoreText.position =  CGPointMake(size.width * 0.5f, size.height * 0.5f);
        [self addChild:scoreText z:3];
        
        EndLayer *endLayer = [EndLayer node];
		[self addChild:endLayer z:4];                
    }
    return self;
}   

- (void) dealloc
{
    [super dealloc];
}

@end
