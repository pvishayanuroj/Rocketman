//
//  EventText.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/19/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

typedef enum {
    kAngledText,
    kFadeUpText
} TextEffectType;

@interface EventText : CCNode {
 
    CCSprite *sprite_;
    
    CCLabelBMFont *label_;    
    
}

+ (id) eventText:(ActionText)actionText;

+ (id) eventTextWithString:(NSString *)string;

- (id) initEventText:(ActionText)actionText string:(NSString *)string effect:(TextEffectType)effect;

- (void) showAngledText;

- (void) showFadeUpText;

@end
