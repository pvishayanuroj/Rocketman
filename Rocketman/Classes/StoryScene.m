//
//  StoryScene.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "StoryScene.h"
#import "StoryManager.h"
#import "AnimatedButton.h"

@implementation StoryScene

+ (id) storyWithName:(NSString *)name num:(NSUInteger)num duration:(CGFloat)duration
{
    return [[[self alloc] initWithName:name num:num duration:duration] autorelease];
}

- (id) initWithName:(NSString *)name num:(NSUInteger)num duration:(CGFloat)duration
{
    if ((self = [super init])) {
        
        // The actual scene image
        NSString *filename = [NSString stringWithFormat:@"%@ %02d.png", name, num];
        CCSprite *sprite = [CCSprite spriteWithFile:filename];
        sprite.anchorPoint = CGPointZero;
        [self addChild:sprite z:0];
        
        sceneDuration_ = duration;

        // Skip button
        AnimatedButton *skipButton = [AnimatedButton buttonWithImage:@"skip_button.png" target:self selector:@selector(skip)];
        skipButton.position = CGPointMake(280, 30);
        [self addChild:skipButton];
        /*
        CCMenuItemSprite *skipButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"skip_button.png"] selectedSprite:[CCSprite spriteWithFile:@"skip_button.png"] target:self selector:@selector(skip)];        
        CCMenu *menu = [CCMenu menuWithItems:skipButton, nil];
        menu.position = ccp(280, 30);
        [self addChild:menu z:2];        
         */\
    }
    return self;
}

- (void) dealloc
{
#if DEBUG_DEALLOCS
    NSLog(@"Story scene dealloc'd");
#endif
    
    [super dealloc];
}

- (void) startTimer
{
    CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:sceneDuration_];
    CCFiniteTimeAction *next = [CCCallFunc actionWithTarget:self selector:@selector(nextScene)];
    [self runAction:[CCSequence actions:delay, next, nil]];
}

- (void) nextScene
{
    [[StoryManager storyManager] nextScene];
}

- (void) skip
{
    [[StoryManager storyManager] endCutscene];
}

@end
