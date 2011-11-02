//
//  Doodad.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "GameObject.h"

@interface Doodad : GameObject {
 
    NSInteger zDepth_;
    
    /** Flag used in the Game Layer, indicating whether or not the object is destroyed */
    BOOL destroyed_;    
    
}

@property (nonatomic, readonly) NSInteger zDepth;
@property (nonatomic, readonly) BOOL destroyed;

- (void) fall:(CGFloat)speed;

@end
