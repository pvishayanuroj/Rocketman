//
//  AnimatedButton.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/29/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@interface AnimatedButton : CCNode <CCTargetedTouchDelegate> {

	NSInvocation *invocation_;    
    
    CCSprite *sprite_;
    
    BOOL isLocked_;
    
    BOOL isExpanded_;
    
}

@property (nonatomic, assign) BOOL isLocked;

+ (id) buttonWithImage:(NSString *)imageFile target:(id)target selector:(SEL)selector;

- (id) initButtonWithImage:(NSString *)imageFile target:(id)target selector:(SEL)selector;

- (void) expand;

- (void) unexpand;

@end
