//
//  Gauge.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/20/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@interface Gauge : CCNode {
    
    CGFloat min_;
    
    CGFloat max_;
    
    NSInteger intervals_;
    
    NSMutableArray *sprites_;
    
}

- (void) tick:(CGFloat)value;

@end
