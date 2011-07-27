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

+ (id) endSceneWithLevel:(NSUInteger)levelNum score:(NSUInteger)score
{
    return [[[self alloc] initEndSceneWithLevel:levelNum score:score] autorelease];
}

- (id) initEndSceneWithLevel:(NSUInteger)levelNum score:(NSUInteger)score
{
    if ((self = [super init])) {
    
        // Background
        NSString *backgroundName = [NSString stringWithFormat:@"parallax_level%d.png", levelNum];
        CCSprite *bg = [CCSprite spriteWithFile:backgroundName];
        bg.anchorPoint = CGPointZero;
        [self addChild:bg z:0];

        // Wrecked ship & smoke
        CCParticleSystem *smoke = [EngineParticleSystem PSForBrokenRocket];
        smoke.position = CGPointMake(200, 15);
        [self addChild:smoke z:1];        
        
        // Game over text
		CGSize size = [[CCDirector sharedDirector] winSize];        
        CCSprite *text = [CCSprite spriteWithFile:@"gameover_text.png"];
        text.position = CGPointMake(size.width * 0.5, size.height * 0.6);
        [self addChild:text z:3];
        
        EndLayer *endLayer = [EndLayer node];
		[self addChild:endLayer z:4];                
        
    }
    return self;
}
@end
