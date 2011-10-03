//
//  PButton.h
//  ZombieZap
//
//  Created by Paul Vishayanuroj on 1/23/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "PButtonDelegate.h"

@interface PButton : CCNode <CCTargetedTouchDelegate> {

	CCSprite *sprite_;
	
	CCSprite *toggledSprite_;	
    
    ButtonType buttonType_;
    
    id <PButtonDelegate> delegate_;
}

@property (nonatomic, assign) CGPoint placementSpriteDrawOffset;

+ (id) pButton:(NSString *)buttonImage toggledImage:(NSString *)toggledImage buttonType:(ButtonType)buttonType withDelegate:(id <PButtonDelegate>)delegate;

- (id) initPButton:(NSString *)buttonImage toggledImage:(NSString *)toggledImage buttonType:(ButtonType)buttonType withDelegate:(id <PButtonDelegate>)delegate;

@end
