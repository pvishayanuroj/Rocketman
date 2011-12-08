//
//  ComboModule.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/19/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "ComboModuleDelegate.h"

@interface ComboModule : NSObject {
    
    double lastComboTimestamp_;
    
    double maxComboInterval_;
    
    NSInteger comboCount_;
    
    NSInteger maxComboCount_;
    
    id <ComboModuleDelegate> delegate_;
    
}

@property (nonatomic, assign) id <ComboModuleDelegate> delegate;

+ (id) comboModule:(NSInteger)maxCount maxInterval:(double)maxInterval;

- (id) initComboModule:(NSInteger)maxCount maxInterval:(double)maxInterval;

- (void) step:(ccTime)dt;

- (void) enemyKilled:(ObstacleType)type pos:(CGPoint)pos;

- (void) setComboCount:(NSInteger)count;

- (void) comboUsed;

- (void) rocketCollision;

@end
