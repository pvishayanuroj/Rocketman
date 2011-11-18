//
//  DarkBlastCloud.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/1/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "DarkBlastCloud.h"
#import "StaticMovement.h"
#import "TargetedAction.h"

@implementation DarkBlastCloud

// Time for the blast, text, and cloud to scale up
const CGFloat DBC_SCALE_UP_TIME = 0.15f;
// Time for the blast and text to fade out
const CGFloat DBC_BLAST_FADE_TIME = 1.0f;
// Time at which the cloud is expanding and fading after the initial blast
const CGFloat DBC_CLOUD_EXPAND_TIME = 3.0f;
// Size which the cloud expands to after the intial blast
const CGFloat DBC_CLOUD_EXPAND_SCALE_FACTOR = 1.3f;
// The scale factor relative to the given size which the blast and text start at
const CGFloat DBC_BLAST_START_SCALE_FACTOR = 0.5f;
// How much to rotate the text (in degrees)
const CGFloat DBC_TEXT_ROTATE_AMT = 20.0f;
// How long it takes the text to rotate
const CGFloat DBC_TEXT_ROTATE_TIME = 0.3f;

+ (id) darkBlastCloudAt:(CGPoint)pos
{
    return [[[self alloc] initDarkBlastCloudAt:pos size:1.0f movements:nil] autorelease];
}

+ (id) darkBlastCloudAt:(CGPoint)pos size:(CGFloat)size movements:(NSMutableArray *)movements
{
    return [[[self alloc] initDarkBlastCloudAt:pos size:size movements:movements] autorelease];
}

- (id) initDarkBlastCloudAt:(CGPoint)pos size:(CGFloat)size movements:(NSMutableArray *)movements
{
    if ((self = [super init])) {
        
        self.position = pos;
        zDepth_ = kBlastCloudDepth;        
        
        [self addSprites:size];
        
        CCFiniteTimeAction *scaleBlast = [CCScaleTo actionWithDuration:DBC_SCALE_UP_TIME scale:size];
        CCFiniteTimeAction *scaleText = [CCScaleTo actionWithDuration:DBC_SCALE_UP_TIME scale:size];
        CCFiniteTimeAction *scaleCloud = [CCScaleTo actionWithDuration:DBC_SCALE_UP_TIME scale:size];
        CCFiniteTimeAction *rotateText = [CCRotateBy actionWithDuration:DBC_TEXT_ROTATE_TIME angle:DBC_TEXT_ROTATE_AMT];
        TargetedAction *t1 = [TargetedAction actionWithTarget:blast_ actionIn:scaleBlast];
        TargetedAction *t2 = [TargetedAction actionWithTarget:text_ actionIn:scaleText];
        TargetedAction *t3 = [TargetedAction actionWithTarget:smoke_ actionIn:scaleCloud];
        TargetedAction *t3a = [TargetedAction actionWithTarget:text_ actionIn:rotateText];        
        CCFiniteTimeAction *s1 = [CCSpawn actions:t1, t2, t3, t3a, nil];
        
        CCFiniteTimeAction *fadeBlast = [CCFadeOut actionWithDuration:DBC_BLAST_FADE_TIME];
        CCFiniteTimeAction *fadeText = [CCFadeOut actionWithDuration:DBC_BLAST_FADE_TIME];
        CCFiniteTimeAction *expandCloud = [CCScaleTo actionWithDuration:DBC_CLOUD_EXPAND_TIME scale:DBC_CLOUD_EXPAND_SCALE_FACTOR * size];
        CCFiniteTimeAction *fadeCloud = [CCFadeOut actionWithDuration:DBC_CLOUD_EXPAND_TIME];
        TargetedAction *t4 = [TargetedAction actionWithTarget:blast_ actionIn:fadeBlast];
        TargetedAction *t5 = [TargetedAction actionWithTarget:text_ actionIn:fadeText];
        TargetedAction *t6 = [TargetedAction actionWithTarget:smoke_ actionIn:expandCloud];                
        TargetedAction *t7 = [TargetedAction actionWithTarget:smoke_ actionIn:fadeCloud];                        
        CCFiniteTimeAction *s2 = [CCSpawn actions:t4, t5, t6, t7, nil];
        
        CCCallFunc *method = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
        [self runAction:[CCSequence actions:s1, s2, method, nil]];      
        
        for (Movement *movement in movements) {
            [movements_ addObject:[[movement copy] autorelease]];
        }    
    }
    return self;
}

- (void) dealloc
{
#if DEBUG_DEALLOCS
    NSLog(@"Dark Blast Cloud dealloc'd");
#endif
    [smoke_ release];
    [blast_ release];
    [text_ release];
    
    [super dealloc];
}

- (void) addSprites:(CGFloat)size
{
    smoke_ = [[CCSprite spriteWithSpriteFrameName:@"Big Explosion Smoke.png"] retain];    
    blast_ = [[CCSprite spriteWithSpriteFrameName:@"Big Explosion.png"] retain];        
    text_ = [[CCSprite spriteWithSpriteFrameName:@"Kaboom Text.png"] retain];

    smoke_.scale = 0.0f;
    blast_.scale = size * DBC_BLAST_START_SCALE_FACTOR;
    text_.scale = size * DBC_BLAST_START_SCALE_FACTOR;
    
    [self addChild:smoke_];
    [self addChild:blast_];
    [self addChild:text_];
}

- (void) destroy
{
    destroyed_ = YES;
}


@end
