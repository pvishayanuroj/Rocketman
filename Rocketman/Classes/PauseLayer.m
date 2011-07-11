//
//  PauseLayer.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/10/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "PauseLayer.h"
#import "GameManager.h"
#import "AudioManager.h"

@implementation PauseLayer

- (id) init
{
	if ((self = [super init])) {
        
        [[GameManager gameManager] registerPauseLayer:self];
		self.isTouchEnabled = YES;        
     
        isPaused_ = NO;
        
        button_ = [CCMenuItemSprite itemFromNormalSprite:[CCSprite spriteWithFile:@"pause_button.png"] selectedSprite:[CCSprite spriteWithFile:@"pause_button.png"] target:self selector:@selector(select)];
        
        CCMenu *m = [CCMenu menuWithItems:button_, nil];
        m.position = CGPointMake(280, 420);
        [self addChild:m];
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) select
{
    // Pause the game
    if (!isPaused_) {
        isPaused_ = YES;
        [[GameManager gameManager] pause];
        [[AudioManager audioManager] pauseSound];
        [button_ setNormalImage:[CCSprite spriteWithFile:@"resume_button.png"]];
        [button_ setSelectedImage:[CCSprite spriteWithFile:@"resume_button.png"]];        
    }
    // Unpause the game
    else {
        isPaused_ = NO;        
        [[GameManager gameManager] resume];      
        [[AudioManager audioManager] resumeSound];
        [button_ setNormalImage:[CCSprite spriteWithFile:@"pause_button.png"]];
        [button_ setSelectedImage:[CCSprite spriteWithFile:@"pause_button.png"]];                
    }

}

@end
