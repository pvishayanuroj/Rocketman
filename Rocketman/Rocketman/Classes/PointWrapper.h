//
//  PointWrapper.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/21/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@interface PointWrapper : NSObject {
    
    CGPoint point_;
    
}

@property (nonatomic, assign) CGPoint point;

+ (id) cgPoint:(CGPoint)p;

- (id) initCGPoint:(CGPoint)p;

@end
