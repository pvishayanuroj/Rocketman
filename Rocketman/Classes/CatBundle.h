//
//  CatBundle.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/31/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "cocos2d.h"
#import "BoundaryDelegate.h"

@interface CatBundle : Obstacle <BoundaryDelegate> {
    
    CCAction *collectAnimation_;
    
}

+ (id) catBundleWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) showCollect;

+ (void) resetID;    

@end
