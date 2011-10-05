//
//  MapButton.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/4/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "MapButton.h"

@implementation MapButton

@synthesize isLocked = isLocked_;
@synthesize levelNum = levelNum_;
@synthesize delegate = delegate_;

CGFloat MB_SHRUNK_SCALE = 0.75f;
CGFloat MB_NORMAL_SCALE = 1.0f;

#pragma mark - Object Lifecycle

+ (id) mapButton:(NSUInteger)levelNum locked:(BOOL)locked
{
    return [[[self alloc] initMapButton:levelNum locked:locked] autorelease];
}

- (id) initMapButton:(NSUInteger)levelNum locked:(BOOL)locked
{
    if ((self = [super init])) {
    
        delegate_ = nil;
        
        NSString *filename;
        
        if (locked) {
            filename = [NSString stringWithFormat:@"Stage %02d Locked.png", levelNum];        
        }
        else {
            filename = [NSString stringWithFormat:@"Stage %02d.png", levelNum];
        }
        
        sprite_ = [[CCSprite spriteWithFile:filename] retain];
        [self addChild:sprite_];
        sprite_.scale = MB_NORMAL_SCALE;
        
        levelNum_ = levelNum;
        isLocked_ = locked;
        isShrunk_ = NO;
        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    
    [super dealloc];
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
	if (![self containsTouchLocation:touch])
		return NO;
    
    [self shrink];
	return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Moved onto the button
	if ([self containsTouchLocation:touch]) {
        if (!isShrunk_) {
            [self shrink];
        }
    }
    // Moved off of the button
    else {
        if (isShrunk_) {
            [self unshrink];
        }
    }
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [self unshrink];
	if ([self containsTouchLocation:touch]) {
        [delegate_ mapButtonPressed:self];
    }
}

#pragma mark - Object Manipulation Methods

- (void) shrink
{
    sprite_.scale = MB_SHRUNK_SCALE;
    isShrunk_ = YES;
}

- (void) unshrink
{
    sprite_.scale = MB_NORMAL_SCALE;
    isShrunk_ = NO;
}

@end
