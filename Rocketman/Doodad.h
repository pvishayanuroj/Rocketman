//
//  Doodad.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

@interface Doodad : CCNode {
 
    CCSprite *sprite_;    
    
}

- (void) fall:(CGFloat)speed;

@end
