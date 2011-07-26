//
//  MapLayer.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "cocos2d.h"
#import "CatButtonDelegate.h"
#import "MapTextDelegate.h"

@class CatMapButton;
@class MapText;

typedef enum {
    kStateNeutral,
    kStateSelected
} MapState;

@interface MapLayer : CCLayer <CatButtonDelegate, MapTextDelegate, CCTargetedTouchDelegate> {
    
    MapState mapState_;
    
    CatMapButton *selectedButton_;
    
    MapText *mapText_;    
    
    BOOL mapTextDown_;
    
    BOOL mapTextSwitch_;
    
    BOOL inputLocked_;
    
    NSMutableArray *levelTitles_;
    
    NSMutableArray *levelDescs_;
    
    NSMutableArray *buttons_;
    
    CCLabelTTF *title_;
    
    CCLabelTTF *desc_;
    
}

@property (nonatomic, retain) CatMapButton *selectedButton;

+ (id) mapWithFile:(NSString *)filename;

- (id) initWithFile:(NSString *)filename;

- (void) catButtonPressed:(CatMapButton *)button;

- (void) catButtonSpinComplete:(CatMapButton *)button;

- (void) showLevelInfo:(NSUInteger)levelNum;

- (void) hideLevelInfo;

/** Does not allow user input for the map screen */
- (void) lockInput;

/** Allows user input for the map screen */
- (void) unlockInput;

@end
