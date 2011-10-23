//
//  YellowBird.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "BoundaryDelegate.h"

@interface YellowBird : Obstacle <BoundaryDelegate> {
    
    CCAction *damageAnimation_;
    
}

+ (id) yellowBirdWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) showDamage;

- (void) finishHit;

+ (void) resetID;

@end
