//
//  SpinningElement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/19/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "StoryElement.h"

@interface SpinningElement : StoryElement {
    
}

+ (id) spinningElementAWithFile:(NSString *)filename from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration;

- (id) initAWithFile:(NSString *)filename from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration;

+ (id) spinningElementBWithFile:(NSString *)filename from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration;

- (id) initBWithFile:(NSString *)filename from:(CGPoint)from to:(CGPoint)to duration:(CGFloat)duration;

@end
