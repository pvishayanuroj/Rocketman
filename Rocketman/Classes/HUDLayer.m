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
#import "Pair.h"

@implementation HUDLayer

@synthesize delegate = delegate_;

#pragma mark - Object Lifecycle

- (id) init
{
	if ((self = [super init])) {
        
        delegate_ = nil;
        clickable_ = YES;
        
        [[GameManager gameManager] registerHUDLayer:self];  
        
		CGSize size = [[CCDirector sharedDirector] winSize];        
        screenHeight_ = size.height;            
        
        CCSprite *bar = [CCSprite spriteWithFile:R_UI_BAR];
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
    [slowButton_ release];
    
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
        case kSuperCatButton:
            [delegate_ superCatButtonPressed:button];
            break;
        case kBoostButton:
            [delegate_ boostButtonPressed:button];
            break;
        default:
            break;
    }
}

- (void) buttonSelected:(Button *)button
{
    switch (button.numID) {
        case kSlowButton:
            [delegate_ slowButtonPressed:button];
            break;
        default:
            break;
    }    
}

- (void) buttonUnselected:(Button *)button
{
    switch (button.numID) {
        case kSlowButton:
            [delegate_ slowButtonReleased:button];
            break;
        default:
            break;
    }
}

#pragma mark - Object Manipulators

- (void) invalidateSlow
{
    [slowButton_ invalidateTouch];
}

- (void) showSuperCatButton
{
    [self removeButton:kBombButton];
    numCats02Label_.visible = NO;
    [self addSuperCatButton];
}

- (void) hideSuperCatButton
{
    [self removeButton:kSuperCatButton];
    numCats02Label_.visible = YES;
    [self addBombButton];
}

#pragma mark - Populate Methods

- (void) addLabels
{
    // Height
    CCLabelBMFont *staticHeightLabel = [CCLabelBMFont labelWithString:@"HEIGHT:" fntFile:R_DARK_FONT];
    staticHeightLabel.position = ccp(50, screenHeight_*0.85);
    staticHeightLabel.scale = 0.4;
    heightLabel_ = [[CCLabelBMFont labelWithString:@"0" fntFile:R_DARK_FONT] retain];
    heightLabel_.position =  ccp(82, screenHeight_*0.85);
    heightLabel_.scale = 0.4f;
    heightLabel_.anchorPoint = ccp(0, 0.5);
#if SHOW_READOUT
    [self addChild:staticHeightLabel];    
    [self addChild:heightLabel_ z:1];     
#endif
    
    // Speed
    CCLabelBMFont *staticSpeedLabel = [CCLabelBMFont labelWithString:@"SPEED:" fntFile:R_DARK_FONT];
    staticSpeedLabel.position = ccp(50, screenHeight_*0.82);
    staticSpeedLabel.scale = 0.4;  
    speedLabel_ = [[CCLabelBMFont labelWithString:@"0.0" fntFile:R_DARK_FONT] retain];
    speedLabel_.position =  ccp(78, screenHeight_*0.82);
    speedLabel_.scale = 0.4f;
    speedLabel_.anchorPoint = ccp(0, 0.5);
#if SHOW_READOUT    
    [self addChild:staticSpeedLabel];    
    [self addChild:speedLabel_ z:1]; 
#endif
    
    // Tilt
    tiltLabel_ = [[CCLabelBMFont labelWithString:@"0.000" fntFile:R_DARK_FONT] retain];
    tiltLabel_.position =  ccp(50, screenHeight_*0.89);
    tiltLabel_.scale = 0.4f;
#if SHOW_READOUT    
    [self addChild:tiltLabel_ z:1];        
#endif
    
    // Button 1 Counter
    numCats01Label_ = [[CCLabelBMFont labelWithString:@"0" fntFile:R_DARK_FONT] retain];
    numCats01Label_.position = ccp(45, 35);
    [self addChild:numCats01Label_ z:1];    
    
    // Button 2 counter
    numCats02Label_ = [[CCLabelBMFont labelWithString:@"0" fntFile:R_DARK_FONT] retain];
    numCats02Label_.position = ccp(130, 10);
    [self addChild:numCats02Label_ z:1];    
    
    // Button 4 counter
    numBoostsLabel_ = [[CCLabelBMFont labelWithString:@"0" fntFile:R_DARK_FONT] retain];
    numBoostsLabel_.position = ccp(295, 35);           
    [self addChild:numBoostsLabel_ z:1];    
}

- (void) addCatButton
{
    Button *button = [ImageButton imageButton:kCatButton unselectedImage:R_CAT_BUTTON selectedImage:R_CAT_BUTTON_PRESSED];
    button.position = CGPointMake(HUD_CAT_BUTTON_X, HUD_CAT_BUTTON_Y);    
    button.delegate = self;
    [buttons_ addObject:button];
    [self addChild:button];
}

- (void) addBombButton
{
    Button *button = [ImageButton imageButton:kBombButton unselectedImage:R_CAT_BOMB_BUTTON selectedImage:R_CAT_BOMB_BUTTON_PRESSED];
    button.position = CGPointMake(HUD_BOMB_BUTTON_X, HUD_BOMB_BUTTON_Y);
    button.delegate = self;    
    [buttons_ addObject:button];
    [self addChild:button];    
}

- (void) addSuperCatButton
{
    Button *button = [ImageButton imageButton:kSuperCatButton unselectedImage:R_SUPERCAT_BUTTON selectedImage:R_SUPERCAT_BUTTON_PRESSED];
    button.position = CGPointMake(HUD_BOMB_BUTTON_X, HUD_BOMB_BUTTON_Y);
    button.delegate = self;    
    [buttons_ addObject:button];
    [self addChild:button];        
}

- (void) addSlowButton
{
    Button *button = [ImageButton imageButton:kSlowButton unselectedImage:R_SLOW_BUTTON selectedImage:R_SLOW_BUTTON_PRESSED];
    button.position = CGPointMake(HUD_SLOW_BUTTON_X, HUD_SLOW_BUTTON_Y);
    button.delegate = self;    
    [buttons_ addObject:button];
    [self addChild:button];
    slowButton_ = button;
    [slowButton_ retain];
}

- (void) addBoostButton
{
    Button *button = [ImageButton imageButton:kBoostButton unselectedImage:R_BOOST_BUTTON selectedImage:R_BOOST_BUTTON_PRESSED];
    button.position = CGPointMake(HUD_BOOST_BUTTON_X, HUD_BOOST_BUTTON_Y);
    button.delegate = self;    
    [buttons_ addObject:button];
    [self addChild:button];    
}

#pragma mark - Pause / Resume

- (void) pause
{
    clickable_ = NO;
    for (Button *button in buttons_) {
        [button clickable:NO];
    }    
}

- (void) resume
{
    clickable_ = YES;    
    for (Button *button in buttons_) {
        [button clickable:YES];        
    }    
}

#pragma mark - Remove Methods

- (void) removeButton:(ButtonType)buttonType
{
    for (Button *button in buttons_) {
        if (button.numID == buttonType) {
            [buttons_ removeObject:button];
            [button removeFromParentAndCleanup:YES];
            break;
        }
    }
}

#pragma mark - Touch Handlers

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
    return clickable_;
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

#if DEBUG_SHOWTESTCURVES

- (void) draw
{
    glLineWidth(3.0f);    
    ccColor3B colors[6];
    colors[0] = ccRED;
    colors[1] = ccBLUE;
    colors[2] = ccYELLOW;
    colors[3] = ccGREEN;
    colors[4] = ccMAGENTA;    
    colors[5] = ccRED;        
    CGPoint origin = CGPointMake(160, 300);
    NSMutableArray *c1 = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *c2 = [NSMutableArray arrayWithCapacity:10];
    NSMutableArray *end = [NSMutableArray arrayWithCapacity:10];    
    // Arc 1
    [c1 addObject:[Pair pair:15 second:-20]];
    [c2 addObject:[Pair pair:10 second:-40]];
    [end addObject:[Pair pair:10 second:-300]];    
    // Arc 2
    [c1 addObject:[Pair pair:30 second:0]];
    [c2 addObject:[Pair pair:45 second:-20]];
    [end addObject:[Pair pair:50 second:-300]];    
    // Arc 3
    [c1 addObject:[Pair pair:40 second:20]];
    [c2 addObject:[Pair pair:70 second:4]];
    [end addObject:[Pair pair:100 second:-300]];    
    // Arc 4
    [c1 addObject:[Pair pair:40 second:40]];
    [c2 addObject:[Pair pair:90 second:20]];
    [end addObject:[Pair pair:150 second:-250]];    
    // Arc 5
    [c1 addObject:[Pair pair:60 second:100]];
    [c2 addObject:[Pair pair:150 second:50]];
    [end addObject:[Pair pair:200 second:-150]];        
    // Arc 6
    [c1 addObject:[Pair pair:30 second:-25]];
    [c2 addObject:[Pair pair:60 second:-25]];
    [end addObject:[Pair pair:90 second:0]];    
    
    for (int i = 0; i < [c1 count]; i++) {
   
        glColor4f(colors[i].r, colors[i].g, colors[i].b, 1.0);              
        Pair *c1p = [c1 objectAtIndex:i];
        Pair *c2p = [c2 objectAtIndex:i];
        Pair *endp = [end objectAtIndex:i];       
        CGPoint control1 = CGPointMake(c1p.x, c1p.y);
        CGPoint control2 = CGPointMake(c2p.x, c2p.y);
        CGPoint endpoint = CGPointMake(endp.x, endp.y);   
        control1 = ccpAdd(origin, control1);
        control2 = ccpAdd(origin, control2);
        endpoint = ccpAdd(origin, endpoint);        
        ccDrawCubicBezier(origin, control1, control2, endpoint, 128);  
        ccDrawCircle(control1, 3, 360, 64, NO);        
        ccDrawCircle(control2, 3, 360, 64, NO);        
    }

}

#endif

@end
