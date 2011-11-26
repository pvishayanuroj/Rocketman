//
//  FallingRocket.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "GameObject.h"

@interface FallingRocket : GameObject {
 
    BOOL fallingRight_;
    
}

+ (id) fallingRocket;

- (id) initFallingRocket;

- (void) startArc:(BOOL)right;

@end
