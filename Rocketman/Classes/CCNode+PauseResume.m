//
//  CCNode+PauseResume.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/10/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CCNode+PauseResume.h"

@implementation CCNode (PauseResume)

- (void) resumeHierarchy
{
	for (CCNode* child in [self children])
	{
		[child resumeHierarchy];
	}
    [self resumeSchedulerAndActions];
}

- (void) pauseHierarchy
{
    [self pauseSchedulerAndActions];
    
	for (CCNode* child in [self children])
	{
		[child pauseHierarchy];
	}
}

@end
