//
//  StoryLayer.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/2/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "StoryLayer.h"
#import "StoryScene.h"

@implementation StoryLayer

- (id) init
{
	if ((self = [super init])) {
        
		self.isTouchEnabled = YES;        
                    
	}
	return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    StoryScene *scene = (StoryScene *)[self parent];
    [scene nextScene];
}


@end
