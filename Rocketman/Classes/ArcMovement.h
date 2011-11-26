//
//  ArcMovement.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "Movement.h"

typedef enum {
    kArc1,
    kArc2,
    kArc3,
    kArc4,
    kArc5,
    kArc6 
} ArcType;

typedef enum {
    kLeftArc,
    kRightArc
} ArcSide;

typedef enum {
    kFastArc,
    kSlowArc
} ArcSpeed;

@interface ArcMovement : Movement <NSCopying> {
    
    CGFloat rate_;
    
    CGFloat t_;
    
    CGPoint c1_;
    
    CGPoint c2_;
    
    CGPoint startPoint_;
    
    CGPoint endPoint_;
    
}

@property (nonatomic, readonly) CGFloat rate;
@property (nonatomic, assign) CGFloat t;
@property (nonatomic, assign) CGPoint c1;
@property (nonatomic, assign) CGPoint c2;
@property (nonatomic, readonly) CGPoint startPoint;
@property (nonatomic, assign) CGPoint endPoint;

+ (id) arcFastRandomMovement:(CGPoint)start;

+ (id) arcSlowMovement:(CGPoint)start arcType:(ArcType)arcType arcSide:(ArcSide)arcSide;

+ (id) arcFastMovement:(CGPoint)start arcType:(ArcType)arcType arcSide:(ArcSide)arcSide;

- (id) initArcMovement:(CGPoint)start arcType:(ArcType)arcType arcSide:(ArcSide)arcSide rate:(CGFloat)rate;

- (CGPoint) calculatePoint;

- (CGFloat) bezierAt:(CGFloat)a b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d t:(CGFloat)t;

@end
 
@interface RepeatedArcMovement : ArcMovement <NSCopying> {
    
    CGFloat endTime_;
    
}

+ (id) repeatedArcMovement:(CGPoint)start;

- (id) initRepeatedArcMovement:(CGPoint)start;

- (void) reverse;

@end
