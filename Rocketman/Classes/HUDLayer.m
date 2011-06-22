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
    
    [super dealloc];
}


- (void) displayControls:(GameLayer *)gameLayer
{
    
    // Cat Button 01
    // Add Button counter
    numCats01Label_ = [[CCLabelBMFont labelWithString:@"0" fntFile:@"SRSM_font.fnt"] retain];
    numCats01Label_.position = ccp(45, 35);
    [self addChild:numCats01Label_ z:1];
    
    CCMenuItemSprite *catButton01 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"cat_button.png"] selectedSprite:[CCSprite spriteWithFile:@"cat_button_pressed.png"] target:gameLayer selector:@selector(fireCat01)];
    
    CCMenu *m1 = [CCMenu menuWithItems:catButton01, nil];
    m1.position = CGPointMake(45, 57);
    [self addChild:m1];
    
    // Cat Button 02
    // Disable catButton02 if catBomb isn't enabled.
    if (((GameScene *)self.parent).catBombEnabled_) {
        
        // Add Button counter
        numCats02Label_ = [[CCLabelBMFont labelWithString:@"0" fntFile:@"SRSM_font.fnt"] retain];
        numCats02Label_.position = ccp(130, 10);
        [self addChild:numCats02Label_ z:1];
        
        CCMenuItemSprite *catButton02 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"cat_button_bomb.png"] selectedSprite:[CCSprite spriteWithFile:@"cat_button_bomb_pressed.png"] target:gameLayer selector:@selector(fireCat02)];
        
        CCMenu *m2 = [CCMenu menuWithItems:catButton02, nil];
        m2.position = CGPointMake(125, 30);
        [self addChild:m2];
    }
    
    // Boost Button
    // Add Button counter
    numBoostsLabel_ = [[CCLabelBMFont labelWithString:@"0" fntFile:@"SRSM_font.fnt"] retain];
    numBoostsLabel_.position = ccp(295, 35);           
    [self addChild:numBoostsLabel_ z:1];
    
    CCMenuItemSprite *boostButton = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"boost_button.png"] selectedSprite:[CCSprite spriteWithFile:@"boost_button_pressed.png"] target:gameLayer selector:@selector(useBoost)];        

    CCMenu *m3 = [CCMenu menuWithItems:boostButton, nil];        
    m3.position = CGPointMake(268, 32);
    [self addChild:m3];        
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
