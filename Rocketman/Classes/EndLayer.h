//
//  EndLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@interface EndLayer : CCLayer {
 
    CCSprite *restartIcon_;
    
    CCSprite *stageIcon_;
    
}

- (void) initActions;

- (void) restart;

- (void) stageSelect;

@end
