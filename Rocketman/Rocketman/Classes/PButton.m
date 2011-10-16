//
//  PButton.m
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/23/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "PButton.h"

@implementation PButton

@synthesize placementSpriteDrawOffset = placementSpriteDrawOffset_;

+ (id) pButton:(NSString *)buttonImage toggledImage:(NSString *)toggledImage buttonType:(ButtonType)buttonType withDelegate:(id <PButtonDelegate>)delegate
{
	return [[[self alloc] initPButton:buttonImage toggledImage:toggledImage buttonType:buttonType withDelegate:delegate] autorelease];
}

- (id) initPButton:(NSString *)buttonImage toggledImage:(NSString *)toggledImage buttonType:(ButtonType)buttonType withDelegate:(id <PButtonDelegate>)delegate
{
	if ((self = [super init])) {
		
        delegate_ = delegate;
		buttonType_ = buttonType;        
        
		toggledSprite_ = [[CCSprite spriteWithFile:toggledImage] retain];
		
		sprite_ = [[CCSprite spriteWithFile:buttonImage] retain];
		[self addChild:sprite_];		        
        
	}
	return self;
}

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

    if (buttonType_ == kLeftButton) {
        [delegate_ leftButtonPressed];
	}
    else if (buttonType_ == kRightButton) {
        [delegate_ rightButtonPressed];
    }
    
	return YES;
}

- (void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{

}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{	
    if (buttonType_ == kLeftButton) {
        [delegate_ leftButtonDepressed];
	}
    else if (buttonType_ == kRightButton) {
        [delegate_ rightButtonDepressed];
    }
}

- (void) dealloc
{	
	[sprite_ release];
	[toggledSprite_ release];
	
	[super dealloc];
}

@end
