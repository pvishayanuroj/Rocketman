//
//  Wall.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/13/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "Wall.h"
#import "Boundary.h"
#import "StaticMovement.h"
#import "GameManager.h"

@implementation Wall

+ (id) wallWithPos:(CGPoint)pos wallName:(NSString *)wallName side:(WallSide)side
{
    return [[[self alloc] initWithPos:pos wallName:wallName side:side] autorelease];
}

- (id) initWithPos:(CGPoint)pos wallName:(NSString *)wallName side:(WallSide)side
{
    if ((self = [super init])) {
     
        self.position = pos;
        sprite_ = [[CCSprite spriteWithFile:wallName] retain];
        sprite_.flipX = (side == kWallRight);
        [self addChild:sprite_];
        
        PVCollide collide = defaultPVCollide_;
        collide.circular = NO;
        collide.size.width = 15;
        collide.size.height = 480;
        collide.hitActive = NO;
        collide.collideActive = NO;
        
        // Bounding box setup
        boundary_ = [[Boundary boundary:self colStruct:collide] retain];
        [boundaries_ addObject:boundary_];   
        
        [movements_ addObject:[StaticMovement staticMovement]];        
        
    }
    return self;
}

- (void) dealloc
{
    [sprite_ release];
    [boundary_ release];
    
    [super dealloc];
}

- (void) boundaryCollide:(NSInteger)boundaryID
{
    NSLog(@"WALL COLLIDE");
}

@end
