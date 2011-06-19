//
//  HUDLayer.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "HUDLayer.h"
#import "GameLayer.h"
#import "PButton.h"
#import "GameManager.h"

@implementation HUDLayer

- (id) init
{
	if ((self = [super init])) {
        
        [[GameManager gameManager] registerHUDLayer:self];
		self.isTouchEnabled = YES;        
        
		CGSize size = [[CCDirector sharedDirector] winSize];        
        screenHeight_ = size.height;            
        
        CCSprite *bar = [CCSprite spriteWithFile:@"ui_bar.png"];
        bar.anchorPoint = CGPointZero;
        [self addChild:bar z:0];
        
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
        
        // Button counters
        numCatsLabel_ = [[CCLabelBMFont labelWithString:@"0" fntFile:@"SRSM_font.fnt"] retain];
        numBoostsLabel_ = [[CCLabelBMFont labelWithString:@"0" fntFile:@"SRSM_font.fnt"] retain];
        numCatsLabel_.position = ccp(45, 35);
        numBoostsLabel_.position = ccp(295, 35);           
        [self addChild:numCatsLabel_ z:1];
        [self addChild:numBoostsLabel_ z:1];
	}
	return self;
}

- (void) dealloc
{
    [heightLabel_ release];
    [speedLabel_ release];    
    [tiltLabel_ release];
    [numCatsLabel_ release];
    [numBoostsLabel_ release];    
    
    [super dealloc];
}


- (void) displayControls:(GameLayer *)gameLayer
{
    CCMenuItemSprite *catButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"cat_button.png"] selectedSprite:[CCSprite spriteWithFile:@"cat_button_pressed.png"] target:gameLayer selector:@selector(fireCat)];
    
    CCMenuItemSprite *boostButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"boost_button.png"] selectedSprite:[CCSprite spriteWithFile:@"boost_button_pressed.png"] target:gameLayer selector:@selector(useBoost)];        
    
    CCMenu *m1 = [CCMenu menuWithItems:catButton, nil];
    CCMenu *m2 = [CCMenu menuWithItems:boostButton, nil];    
    m1.position = CGPointMake(45, 57);
    m2.position = CGPointMake(268, 32);
    
    [self addChild:m1];    
    [self addChild:m2];        
}

- (void) displayDirectional:(GameLayer *)gameLayer
{
    /*
    PButton *leftButton = [PButton pButton:@"Icon-Small.png" toggledImage:@"Icon.png" buttonType:kLeftButton withDelegate:gameLayer];
    PButton *rightButton = [PButton pButton:@"Icon-Small.png" toggledImage:@"Icon.png" buttonType:kRightButton withDelegate:gameLayer];   
    
    leftButton.position = CGPointMake(50, 100);
    rightButton.position = CGPointMake(270, 100);
    
    [self addChild:leftButton];
    [self addChild:rightButton];
     */
}

- (void) setNumCats:(NSUInteger)val
{
    [numCatsLabel_ setString:[NSString stringWithFormat:@"%d", val]];
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
