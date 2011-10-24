//
//  HUDLayer.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "HUDLayer.h"
#import "GameLayer.h"
#import "GameScene.h"
#import "Button.h"
#import "GameManager.h"

@implementation HUDLayer

@synthesize delegate = delegate_;

#pragma mark - Object Lifecycle

- (id) init
{
	if ((self = [super init])) {
        
        delegate_ = nil;
        
        [[GameManager gameManager] registerHUDLayer:self];  
        
		CGSize size = [[CCDirector sharedDirector] winSize];        
        screenHeight_ = size.height;            
        
        CCSprite *bar = [CCSprite spriteWithFile:@"ui_bar.png"];
        bar.anchorPoint = CGPointZero;
        [self addChild:bar z:0];
        
        [self addLabels];
        
        buttons_ = [[NSMutableArray arrayWithCapacity:4] retain];
	}
	return self;
}

- (void) dealloc
{
    [heightLabel_ release];
    [speedLabel_ release];    
    [tiltLabel_ release];
    [numCats01Label_ release];
    [numCats02Label_ release];
    [numBoostsLabel_ release];    
    [buttons_ release];
    
    [super dealloc];
}

#pragma mark - Delegate Methods

- (void) buttonClicked:(Button *)button
{
    switch (button.numID) {
        case kCatButton:
            [delegate_ catButtonPressed:button];
            break;
        case kBombButton:
            [delegate_ bombButtonPressed:button];
            break;
        case kSlowButton:
            [delegate_ slowButtonPressed:button];
            break;
        case kBoostButton:
            [delegate_ boostButtonPressed:button];
            break;
    }
}

#pragma mark - Populate Methods

- (void) addLabels
{
    // Height
    CCLabelBMFont *staticHeightLabel = [CCLabelBMFont labelWithString:@"HEIGHT:" fntFile:@"SRSM_font.fnt"];
    staticHeightLabel.position = ccp(50, screenHeight_*0.95);
    staticHeightLabel.scale = 0.4;
    [self addChild:staticHeightLabel];
    heightLabel_ = [[CCLabelBMFont labelWithString:@"0" fntFile:@"SRSM_font.fnt"] retain];
    heightLabel_.position =  ccp(82, screenHeight_*0.95);
    heightLabel_.scale = 0.4f;
    heightLabel_.anchorPoint = ccp(0, 0.5);
    [self addChild:heightLabel_ z:1];     
    
    // Speed
    CCLabelBMFont *staticSpeedLabel = [CCLabelBMFont labelWithString:@"SPEED:" fntFile:@"SRSM_font.fnt"];
    staticSpeedLabel.position = ccp(50, screenHeight_*0.92);
    staticSpeedLabel.scale = 0.4;  
    [self addChild:staticSpeedLabel];
    speedLabel_ = [[CCLabelBMFont labelWithString:@"0.0" fntFile:@"SRSM_font.fnt"] retain];
    speedLabel_.position =  ccp(78, screenHeight_*0.92);
    speedLabel_.scale = 0.4f;
    speedLabel_.anchorPoint = ccp(0, 0.5);
    [self addChild:speedLabel_ z:1]; 
    
    // Tilt
    tiltLabel_ = [[CCLabelBMFont labelWithString:@"0.000" fntFile:@"SRSM_font.fnt"] retain];
    tiltLabel_.position =  ccp(50, screenHeight_*0.89);
    tiltLabel_.scale = 0.4f;
    [self addChild:tiltLabel_ z:1];        
    
    // Button 1 Counter
    numCats01Label_ = [[CCLabelBMFont labelWithString:@"0" fntFile:@"SRSM_font.fnt"] retain];
    numCats01Label_.position = ccp(45, 35);
    [self addChild:numCats01Label_ z:1];    
    
    // Button 2 counter
    numCats02Label_ = [[CCLabelBMFont labelWithString:@"0" fntFile:@"SRSM_font.fnt"] retain];
    numCats02Label_.position = ccp(130, 10);
    [self addChild:numCats02Label_ z:1];    
    
    // Button 4 counter
    numBoostsLabel_ = [[CCLabelBMFont labelWithString:@"0" fntFile:@"SRSM_font.fnt"] retain];
    numBoostsLabel_.position = ccp(295, 35);           
    [self addChild:numBoostsLabel_ z:1];    
}

- (void) addCatButton
{
    Button *button = [ImageButton imageButton:kCatButton unselectedImage:@"cat_button.png" selectedImage:@"cat_button_pressed.png"];
    button.position = CGPointMake(HUD_CAT_BUTTON_X, HUD_CAT_BUTTON_Y);    
    button.delegate = self;
    [buttons_ addObject:button];
    [self addChild:button];
}

- (void) addBombButton
{
    Button *button = [ImageButton imageButton:kBombButton unselectedImage:@"cat_button_bomb.png" selectedImage:@"cat_button_bomb_pressed.png"];
    button.position = CGPointMake(HUD_BOMB_BUTTON_X, HUD_BOMB_BUTTON_Y);
    button.delegate = self;    
    [buttons_ addObject:button];
    [self addChild:button];    
}

- (void) addSlowButton
{
    Button *button = [ImageButton imageButton:kSlowButton unselectedImage:@"slow_button.png" selectedImage:@"slow_button_pressed.png"];
    button.position = CGPointMake(HUD_SLOW_BUTTON_X, HUD_SLOW_BUTTON_Y);
    button.delegate = self;    
    [buttons_ addObject:button];
    [self addChild:button];    
}

- (void) addBoostButton
{
    Button *button = [ImageButton imageButton:kBoostButton unselectedImage:@"boost_button.png" selectedImage:@"boost_button_pressed.png"];
    button.position = CGPointMake(HUD_BOOST_BUTTON_X, HUD_BOOST_BUTTON_Y);
    button.delegate = self;    
    [buttons_ addObject:button];
    [self addChild:button];    
}

#pragma mark - Pause / Resume

- (void) pause
{
    for (Button *button in buttons_) {
        [button clickable:NO];
    }    
}

- (void) resume
{
    for (Button *button in buttons_) {
        [button clickable:YES];        
    }    
}

- (void) onEnter
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:5 swallowsTouches:YES];
	[super onEnter];
}

- (void) onExit
{
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [delegate_ screenClicked];
}

#pragma mark - Label Setters

- (void) setNumCats01:(NSUInteger)val
{
    [numCats01Label_ setString:[NSString stringWithFormat:@"%d", val]];
}

- (void) setNumCats02:(NSUInteger)val
{
    [numCats02Label_ setString:[NSString stringWithFormat:@"%d", val]];
}

- (void) setNumBoosts:(NSUInteger)val
{
    [numBoostsLabel_ setString:[NSString stringWithFormat:@"%d", val]];
}

- (void) setHeight:(CGFloat)val
{
    [heightLabel_ setString:[NSString stringWithFormat:@"%d", (unsigned int)val]];
}

- (void) setSpeed:(CGFloat)val
{
    [speedLabel_ setString:[NSString stringWithFormat:@"%2.1f", val]];    
}

- (void) setTilt:(CGFloat)val
{
    [tiltLabel_ setString:[NSString stringWithFormat:@"%1.3f", val]];    
}

@end
