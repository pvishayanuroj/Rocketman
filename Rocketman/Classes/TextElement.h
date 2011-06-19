//
//  TextElement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/18/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "StoryElement.h"

@interface TextElement : StoryElement {
    
}

+ (id) textElementWithFile:(NSString *)filename at:(CGPoint)pos;

- (id) initWithFile:(NSString *)filename at:(CGPoint)pos;

@end
