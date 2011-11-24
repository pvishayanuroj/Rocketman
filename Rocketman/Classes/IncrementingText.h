//
//  IncrementingText.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/22/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "IncrementingTextDelegate.h"

typedef enum {
    kLeftAligned,
    kRightAligned,
    kCenterAligned
} Alignment;

@interface IncrementingText : CCNode {
    
    CGFloat timer_;
    
    CCLabelBMFont *scoreLabel_;    
    
    NSUInteger score_;
    
    NSUInteger finalScore_;  
    
    BOOL isTime_;
    
    id <IncrementingTextDelegate> delegate_;
    
    NSInteger unitID_;    
    
}

@property (nonatomic, assign) NSInteger unitID;
@property (nonatomic, assign) id <IncrementingTextDelegate> delegate;

+ (id) incrementingText:(NSInteger)score font:(NSString *)font alignment:(Alignment)alignment isTime:(BOOL)isTime;

+ (id) incrementingTextNoStart:(NSInteger)score font:(NSString *)font alignment:(Alignment)alignment isTime:(BOOL)isTime;

+ (id) incrementingTextHidden:(NSInteger)score font:(NSString *)font alignment:(Alignment)alignment isTime:(BOOL)isTime;

- (id) initIncrementingText:(NSInteger)score font:(NSString *)font alignment:(Alignment)alignment start:(BOOL)start show:(BOOL)show isTime:(BOOL)isTime;

- (NSString *) convertToFormattedTime:(NSInteger)time;

- (void) startIncrementing;

@end
