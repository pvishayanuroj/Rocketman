//
//  CatBullet.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CatBullet.h"
#import "ConstantMovement.h"

@implementation CatBullet

@synthesize radius = radius_;
@synthesize explosionRadius = explosionRadius_;
@synthesize remainingImpacts = remainingImpacts_;

static NSUInteger countID = 0;

+ (id) catBulletWithPos:(CGPoint)pos withSpeed:(CGFloat)speed
{
    CGPoint rate = CGPointMake(0, speed);
    return [[[self alloc] initWithPos:pos withSpeed:rate explosionRadius:0 remainingImpacts:1 catType:kCatNormal] autorelease];
}

+ (id) fatBulletWithPos:(CGPoint)pos withSpeed:(CGFloat)speed
{
    CGPoint rate = CGPointMake(0, speed);    
    return [[[self alloc] initWithPos:pos withSpeed:rate explosionRadius:50 remainingImpacts:1 catType:kCatBomb] autorelease];    
}

+ (id) longBulletWithPos:(CGPoint)pos withSpeed:(CGFloat)speed
{
    CGPoint rate = CGPointMake(0, speed);    
    return [[[self alloc] initWithPos:pos withSpeed:rate explosionRadius:0 remainingImpacts:3 catType:kCatPierce] autorelease];    
}

+ (id) superCatWithPos:(CGPoint)pos withSpeed:(CGPoint)speed
{
    return [[[self alloc] initWithPos:pos withSpeed:speed explosionRadius:0 remainingImpacts:100 catType:kCatSuper] autorelease];    
}

- (id) initWithPos:(CGPoint)pos withSpeed:(CGPoint)speed explosionRadius:(CGFloat)radius remainingImpacts:(NSInteger)impacts catType:(CatType)type
{
    if ((self = [super initGameObject])) {
        
        unitID_ = countID++;        
        
        // Pick the correct sprite to use
        switch (type) {
            case kCatNormal:
                sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Cat Normal 01.png"] retain];  
                radius_ = 3;                
                break;
            case kCatBomb:
                sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Cat Bomb 01.png"] retain];                                
                radius_ = 3;                
                break;
            case kCatPierce:
                sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Cat Pierce 01.png"] retain];                                
                radius_ = 3;                
                break;
            case kCatSuper:
                sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Cat Super 01.png"] retain];                                                
                radius_ = 5;                
                break;
            default:
                sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Cat Normal 01.png"] retain];                
        }
        [self addChild:sprite_];
        
        self.position = pos;        
        
        s_ = speed;
        //[movements_ addObject:[ConstantMovement constantMovement:speed]];
        explosionRadius_ = radius;
        remainingImpacts_ = impacts;
        
        [self initActions:type];
        [self showIdle];
    }
    return self;
}

- (void) dealloc
{
#if DEBUG_DEALLOCS
    NSLog(@"%@ dealloc'd", self);    
#endif
    
    [sprite_ release];
    [idleAnimation_ release];
    
    [super dealloc];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Cat Bullet %d", unitID_];
}    

- (void) initActions:(CatType)type
{
	CCAnimation *animation;
    
    // Pick the correct animation to use
    switch (type) {
        case kCatNormal:
            animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Cat Normal"];
            break;
        case kCatBomb:
            animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Cat Bomb"];
            break;
        case kCatPierce:
            animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Cat Pierce"];
            break;
        case kCatSuper:
            animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Cat Super"];
            break;            
        default:
            animation = [[CCAnimationCache sharedAnimationCache] animationByName:@"Cat Normal"];
    }    
    
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];
}                 

- (void) showIdle
{
	[sprite_ stopAllActions];
	[sprite_ runAction:idleAnimation_];	
}

- (void) fall:(CGFloat)speed
{
    CGPoint p = CGPointMake(s_.x, s_.y - speed);
    self.position = ccpAdd(self.position, p);
}

/*
- (void) fall:(CGFloat)speed
{
    for (Movement *movement in movements_) {
        [movement move:speed object:self];
    }        
}*/

@end
