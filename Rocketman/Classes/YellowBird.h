//
//  YellowBird.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Obstacle.h"

@interface YellowBird : Obstacle {
    
    CCAction *damageAnimation_;
    
}

+ (id) yellowBirdWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

@end
