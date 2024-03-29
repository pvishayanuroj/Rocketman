//
//  Movement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@class GameObject;

@interface Movement : NSObject {
    
}

- (id) initMovement;

- (void) move:(CGFloat)speed object:(GameObject *)object;

@end
