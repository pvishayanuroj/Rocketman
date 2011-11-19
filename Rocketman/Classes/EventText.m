//
//  EventText.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/19/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "EventText.h"
#import "TargetedAction.h"

@implementation EventText

const CGFloat ET_ANGLED_TEXT_ROTATION = 15.0f;
const CGFloat ET_ANGLED_TEXT_XOFFSET = 15.0f;
const CGFloat ET_ANGLED_TEXT_YOFFSET = 35.0f;
const CGFloat ET_ANGLED_TEXT_HOLD_DURATION = 0.2f;
const CGFloat ET_ANGLED_TEXT_FADE_DURATION = 0.5f;

const CGFloat ET_FADEUP_TEXT_FADE_DURATION = 0.2f;
const CGFloat ET_FADEUP_TEXT_TOTAL_DURATION = 0.8f;
const CGFloat ET_FADEUP_TEXT_MOVE_AMT = 30.0f;

+ (id) eventText:(ActionText)actionText
{
    return [[[self alloc] initEventText:actionText string:nil effect:kAngledText] autorelease];
}

+ (id) eventTextWithString:(NSString *)string
{
    return [[[self alloc] initEventText:kGivenText string:string effect:kFadeUpText] autorelease];
}

- (id) initEventText:(ActionText)actionText string:(NSString *)string effect:(TextEffectType)effect
{
    if ((self = [super init])) {
        
        sprite_ = nil;
        label_ = nil;
        
        if (actionText == kGivenText) {
            
            label_ = [[CCLabelBMFont labelWithString:string fntFile:@"SRSMWhiteFont.fnt"] retain];
            [self addChild:label_];
        }
        else {
            
            switch (actionText) {
                case kSpeedUp:
                    sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Speed Up Text.png"] retain];
                    break;
                case kSpeedDown:
                    sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Speed Down Text.png"] retain];            
                    break;
                case kCatPlus:
                    sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Cat Plus Text.png"] retain];            
                    break;
                case kBoostPlus:
                    sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Boosters Plus Text.png"] retain];            
                    break;
                default:
                    NSAssert(NO, @"Invalid action text type");
                    break;
            }
            
            [self addChild:sprite_];            
        }   
        
        switch (effect) {
            case kAngledText:
                [self showAngledText];
                break;
            case kFadeUpText:
                [self showFadeUpText];
                break;
            default:
                NSAssert(NO, @"Invalid action text effect type");                
                break;
        }
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [label_ release];
    
    [super dealloc];
}

- (void) destroy
{
    [self removeFromParentAndCleanup:YES];
}

- (void) showAngledText
{
    if (arc4random() % 2) {
        CGPoint p = CGPointMake(-ET_ANGLED_TEXT_XOFFSET, ET_ANGLED_TEXT_YOFFSET);
        self.position = ccpAdd(self.position, p);
        self.rotation = -ET_ANGLED_TEXT_ROTATION;        
    }
    else {
        CGPoint p = CGPointMake(ET_ANGLED_TEXT_XOFFSET, ET_ANGLED_TEXT_YOFFSET);        
        self.position = ccpAdd(self.position, p);            
        self.rotation = ET_ANGLED_TEXT_ROTATION;        
    }
    
    CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:ET_ANGLED_TEXT_HOLD_DURATION];
    CCFiniteTimeAction *fade = [CCFadeOut actionWithDuration:ET_ANGLED_TEXT_FADE_DURATION];
    
    CCFiniteTimeAction *textFade = nil;    
    if (sprite_) {
        textFade = [TargetedAction actionWithTarget:sprite_ actionIn:fade];
    }
    else if (label_) {
        textFade = [TargetedAction actionWithTarget:label_ actionIn:fade];
    }
    
    CCCallFunc *done = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
    [self runAction:[CCSequence actions:delay, textFade, done, nil]];    
}

- (void) showFadeUpText
{
    CGPoint moveAmt = CGPointMake(0, ET_FADEUP_TEXT_MOVE_AMT);
    CGFloat delayTime = ET_FADEUP_TEXT_TOTAL_DURATION - 2 * ET_FADEUP_TEXT_FADE_DURATION;

    CCActionInterval *fadeIn = [CCFadeIn actionWithDuration:ET_FADEUP_TEXT_FADE_DURATION];
    CCActionInterval *delay = [CCDelayTime actionWithDuration:delayTime];
    CCActionInterval *fadeOut = [CCFadeOut actionWithDuration:ET_FADEUP_TEXT_FADE_DURATION];
    CCActionInterval *moveUp = [CCMoveBy actionWithDuration:ET_FADEUP_TEXT_TOTAL_DURATION position:moveAmt];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];    
    
    CCActionInterval *fade = [CCSequence actions:fadeIn, delay, fadeOut, nil];
    CCActionInterval *move = [CCSequence actions:moveUp, done, nil];
    
    // Unfortunately CCNode does not have the opacity property
    if (sprite_) {
        sprite_.opacity = 0;
        [sprite_ runAction:fade];
    }
    else if (label_) {
        label_.opacity = 0;
        [label_ runAction:fade];
    }
    
    [self runAction:move];
}

@end
