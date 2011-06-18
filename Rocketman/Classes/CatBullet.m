//
//  CatBullet.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/28/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CatBullet.h"


@implementation CatBullet

@synthesize radius = radius_;
@synthesize explosionRadius = explosionRadius_;
@synthesize remainingImpacts = remainingImpacts_;

static NSUInteger countID = 0;

+ (id) catBulletWithPos:(CGPoint)pos withSpeed:(CGFloat)speed
{
    return [[[self alloc] initWithPos:pos withSpeed:speed explosionRadius:0 remainingImpacts:1 catType:kCatNormal] autorelease];
}

+ (id) fatBulletWithPos:(CGPoint)pos withSpeed:(CGFloat)speed
{
    return [[[self alloc] initWithPos:pos withSpeed:speed explosionRadius:50 remainingImpacts:1 catType:kCatBomb] autorelease];    
}

+ (id) longBulletWithPos:(CGPoint)pos withSpeed:(CGFloat)speed
{
    return [[[self alloc] initWithPos:pos withSpeed:speed explosionRadius:0 remainingImpacts:3 catType:kCatPierce] autorelease];    
}

- (id) initWithPos:(CGPoint)pos withSpeed:(CGFloat)speed explosionRadius:(CGFloat)radius remainingImpacts:(NSInteger)impacts catType:(CatType)type;
{
    if ((self = [super init])) {
        
        unitID_ = countID++;        
        
        // Pick the correct sprite to use
        switch (type) {
            case kCatNormal:
                sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Cat Normal 01.png"] retain];                                
                break;
            case kCatBomb:
                sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Cat Bomb 01.png"] retain];                                
                break;
            case kCatPierce:
                sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Cat Pierce 01.png"] retain];                                
                break;
            default:
                sprite_ = [[CCSprite spriteWithSpriteFrameName:@"Cat Normal 01.png"] retain];                
        }
        [self addChild:sprite_];
        
        self.position = pos;        
        
        velocity_ = speed;
        radius_ = 3;
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
    CGPoint p = CGPointMake(0, velocity_ - speed);
    self.position = ccpAdd(self.position, p);        
}

@end
