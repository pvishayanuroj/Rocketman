//
//  DialogueLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/7/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@interface DialogueLayer : CCLayer {
    
    CCSprite *sprite_;
    
}

- (void) showCombo:(NSUInteger)comboNum;

@end
