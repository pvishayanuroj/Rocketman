//
//  LightBlastCloud.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/1/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "LightBlastCloud.h"
#import "StaticMovement.h"

@implementation LightBlastCloud

+ (id) lightBlastCloudAt:(CGPoint)pos
{
    return [[[self alloc] initLightBlastCloudAt:pos size:1.0f text:kRandomDeathText movement:kStaticMovement] autorelease];
}

+ (id) lightBlastCloudAt:(CGPoint)pos movement:(MovementType)movement
{
    return [[[self alloc] initLightBlastCloudAt:pos size:1.0f text:kRandomDeathText movement:movement] autorelease];    
}

+ (id) lightBlastCloudAt:(CGPoint)pos size:(CGFloat)size text:(EventText)text movement:(MovementType)movement
{
    return [[[self alloc] initLightBlastCloudAt:pos size:size text:text movement:movement] autorelease];
}

- (id) initLightBlastCloudAt:(CGPoint)pos size:(CGFloat)size text:(EventText)text movement:(MovementType)movement
{
    if ((self = [super init])) {
        
        self.position = pos;
        zDepth_ = kBlastCloudDepth;
        
        [self addSprites:text size:size];
        
        CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:0.3f];
        CCCallFunc *method = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
        [self runAction:[CCSequence actions:delay, method, nil]];
        
        if (movement == kStaticMovement) {
            [movements_ addObject:[StaticMovement staticMovement]];
        }
        
    }
    return self;
}

- (void) dealloc
{
#if DEBUG_DEALLOCS
    NSLog(@"Light Blast Cloud dealloc'd");
#endif
    
    [super dealloc];
}

- (void) addSprites:(EventText)text size:(CGFloat)size
{
    CCSprite *blastCloud = [CCSprite spriteWithSpriteFrameName:@"Blast Cloud.png"];    
    CCSprite *blast = [CCSprite spriteWithSpriteFrameName:@"Blast.png"];        
    CCSprite *textSprite;
    
    if (text == kRandomDeathText) {
        text = arc4random() % 2 ? kBamText : kPlopText;
    }
    
    switch (text) {
        case kBamText:
            textSprite = [CCSprite spriteWithSpriteFrameName:@"Bam Text.png"];            
            break;
        case kPlopText:
            textSprite = [CCSprite spriteWithSpriteFrameName:@"Plop Text.png"];            
            break;            
        default:
            textSprite = [CCSprite spriteWithSpriteFrameName:@"Bam Text.png"];            
    }    
    
    blastCloud.scale = 1.2f * size;
    blast.scale = 1.0f * size;
    textSprite.scale = 0.7f * size;
    
    [self addChild:blastCloud];
    [self addChild:blast];
    [self addChild:textSprite];
}

- (void) destroy
{
    destroyed_ = YES;
}

@end
