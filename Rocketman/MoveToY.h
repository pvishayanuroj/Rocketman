//
//  MoveToY.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "CCActionInterval.h"

@interface MoveToY : CCActionInterval <NSCopying>
{
	CGPoint endPosition;
	CGPoint startPosition;
	CGPoint delta;
}

/** creates the action */
+(id) actionWithDuration:(ccTime)duration position:(CGPoint)position;

/** initializes the action */
-(id) initWithDuration:(ccTime)duration position:(CGPoint)position;

@end
