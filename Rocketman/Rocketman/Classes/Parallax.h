//
//  Parallax.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Doodad.h"

@interface Parallax : Doodad {
    
}

+ (id) parallaxWithFile:(NSString *)filename;

- (id) initWithFile:(NSString *)filename;

@end
