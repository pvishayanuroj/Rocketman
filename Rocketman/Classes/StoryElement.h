//
//  StoryElement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/18/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@interface StoryElement : CCNode {
  
    CCSprite *sprite_;
    
    CCAction *action_;
    
}

- (id) init;

- (void) play;

@end
