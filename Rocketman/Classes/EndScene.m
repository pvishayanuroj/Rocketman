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
        NSString *backgroundName = [NSString stringWithFormat:@"background_level%d.png", levelNum];
        CCSprite *bg = [CCSprite spriteWithFile:backgroundName];
        [self addChild:bg z:0];
        bg.anchorPoint = CGPointZero;        
        
        // Add foreground element
        NSString *foregroundName = [NSString stringWithFormat:@"parallax_level%d.png", levelNum];
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
        CCSprite *text = [CCSprite spriteWithFile:@"gameover_text.png"];
        text.position = CGPointMake(size.width * 0.5, size.height * 0.65);
        [self addChild:text z:3];
        
        // Score
        score_ = 0;
        finalScore_ = score;
        incrementSpeed_ = score/(ES_SCORE_TIME * 60);
        scoreLabel_ = [[CCLabelBMFont labelWithString:@"0" fntFile:@"SRSM_font.fnt"] retain];
        scoreLabel_.position =  CGPointMake(size.width * 0.5, size.height * 0.5);
        [self addChild:scoreLabel_ z:3];
        
        EndLayer *endLayer = [EndLayer node];
		[self addChild:endLayer z:4];                
        
        [self schedule:@selector(update:) interval:1.0/60.0];        
        
    }
    return self;
}   

- (void) dealloc
{
    [scoreLabel_ release];
    
    [super dealloc];
}

- (void) update:(ccTime)dt
{
    score_ += incrementSpeed_;
    if (score_ > finalScore_) {
        score_ = finalScore_;
    }
    
    [scoreLabel_ setString:[NSString stringWithFormat:@"%d", score_]];
}

@end
