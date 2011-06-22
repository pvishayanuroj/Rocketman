//
//  MovingElement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/21/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "StoryElement.h"

@interface MovingElement : StoryElement {
    
}

+ (id) movingElementWithFile:(NSString *)filename from:(CGPoint)from to:(CGPoint)to delay:(CGFloat)timeDelay duration:(CGFloat)duration;

- (id) initWithFile:(NSString *)filename from:(CGPoint)from to:(CGPoint)to delay:(CGFloat)timeDelay duration:(CGFloat)duration;

@end
