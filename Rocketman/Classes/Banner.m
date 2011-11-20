//
//  Banner.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Banner.h"
#import "TargetedAction.h"

@implementation Banner

const CGFloat BN_START_X = 500.0f;
const CGFloat BN_END_X = -500.0f;
const CGFloat BN_MOVE_DUR = 0.5f;

@synthesize clickable = clickable_;
@synthesize delegate = delegate_;

#pragma mark - Object Lifecycle

+ (id) banner:(NSString *)bannerName delay:(CGFloat)delay
{
    return [[[self alloc] initBanner:bannerName delay:delay] autorelease];
}

- (id) initBanner:(NSString *)bannerName delay:(CGFloat)delay
{
    if ((self = [super init])) {
        
        delegate_ = nil;
        clickable_ = YES;
        
        NSString *path = [NSString stringWithString:bannerName];
        if (![[bannerName substringFromIndex:[bannerName length] - 4] isEqualToString:@".png"]) {
            path = [[NSBundle mainBundle] pathForResource:bannerName ofType:@"png"];
        }
            
        sprite_ = [[CCSprite spriteWithFile:path] retain];
        sprite_.position = CGPointMake(BN_START_X, 0);
        [self addChild:sprite_];
        
        if (delay > 0) {
            [self delayedMoveIn:delay];
        }
        else {
            [self moveIn];
        }
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
}

#pragma mark - Animations

- (void) moveIn
{
    CCActionInterval *left = [CCMoveTo actionWithDuration:BN_MOVE_DUR position:CGPointZero];
    CCActionInterval *easeLeft = [CCEaseIn actionWithAction:left rate:2.0];    
    [sprite_ runAction:easeLeft];
}

- (void) delayedMoveIn:(CGFloat)delay
{
    CCDelayTime *wait = [CCDelayTime actionWithDuration:delay];
    CCActionInterval *left = [CCMoveTo actionWithDuration:BN_MOVE_DUR position:CGPointZero];
    CCActionInterval *easeLeft = [CCEaseIn actionWithAction:left rate:2.0];    
    [sprite_ runAction:[CCSequence actions: wait, easeLeft, nil]];  
}

- (void) moveOut
{
    CCActionInterval *left = [CCMoveTo actionWithDuration:BN_MOVE_DUR position:CGPointMake(BN_END_X, 0)];
    CCActionInterval *easeLeft = [CCEaseIn actionWithAction:left rate:2.0];       
    TargetedAction *action = [TargetedAction actionWithTarget:sprite_ actionIn:easeLeft];
    CCCallFunc *done = [CCCallFunc actionWithTarget:self selector:@selector(doneMoving)];    
    [self runAction:[CCSequence actions:action, done, nil]];
}

- (void) doneMoving
{
    [delegate_ bannerClosed];
}

#pragma mark - Touch Handlers

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
	if ([self containsTouchLocation:touch] && clickable_ && [delegate_ bannerClicked]) {
		return YES;
    }
    
	return NO;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{

}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if ([self containsTouchLocation:touch]) {
        [self moveOut];
    }
}

@end

