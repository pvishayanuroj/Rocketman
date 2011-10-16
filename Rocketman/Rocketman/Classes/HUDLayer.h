//
//  HUDLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"

@class GameLayer;

@interface HUDLayer : CCLayer {
 
    NSInteger screenHeight_;

    CCLabelBMFont *heightLabel_;
    
    CCLabelBMFont *speedLabel_;   
    
    CCLabelBMFont *tiltLabel_;
    
    CCLabelBMFont *numCats01Label_;
    
    CCLabelBMFont *numCats02Label_;
    
    CCLabelBMFont *numBoostsLabel_;        
    
    CCMenu *m1_;
    
    CCMenu *m2_;
    
    CCMenu *m3_;
}

- (void) addLabels;

- (void) displayControls:(GameLayer *)gameLayer;

- (void) displayDirectional:(GameLayer *)gameLayer;

- (void) pause;

- (void) resume;

- (void) setNumCats01:(NSUInteger)val;

- (void) setNumCats02:(NSUInteger)val;

- (void) setNumBoosts:(NSUInteger)val;

- (void) setHeight:(CGFloat)val;

- (void) setSpeed:(CGFloat)val;

- (void) setTilt:(CGFloat)val;

@end
