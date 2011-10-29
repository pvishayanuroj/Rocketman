//
//  RockDebris.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/27/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "Doodad.h"
#import "ArcMovement.h"

@interface RockDebris : Doodad {
    
}

+ (id) rockDebris:(CGPoint)pos arcType:(ArcType)arcType arcSide:(ArcSide)arcSide;

- (id) initRockDebris:(CGPoint)pos arcType:(ArcType)arcType arcSide:(ArcSide)arcSide;

@end
