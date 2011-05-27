//
//  HUDLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@class GameLayer;

@interface HUDLayer : CCLayer {
 
    NSInteger screenHeight_;
    
}

- (void) displayControls:(GameLayer *)gameLayer;

- (void) displayDirectional:(GameLayer *)gameLayer;

@end
