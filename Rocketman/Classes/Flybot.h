//
//  Flybot.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Obstacle.h"
#import "BoundaryDelegate.h"

@interface Flybot : Obstacle <BoundaryDelegate> {

}

+ (id) flyBotWithPos:(CGPoint)pos;

- (id) initWithPos:(CGPoint)pos;

- (void) initActions;

- (void) death;

+ (void) resetID;

@end
