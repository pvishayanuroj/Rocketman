//
//  Ground.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/30/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Doodad.h"

@interface Ground : Doodad {
    
}

+ (id) groundWithPos:(CGPoint)pos filename:(NSString *)filename;

- (id) initWithPos:(CGPoint)pos filename:(NSString *)filename;

@end
