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

+ (id) darkBlastCloudAt:(CGPoint)pos
{
    return [[[self alloc] initDarkBlastCloudAt:pos size:1.0f movement:kStaticMovement] autorelease];
}

+ (id) darkBlastCloudAt:(CGPoint)pos size:(CGFloat)size movement:(MovementType)movement
{
    return [[[self alloc] initDarkBlastCloudAt:pos size:size movement:movement] autorelease];
}

- (id) initDarkBlastCloudAt:(CGPoint)pos size:(CGFloat)size movement:(MovementType)movement
{
    if ((self = [super init])) {
        
        self.position = pos;
        
        [self addSprites:size];
        
        CCFiniteTimeAction *scaleBlast = [CCScaleTo actionWithDuration:0.15 scale:1.0];
        CCFiniteTimeAction *scaleText = [CCScaleTo actionWithDuration:0.15 scale:1.0];
        CCFiniteTimeAction *scaleCloud = [CCScaleTo actionWithDuration:0.15 scale:1.0];
        CCFiniteTimeAction *rotateText = [CCRotateBy actionWithDuration:0.3 angle:20];
        TargetedAction *t1 = [TargetedAction actionWithTarget:blast_ actionIn:scaleBlast];
        TargetedAction *t2 = [TargetedAction actionWithTarget:text_ actionIn:scaleText];
        TargetedAction *t3 = [TargetedAction actionWithTarget:smoke_ actionIn:scaleCloud];
        TargetedAction *t3a = [TargetedAction actionWithTarget:text_ actionIn:rotateText];        
        CCFiniteTimeAction *s1 = [CCSpawn actions:t1, t2, t3, t3a, nil];
        
        CCFiniteTimeAction *fadeBlast = [CCFadeOut actionWithDuration:1.0];
        CCFiniteTimeAction *fadeText = [CCFadeOut actionWithDuration:1.0];
        CCFiniteTimeAction *expandCloud = [CCScaleTo actionWithDuration:3.0 scale:1.3];
        CCFiniteTimeAction *fadeCloud = [CCFadeOut actionWithDuration:3.0];
        TargetedAction *t4 = [TargetedAction actionWithTarget:blast_ actionIn:fadeBlast];
        TargetedAction *t5 = [TargetedAction actionWithTarget:text_ actionIn:fadeText];
        TargetedAction *t6 = [TargetedAction actionWithTarget:smoke_ actionIn:expandCloud];                
        TargetedAction *t7 = [TargetedAction actionWithTarget:smoke_ actionIn:fadeCloud];                        
        CCFiniteTimeAction *s2 = [CCSpawn actions:t4, t5, t6, t7, nil];
        
        CCCallFunc *method = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
        [self runAction:[CCSequence actions:s1, s2, method, nil]];      
        
        if (movement == kStaticMovement) {
            [movements_ addObject:[StaticMovement staticMovement]];
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
    
    smoke_.scale = 0.01;
    //smoke_.opacity = 0;
    blast_.scale = 0.5;
    text_.scale = 0.5;
    
    [self addChild:smoke_];
    [self addChild:blast_];
    [self addChild:text_];
}

- (void) destroy
{
    destroyed_ = YES;
}


@end
