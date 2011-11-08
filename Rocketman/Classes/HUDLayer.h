//
//  HUDLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "ButtonDelegate.h"
#import "HUDDelegate.h"

@class GameLayer;
@class Button;

@interface HUDLayer : CCLayer <ButtonDelegate> {
 
    NSInteger screenHeight_;

    CCLabelBMFont *heightLabel_;
    
    CCLabelBMFont *speedLabel_;   
    
    CCLabelBMFont *tiltLabel_;
    
    CCLabelBMFont *numCats01Label_;
    
    CCLabelBMFont *numCats02Label_;
    
    CCLabelBMFont *numBoostsLabel_;        
    
    /** Keep a reference to the slow button, since this is the only button that can be invalidated */
    Button *slowButton_;
    
    /** Storage for all HUD buttons */
    NSMutableArray *buttons_;
    
    /** Whether or not this entire layer is clickable */
    BOOL clickable_;
    
    /** Delegate object */
    id <HUDDelegate> delegate_;
}

@property (nonatomic, assign) id <HUDDelegate> delegate;

- (void) invalidateSlow;

- (void) addLabels;

- (void) pause;

- (void) resume;

- (void) addCatButton;

- (void) addBombButton;

- (void) addSlowButton;

- (void) addBoostButton;

- (void) setNumCats01:(NSUInteger)val;

- (void) setNumCats02:(NSUInteger)val;

- (void) setNumBoosts:(NSUInteger)val;

- (void) setHeight:(CGFloat)val;

- (void) setSpeed:(CGFloat)val;

- (void) setTilt:(CGFloat)val;

@end
