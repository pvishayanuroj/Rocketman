//
//  StoryScene.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "StoryScene.h"
#import "StoryLayer.h"
#import "StoryManager.h"

@implementation StoryScene

+ (id) storyWithName:(NSString *)name num:(NSUInteger)num
{
    return [[[self alloc] initWithName:name num:num] autorelease];
}

- (id) initWithName:(NSString *)name num:(NSUInteger)num
{
    if ((self = [super init])) {
        
        NSString *filename = [NSString stringWithFormat:@"%@ %02d.png", name, num];
        CCSprite *sprite = [CCSprite spriteWithFile:filename];
        sprite.anchorPoint = CGPointZero;
        [self addChild:sprite];
        
        StoryLayer *storyLayer = [StoryLayer node];
        [self addChild:storyLayer z:1];

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
    CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:5.0];
    CCFiniteTimeAction *next = [CCCallFunc actionWithTarget:self selector:@selector(nextScene)];
    [self runAction:[CCSequence actions:delay, next, nil]];
}

- (void) nextScene
{
    [[StoryManager storyManager] nextScene];
}

@end
