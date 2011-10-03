//
//  CCNode+PauseResume.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/10/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@interface CCNode (PauseResume)

- (void) pauseHierarchy;

- (void) resumeHierarchy;

@end
