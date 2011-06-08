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

@implementation HUDLayer

- (id) init
{
	if ((self = [super init])) {
        
		self.isTouchEnabled = YES;        
        
		CGSize size = [[CCDirector sharedDirector] winSize];        
        screenHeight_ = size.height;            
        
        CCSprite *bar = [CCSprite spriteWithFile:@"ui_bar.png"];
        bar.anchorPoint = CGPointZero;
        [self addChild:bar];
	}
	return self;
}

- (void) dealloc
{
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
    PButton *leftButton = [PButton pButton:@"Icon-Small.png" toggledImage:@"Icon.png" buttonType:kLeftButton withDelegate:gameLayer];
    PButton *rightButton = [PButton pButton:@"Icon-Small.png" toggledImage:@"Icon.png" buttonType:kRightButton withDelegate:gameLayer];   
    
    leftButton.position = CGPointMake(50, 100);
    rightButton.position = CGPointMake(270, 100);
    
    [self addChild:leftButton];
    [self addChild:rightButton];
}

@end
