//
//  Button.m
//  RocketmanLE
//
//  Created by Paul Vishayanuroj on 9/17/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Button.h"

@implementation Button

@synthesize numID = numID_;
@synthesize delegate = delegate_;
@synthesize isSelected = isSelected_;

#pragma mark - Object Lifecycle

+ (id) button:(NSUInteger)numID toggle:(BOOL)toggle
{
    return [[[self alloc] initButton:numID toggle:toggle] autorelease];
}

- (id) initButton:(NSUInteger)numID toggle:(BOOL)toggle
{
    if ((self = [super init])) {
        
        delegate_ = nil;        
        numID_ = numID;
        isSelected_ = NO;
        isClickable_ = YES;
        isToggleButton_ = toggle; 

    }
    return self;
}

- (void) dealloc
{
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

- (CGRect) rect
{
    NSAssert(NO, @"Rect method must be implemented for child class");
    return CGRectMake(0, 0, 0, 0);
}

- (BOOL) containsTouchLocation:(UITouch *)touch
{	
	return CGRectContainsPoint([self rect], [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{	
    if (isClickable_) {    
        if ([self containsTouchLocation:touch]) {
            // If not a toggle button, show the selection right away
            // Otherwise wait for end touch to select for toggle buttons
            if (!isToggleButton_) {
                [self selectButton];
            }
            return YES;
        }
    }
    return NO;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if ([self containsTouchLocation:touch])	{
        // Non-toggle buttons get unselected
        // Toggle buttons become selected
        if (!isToggleButton_) {
            [self unselectButton];
        }
        else {
            [self selectButton];
        }
        [delegate_ buttonClicked:self];
	}
}

#pragma mark - Protocol Methods

- (void) clickable:(BOOL)b
{
    isClickable_ = b;
}

#pragma mark - Object Manipulators

- (void) selectButton
{
    NSAssert(NO, @"SelectButton method must be implemented for child class");    
}

- (void) unselectButton
{
    NSAssert(NO, @"UnselectButton method must be implemented for child class");    
}

@end


@implementation ImageButton

#pragma mark - Object Lifecycle

+ (id) imageButton:(NSUInteger)numID unselectedImage:(NSString *)unselected selectedImage:(NSString *)selected
{
    return [[[self alloc] initImageButton:numID unselectedImage:unselected selectedImage:selected toggle:NO] autorelease];
}

+ (id) imageToggleButton:(NSUInteger)numID unselectedImage:(NSString *)unselected selectedImage:(NSString *)selected
{
    return [[[self alloc] initImageButton:numID unselectedImage:unselected selectedImage:selected toggle:YES] autorelease];    
}

- (id) initImageButton:(NSUInteger)numID unselectedImage:(NSString *)unselected selectedImage:(NSString *)selected toggle:(BOOL)toggle
{
    if ((self = [super initButton:numID toggle:toggle])) {
        
        sprite_ = [[CCSprite spriteWithFile:unselected] retain];
        selected_ = [[CCSprite spriteWithFile:selected] retain];        
        
        sprite_.visible = !isSelected_;
        selected_.visible = isSelected_;        
        
        [self addChild:sprite_];
        [self addChild:selected_];        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [selected_ release];
    
    [super dealloc];
}

- (void) selectButton
{
    isSelected_ = YES;
    sprite_.visible = !isSelected_;
    selected_.visible = isSelected_;         
}

- (void) unselectButton
{
    isSelected_ = NO;
    sprite_.visible = !isSelected_;
    selected_.visible = isSelected_;     
}

- (CGRect) rect
{
	CGRect r = sprite_.textureRect;    
	return CGRectMake(sprite_.position.x - r.size.width / 2, sprite_.position.y - r.size.height / 2, r.size.width, r.size.height);
}

@end


@implementation TextButton

#pragma mark - Object Lifecycle

+ (id) textButton:(NSUInteger)numID text:(NSString *)text
{
    return [[[self alloc] initTextButton:numID text:text toggle:NO] autorelease];
}

+ (id) textToggleButton:(NSUInteger)numID text:(NSString *)text
{
    return [[[self alloc] initTextButton:numID text:text toggle:YES] autorelease];
}

- (id) initTextButton:(NSUInteger)numID text:(NSString *)text toggle:(BOOL)toggle
{
    if ((self = [super initButton:numID toggle:toggle])) {
        
        text_ = [[CCLabelTTF labelWithString:text fontName:@"Marker Felt" fontSize:32] retain];    
        [self addChild:text_];
    }
    return self;
}

- (void) dealloc
{
    [text_ release];
    
    [super dealloc];
}

- (void) selectButton
{
    isSelected_ = YES;
    text_.color = ccc3(255, 255, 255);
}

- (void) unselectButton
{
    isSelected_ = NO;    
    text_.color = ccc3(140, 140, 140);    
}

- (CGRect) rect
{
	CGRect r = text_.textureRect;    
	return CGRectMake(text_.position.x - r.size.width / 2, text_.position.y - r.size.height / 2, r.size.width, r.size.height);
}

@end
