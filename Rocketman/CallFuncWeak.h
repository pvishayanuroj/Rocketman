//
//  CallFuncWeak.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"

/** Calls a 'callback'
    This is a duplicate of the CCCallFunc class, except this uses weak references 
    for the targetCallback object in order to avoid circular references
 */
@interface CallFuncWeak : CCActionInstant <NSCopying>
{
	id targetCallback_;
	SEL selector_;
}

/** Target that will be called */
@property (nonatomic, readwrite, assign) id targetCallback;

/** creates the action with the callback */
+(id) actionWithTarget: (id) t selector:(SEL) s;
/** initializes the action with the callback */
-(id) initWithTarget: (id) t selector:(SEL) s;
/** exeuctes the callback */
-(void) execute;
@end

