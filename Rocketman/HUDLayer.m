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
    
    CCMenu *menu = [CCMenu menuWithItems:catButton, boostButton, nil];
    menu.position = CGPointMake(140, 32);
    [menu alignItemsHorizontallyWithPadding:50];
    
    [self addChild:menu];    
}

- (void) displayDirectional:(GameLayer *)gameLayer
{
    PButton *leftButton = [PButton pButton:@"Icon-Small.png" toggledImage:@"Icon.png" buttonType:kLeftButton withDelegate:gameLayer];
    PButton *rightButton = [PButton pButton:@"Icon-Small.png" toggledImage:@"Icon.png" buttonType:kRightButton withDelegate:gameLayer];   
    
    leftButton.position = CGPointMake(100, 100);
    rightButton.position = CGPointMake(200, 100);
    
    [self addChild:leftButton];
    [self addChild:rightButton];
}

@end
