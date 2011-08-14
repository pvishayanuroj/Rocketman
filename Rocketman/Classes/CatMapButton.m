//
//  CatMapButton.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CatMapButton.h"
#import "CallFuncWeak.h"
#import "AudioManager.h"

@implementation CatMapButton

@synthesize levelNum = levelNum_;
@synthesize delegate = delegate_;

const CGFloat CB_BUTTON_SCALE = 0.8f;
const CGFloat CB_BUTTON_SCALE_BIG = 1.0f;

#pragma mark - Object Lifecycle

+ (id) inactiveButtonAt:(CGPoint)pos levelNum:(NSUInteger)levelNum
{
    return [[[self alloc] initInactiveButtonAt:pos levelNum:levelNum] autorelease];
}

+ (id) activeButtonAt:(CGPoint)pos levelNum:(NSUInteger)levelNum
{
    return [[[self alloc] initActiveButtonAt:pos levelNum:levelNum] autorelease];
}

- (id) initInactiveButtonAt:(CGPoint)pos levelNum:(NSUInteger)levelNum
{
    if ((self = [self initButton:pos levelNum:levelNum])) {
        
        buttonType_ = kInactiveButton;
        
        sprite_ = [CCSprite spriteWithFile:@"map_cat_inactive.png"];
        sprite_.scale = CB_BUTTON_SCALE;
        [self addChild:sprite_];
    }
    return self;    
}

- (id) initActiveButtonAt:(CGPoint)pos levelNum:(NSUInteger)levelNum
{
    if ((self = [self initButton:pos levelNum:levelNum])) {
        
        buttonType_ = kActiveButton;
        
        sprite_ = [CCSprite spriteWithFile:@"map_cat_active.png"];
        sprite_.scale = CB_BUTTON_SCALE;        
        [self addChild:sprite_];   
    }
    return self;
}

- (id) initButton:(CGPoint)pos levelNum:(NSUInteger)levelNum
{
    if ((self = [super init])) {
        
        self.position = pos;
        levelNum_ = levelNum;
        isLocked_ = NO;
        isPulsing_ = NO;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

#pragma mark - Touch Related Methods

- (void) onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
	[super onEnter];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

- (BOOL) containsTouchLocation:(UITouch *)touch
{
	CGRect r = sprite_.textureRect;	
	r = CGRectMake(sprite_.position.x - r.size.width / 2, sprite_.position.y - r.size.height / 2, r.size.width, r.size.height);	
	
	return CGRectContainsPoint(r, [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (![self containsTouchLocation:touch] || isLocked_) {
		return NO;
    }
	return YES;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{	
	if ([self containsTouchLocation:touch]) {     
        if (buttonType_ == kInactiveButton) {
            [self pop];
            [[AudioManager audioManager] playSound:kMeow];
        }
        else {
            [delegate_ catButtonPressed:self];
        }
    }
}

- (void) lock
{
    isLocked_ = YES;
}

- (void) unlock
{
    isLocked_ = NO;
}

#pragma mark - Animation Methods

- (void) pop
{
    CGFloat duration = 0.07;
    CCActionInterval *grow = [CCScaleTo actionWithDuration:duration scale:CB_BUTTON_SCALE_BIG];
    CCActionInterval *shrink = [CCScaleTo actionWithDuration:duration scale:CB_BUTTON_SCALE];
    [sprite_ stopAllActions];
    [sprite_ runAction:[CCSequence actions:grow, shrink, nil]];
}

- (void) selectSpin
{
    if (isPulsing_) {
        sprite_.scale = CB_BUTTON_SCALE;
    }
    
    CCActionInterval *animate = [CCRotateBy actionWithDuration:2.0 angle:360];
	CCAction *spin = [CCRepeatForever actionWithAction:animate];	    
	[sprite_ stopAllActions];
	[sprite_ runAction:spin];	    
}

- (void) stopSpin
{
    [sprite_ stopAllActions];
    if (isPulsing_) {
        [self setToPulse];
    }
}

- (void) setToPulse
{
    CGFloat duration = 0.2;
    CGFloat delay = 0.1;
    CCActionInterval *grow = [CCScaleTo actionWithDuration:duration scale:CB_BUTTON_SCALE];
    CCActionInterval *growEase = [CCEaseIn actionWithAction:grow rate:2.0];
    CCActionInterval *shrink = [CCScaleTo actionWithDuration:duration scale:CB_BUTTON_SCALE_BIG];    
    CCActionInterval *shrinkEase = [CCEaseIn actionWithAction:shrink rate:2.0];    
    CCActionInterval *delay1 = [CCDelayTime actionWithDuration:delay];
    CCActionInterval *delay2 = [CCDelayTime actionWithDuration:delay];    
    CCAction *pulse = [CCRepeatForever actionWithAction:[CCSequence actions:growEase, delay1, shrinkEase, delay2, nil]];
    [sprite_ stopAllActions];
    [sprite_ runAction:pulse];
    
    isPulsing_ = YES;
}

- (void) disappearSpin
{
    CGFloat duration = 1.4;
    CCActionInterval *spin = [CCRotateBy actionWithDuration:duration angle:360*4];
    CCActionInterval *spinEase = [CCEaseIn actionWithAction:spin rate:1.0];
    CCActionInterval *shrink = [CCScaleTo actionWithDuration:duration scale:0.01];
    CCActionInterval *combined = [CCSpawn actions:spinEase, shrink, nil];
    CCActionInstant *method = [CallFuncWeak actionWithTarget:self selector:@selector(disappearComplete)];
    [sprite_ stopAllActions];
    [sprite_ runAction:[CCSequence actions:combined, method, nil]];
}

- (void) disappearComplete
{
    [delegate_ catButtonSpinComplete:self];
}

@end
