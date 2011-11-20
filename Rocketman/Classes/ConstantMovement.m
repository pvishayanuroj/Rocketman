//
//  ConstantMovement.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/21/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "ConstantMovement.h"
#import "GameObject.h"

@implementation ConstantMovement

@synthesize rate = rate_;

+ (id) constantMovement:(CGPoint)rate
{
    return [[[self alloc] initConstantMovement:rate] autorelease];    
}

+ (id) constantMovementDown:(CGFloat)rate
{
    return [[[self alloc] initConstantMovement:CGPointMake(0, -rate)] autorelease];    
}

- (id) initConstantMovement:(CGPoint)rate
{
    if ((self = [super initMovement])) {
        
        rate_ = rate;
        
    }
    return self;
}

- (void) dealloc
{
#if DEBUG_DEALLOCS    
    NSLog(@"Constant movement dealloc'd");
#endif
    
    [super dealloc];
}

- (id) copyWithZone: (NSZone *)zone
{
    ConstantMovement *cpy = [[ConstantMovement allocWithZone:zone] initConstantMovement:self.rate];
    return cpy;
}

- (void) move:(CGFloat)speed object:(GameObject *)object;
{
    object.position = ccpAdd(object.position, rate_);    
}


@end
