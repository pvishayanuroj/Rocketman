//
//  BossTurtle.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "BossTurtle.h"
#import "TargetedAction.h"
#import "GameLayer.h"
#import "GameManager.h"
#import "EngineParticleSystem.h"
#import "AudioManager.h"
#import "DataManager.h"
#import "BlastCloud.h"
#import "BigExplosion.h"
#import "Boundary.h"
#import "SideMovement.h"
#import "ConstantMovementWithStop.h"
#import "StaticMovement.h"
#import "PointWrapper.h"

@implementation BossTurtle

static NSUInteger countID = 0;

#pragma mark - Object Lifecycle

+ (id) bossTurtleWithPos:(CGPoint)pos
{
    return [[[self alloc] initWithPos:pos] autorelease];
}

- (id) initWithPos:(CGPoint)pos
{
	if ((self = [super init])) {
        
		unitID_ = countID++;        
        obstacleType_ = kBossTurtle;
        name_ = [[[DataManager dataManager] nameForType:obstacleType_] retain];
        
        NSString *spriteName = [NSString stringWithFormat:@"%@ Fly 01.png", name_];           
        sprite_ = [[CCSprite spriteWithSpriteFrameName:spriteName] retain];
        [self addChild:sprite_ z:-1];
        
        self.position = pos;
        
        // Attributes
        HP_ = 3;
        headOffset_ = ccp(70, 0);
        
        // Attributes
        PVCollide bodyCollide = defaultPVCollide_;
        bodyCollide.radius = 52;
        bodyCollide.collideActive = NO;
        bodyCollide.autoInactive = NO;
        
        PVCollide headCollide = defaultPVCollide_;
        headCollide.radius = 22;
        headCollide.offset = ccp(-headOffset_.x, headOffset_.y);
        headCollide.collideActive = NO;
        headCollide.autoInactive = NO;
        
        // Bounding box setup
        bodyBoundary_ = [[Boundary boundaryWithTarget:self collide:nil hit:@selector(primaryHit:) colStruct:bodyCollide] retain];
        headBoundary_ = [[Boundary boundaryWithTarget:self collide:nil hit:@selector(secondaryHit) colStruct:headCollide] retain];
        [boundaries_ addObject:bodyBoundary_];
        [boundaries_ addObject:headBoundary_];        
        
        CGSize size = [[CCDirector sharedDirector] winSize];        
        CGFloat leftCutoff = - 0.5 * size.width;
        CGFloat rightCutoff  = size.width + 0.5 * size.width;
        yTarget_ = 0.80 * size.height;
    
        sprite_.flipX = YES;
        numShells_ = 0;
        maxShells_ = 6;
        
        // Setup the initial fall
        ConstantMovementWithStop *initial = [ConstantMovementWithStop constantMovementWithStop:self rate:-1.0f withStop:yTarget_];
        [movements_ addObject:initial];
        
        // Setup the side-to-side movement of the boss
        sideMovement_ = [[SideMovement sideMovement:self leftCutoff:leftCutoff rightCutoff:rightCutoff speed:3] retain];
        sideMovement_.delegate = self;
        [sideMovement_ setProximityTrigger:25.0f];
        [movements_ addObject:sideMovement_];        
        
        [self initActions];
        [self showIdle];        
        
        [self initEngineFlame];
        [self engineFlameGoingRight:YES];
    }
    return self;
}

- (void) dealloc
{
#if DEBUG_DEALLOCS
    NSLog(@"%@ dealloc'd", self);    
#endif
    
    [name_ release];
    [sprite_ release];
    [idleAnimation_ release];
    [damageAnimation_ release];
    [engineFlame_ release];
    [headBoundary_ release];
    [bodyBoundary_ release];
    
    [super dealloc];
}

- (void) initActions
{
    NSString *animationName = [NSString stringWithFormat:@"%@ Fly", name_];
	CCAnimation *animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	CCActionInterval *animate = [CCAnimate actionWithAnimation:animation];
	idleAnimation_ = [[CCRepeatForever actionWithAction:animate] retain];
	
    animationName = [NSString stringWithFormat:@"%@ Damage", name_];    
	animation = [[CCAnimationCache sharedAnimationCache] animationByName:animationName];
	damageAnimation_ = [[CCAnimate actionWithAnimation:animation] retain];    
}                 

- (void) showDamage
{
	[sprite_ stopAllActions];	
    
    CCActionInterval *delay = [CCDelayTime actionWithDuration:0.5];
	TargetedAction *animation = [TargetedAction actionWithTarget:sprite_ actionIn:(CCFiniteTimeAction *)damageAnimation_];
	CCFiniteTimeAction *method = [CCCallFunc actionWithTarget:self selector:@selector(showIdle)];	
	[self runAction:[CCSequence actions:animation, delay, method, nil]];	
}

- (void) startShellSequence
{
    CCActionInterval *delay = [CCDelayTime actionWithDuration:0.1];
    CCFiniteTimeAction *deploy = [CCCallFunc actionWithTarget:self selector:@selector(deployShell)];
    CCActionInterval *seq = [CCSequence actions:deploy, delay, nil];
    [self runAction:[CCRepeat actionWithAction:seq times:maxShells_]];
}

- (void) startDeathSequence
{
    CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:0.05f];
    CCFiniteTimeAction *blast = [CCCallFunc actionWithTarget:self selector:@selector(addBlast)];
    CCFiniteTimeAction *seq = [CCSequence actions:blast, delay, nil];
    CCFiniteTimeAction *repeat = [CCRepeat actionWithAction:seq times:80];
    CCFiniteTimeAction *delay2 = [CCDelayTime actionWithDuration:0.2f];    
    CCFiniteTimeAction *startFall = [CCCallFunc actionWithTarget:self selector:@selector(startFreeFall)];
    CCFiniteTimeAction *explosion = [CCCallFunc actionWithTarget:self selector:@selector(addBigExplosion)];
    CCFiniteTimeAction *delay3 = [CCDelayTime actionWithDuration:4.0f];
    CCFiniteTimeAction *end = [CCCallFunc actionWithTarget:self selector:@selector(death)];
    [self runAction:[CCSequence actions:repeat, delay2, startFall, explosion, delay3, end, nil]];
}

- (void) deployShell
{
    [[GameManager gameManager] addObstacle:self.position type:kShell];
}

- (void) startFreeFall
{
    // Remove the side movement and have a typical falling movement instead    
    [movements_ removeAllObjects];
    [movements_ addObject:[StaticMovement staticMovement:self]];
}

- (void) addBlast
{
    CGPoint pos;
    
    // Randomize
    NSInteger x = 150;
    NSInteger y = 100;
    pos.x = arc4random() % x;
    pos.y = arc4random() % y;
    // Weirdest issue - combining these two operations does not seem to work
    pos.x -= x/2;
    pos.y -= y/2;
    
    BlastCloud *blast = [BlastCloud blastCloudAt:pos size:1.0 text:kBamText];
    [self addChild:blast];
    
    if (arc4random() % 100 < 25) {
        [[AudioManager audioManager] playSound:kExplosion01];
    }
}

- (void) addBigExplosion
{
    sprite_.visible = NO;
    BigExplosion *explosion = [BigExplosion bigExplosionAt:CGPointZero];
    [self addChild:explosion];
}

- (void) sideMovementLeftTurnaround:(SideMovement *)movement
{
    sprite_.flipX = NO;                   
    [self engineFlameGoingRight:NO];
    PVCollide c = headBoundary_.collide;
    c.offset = headOffset_;
    headBoundary_.collide = c;    
}

- (void) sideMovementRightTurnaround:(SideMovement *)movement
{
    sprite_.flipX = YES; 
    [self engineFlameGoingRight:YES];       
    PVCollide c = headBoundary_.collide;
    c.offset = ccp(-headOffset_.x, headOffset_.y);
    headBoundary_.collide = c;    
}

- (void) sideMovementProximityTrigger:(SideMovement *)movement
{
    if (HP_ > 0 && self.position.y <= yTarget_) {
        [self startShellSequence];
    }
}

- (void) primaryHit:(PointWrapper *)pos
{
    // Account for offset, since pos is in terms of screen grid
    CGPoint p = ccpSub(pos.point, self.position);
    // Turtle takes no damage on shell hit
    BlastCloud *blast = [BlastCloud blastCloudAt:p size:1.0 text:kBamText];
    [self addChild:blast];  
}

- (void) secondaryHit
{
    // Creature death
    if (--HP_ == 0) {
        // Deactivate hit boundaries
        PVCollide c1 = headBoundary_.collide;
        PVCollide c2 = bodyBoundary_.collide;
        c1.hitActive = NO;
        c2.hitActive = NO;
        headBoundary_.collide = c1;
        bodyBoundary_.collide = c2;
        engineFlame_.emissionRate = 0;
        
        // Change the speed of side movement whilst dying
        // Notice - we release it here to remove the extra circular reference
        // because at this point, we no longer need to keep a reference to it
        [sideMovement_ changeSideSpeed:0.6f];
        
        [self startDeathSequence];
    }
    else {
        [self showDamage];        
    }
}

- (void) death
{        
    [super flagToDestroy];
}

#pragma mark - Particle System

- (void) initEngineFlame
{
    engineFlame_ = [[EngineParticleSystem PSForBossTurtleFlame] retain];
	[self addChild:engineFlame_ z:-2];
}

- (void) engineFlameGoingRight:(BOOL)right
{
    if (right) {
        engineFlame_.gravity = ccp(50, 0);
        engineFlame_.position = ccp(80, 27);
    }
    else {
        engineFlame_.gravity = ccp(-50, 0);
        engineFlame_.position = ccp(-80, 27);
    }
}

@end
