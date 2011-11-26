//
//  ArcMovement.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 8/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "ArcMovement.h"
#import "GameObject.h"

@implementation ArcMovement

@synthesize rate = rate_;
@synthesize t = t_;
@synthesize c1 = c1_;
@synthesize c2 = c2_;
@synthesize startPoint = startPoint_;
@synthesize endPoint = endPoint_;

// Arc 1
const CGFloat ARC1_C1X = 15.0f;
const CGFloat ARC1_C1Y = -20.0f;
const CGFloat ARC1_C2X = 10.0f;
const CGFloat ARC1_C2Y = -40.0f;
const CGFloat ARC1_EX = 10.0f;
const CGFloat ARC1_EY = -300.0f;
// Arc 2
const CGFloat ARC2_C1X = 30.0f;
const CGFloat ARC2_C1Y = 0.0f;
const CGFloat ARC2_C2X = 45.0f;
const CGFloat ARC2_C2Y = -20.0f;
const CGFloat ARC2_EX = 50.0f;
const CGFloat ARC2_EY = -300.0f;
// Arc 3
const CGFloat ARC3_C1X = 40.0f;
const CGFloat ARC3_C1Y = 20.0f;
const CGFloat ARC3_C2X = 70.0f;
const CGFloat ARC3_C2Y = 4.0f;
const CGFloat ARC3_EX = 100.0f;
const CGFloat ARC3_EY = -300.0f;
// Arc 4
const CGFloat ARC4_C1X = 40.0f;
const CGFloat ARC4_C1Y = 40.0f;
const CGFloat ARC4_C2X = 90.0f;
const CGFloat ARC4_C2Y = 20.0f;
const CGFloat ARC4_EX = 150.0f;
const CGFloat ARC4_EY = -250.0f;
// Arc 5
const CGFloat ARC5_C1X = 60.0f;
const CGFloat ARC5_C1Y = 100.0f;
const CGFloat ARC5_C2X = 150.0f;
const CGFloat ARC5_C2Y = 50.0f;
const CGFloat ARC5_EX = 200.0f;
const CGFloat ARC5_EY = -150.0f;
// Arc 6
const CGFloat ARC6_C1X = 30.0f;
const CGFloat ARC6_C1Y = -25.0f;
const CGFloat ARC6_C2X = 60.0f;
const CGFloat ARC6_C2Y = -25.0f;
const CGFloat ARC6_EX = 90.0f;
const CGFloat ARC6_EY = 0.0f;

const CGFloat ARC_FAST_SPEED = 1/15.0f;
const CGFloat ARC_SLOW_SPEED = 1/30.0f;

+ (id) arcFastRandomMovement:(CGPoint)start
{
    // Randomly pick side
    ArcSide arcSide = (arc4random() % 2) ? kRightArc : kLeftArc;
    ArcType arcType;
    switch (arc4random() % 5) {
        case 0:
            arcType = kArc1;
            break;
        case 1:
            arcType = kArc2;
            break;
        case 2:
            arcType = kArc3;
            break;
        case 3:
            arcType = kArc4;
            break;
        case 4:
            arcType = kArc5;
            break;
        default:
            break;
    }
    
    return [[[self alloc] initArcMovement:start arcType:arcType arcSide:arcSide rate:ARC_FAST_SPEED] autorelease];
}

+ (id) arcSlowMovement:(CGPoint)start arcType:(ArcType)arcType arcSide:(ArcSide)arcSide
{
    return [[[self alloc] initArcMovement:start arcType:arcType arcSide:arcSide rate:ARC_SLOW_SPEED] autorelease];    
}

+ (id) arcFastMovement:(CGPoint)start arcType:(ArcType)arcType arcSide:(ArcSide)arcSide
{
    return [[[self alloc] initArcMovement:start arcType:arcType arcSide:arcSide rate:ARC_FAST_SPEED] autorelease];    
}

- (id) initArcMovement:(CGPoint)start arcType:(ArcType)arcType arcSide:(ArcSide)arcSide rate:(CGFloat)rate
{
    if ((self = [super initMovement])) {
        
        startPoint_ = start;           
        t_ = 0;
        rate_ = rate;
        
        switch (arcType) {
            case kArc1:
                c1_ = CGPointMake(ARC1_C1X, ARC1_C1Y);
                c2_ = CGPointMake(ARC1_C2X, ARC1_C2Y);             
                endPoint_ = CGPointMake(ARC1_EX, ARC1_EY);
                break;
            case kArc2:
                c1_ = CGPointMake(ARC2_C1X, ARC2_C1Y);
                c2_ = CGPointMake(ARC2_C2X, ARC2_C2Y);                
                endPoint_ = CGPointMake(ARC2_EX, ARC2_EY);                
                break;
            case kArc3:
                c1_ = CGPointMake(ARC3_C1X, ARC3_C1Y);
                c2_ = CGPointMake(ARC3_C2X, ARC3_C2Y);      
                endPoint_ = CGPointMake(ARC3_EX, ARC3_EY);                
                break;
            case kArc4:
                c1_ = CGPointMake(ARC4_C1X, ARC4_C1Y);
                c2_ = CGPointMake(ARC4_C2X, ARC4_C2Y); 
                endPoint_ = CGPointMake(ARC4_EX, ARC4_EY);                
                break;
            case kArc5:
                c1_ = CGPointMake(ARC5_C1X, ARC5_C1Y);
                c2_ = CGPointMake(ARC5_C2X, ARC5_C2Y); 
                endPoint_ = CGPointMake(ARC5_EX, ARC5_EY);                
                break;                
            case kArc6:
                c1_ = CGPointMake(ARC6_C1X, ARC6_C1Y);
                c2_ = CGPointMake(ARC6_C2X, ARC6_C2Y); 
                endPoint_ = CGPointMake(ARC6_EX, ARC6_EY);                
                break;                       
            default:
                break;
        }
              
        if (arcSide == kLeftArc) {
            c1_.x = -c1_.x;
            c2_.x = -c2_.x;
            endPoint_.x = -endPoint_.x;
        }     
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (id) copyWithZone:(NSZone *)zone
{
    ArcMovement *cpy = [[ArcMovement allocWithZone:zone] initArcMovement:self.startPoint arcType:kArc1 arcSide:kLeftArc rate:self.rate];
    cpy.c1 = self.c1;
    cpy.c2 = self.c2;
    cpy.t = self.t;
    return cpy;
}

- (void) move:(CGFloat)speed object:(GameObject *)object;
{
    CGPoint p = [self calculatePoint];

    t_ += rate_;
    object.position = ccpAdd(startPoint_, p);
}

- (CGPoint) calculatePoint
{
    CGFloat xa = 0;
    CGFloat xb = c1_.x;
    CGFloat xc = c2_.x;
    CGFloat xd = endPoint_.x;
    
    CGFloat ya = 0;
    CGFloat yb = c1_.y;
    CGFloat yc = c2_.y;
    CGFloat yd = endPoint_.y;
    
    CGFloat x = [self bezierAt:xa b:xb c:xc d:xd t:t_];
    CGFloat y = [self bezierAt:ya b:yb c:yc d:yd t:t_];
    
    return CGPointMake(x, y);
}

- (CGFloat) bezierAt:(CGFloat)a b:(CGFloat)b c:(CGFloat)c d:(CGFloat)d t:(CGFloat)t
{
	return (powf(1 - t, 3) * a + 
			3 * t * (powf(1 - t, 2)) * b + 
			3 * powf(t, 2) * (1 - t) * c +
			powf(t, 3) * d);
}

@end

@implementation RepeatedArcMovement

+ (id) repeatedArcMovement:(CGPoint)start
{
    return [[[self alloc] initRepeatedArcMovement:start] autorelease];
}

- (id) initRepeatedArcMovement:(CGPoint)start
{
    if ((self = [super initArcMovement:start arcType:kArc6 arcSide:kLeftArc rate:ARC_SLOW_SPEED])) {
        
        endTime_ = 1.0f;
        
    }
    return self;
}

- (void) move:(CGFloat)speed object:(GameObject *)object;
{
    CGPoint p = [super calculatePoint];
    
    t_ += rate_;
    object.position = ccpAdd(startPoint_, p);
    
    if (t_ > endTime_) {
        [self reverse];
        object.position = startPoint_;
    }
}

- (void) reverse
{
    startPoint_ = ccpAdd(startPoint_, endPoint_);
    endPoint_ = CGPointMake(-endPoint_.x, endPoint_.y);
    
    c1_ = CGPointMake(-c1_.x, c1_.y);    
    c2_ = CGPointMake(-c2_.x, c2_.y);
    
    t_ = 0;
}

@end
