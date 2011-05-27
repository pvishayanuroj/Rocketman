//
//  MainMenuLayer.m
//  Rocketman
//
//  Created by Jamorn Ho on 5/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "MainMenuLayer.h"
#import "GameScene.h"


@implementation MainMenuLayer

/**
 Main Menu layer initialization method
 @returns Returns the created game layer
 */
- (id) init
{
	if ((self = [super init])) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];     
        
        NSUInteger screenWidth = size.width;
        NSUInteger screenHeight = size.height;
        
        CCSprite *backgroundImage = [CCSprite spriteWithFile:@"GameOvaa.png"];
        
        backgroundImage.position = ccp(screenWidth/2, screenHeight/2);
        
        CCMenuItemSprite *menuButton1 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"MenuButton01.png"] selectedSprite:[CCSprite spriteWithFile:@"MenuButton01.png"] target:self selector:@selector(startGame)];
        CCMenuItemSprite *menuButton2 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"MenuButton02.png"] selectedSprite:[CCSprite spriteWithFile:@"MenuButton02.png"] target:self selector:@selector(viewHighScore)];
        CCMenuItemSprite *menuButton3 = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"MenuButton03.png"] selectedSprite:[CCSprite spriteWithFile:@"MenuButton03.png"] target:self selector:@selector(viewCredits)];
        
        CCMenu *menu = [CCMenu menuWithItems:menuButton1, menuButton2, menuButton3, nil];
        [menu alignItemsVertically];
        
        [self addChild:backgroundImage z:0];
        [self addChild:menu z:1];
        
	}
	return self;
}

- (void) startGame {
    [[CCDirector sharedDirector] replaceScene:[GameScene node]];
}

- (void) viewHighScore {
    
}

- (void) viewCredits {
    
}

- (void) dealloc {
    [super dealloc];
}


@end
