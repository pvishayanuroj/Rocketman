//
//  Cat.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"

@interface Cat : Obstacle {

    CCAction *collectAnimation_;
    
}

+ (id) catWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) showCollect;

@end
