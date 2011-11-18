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

// Scale factors for the blast, cloud, and text
const CGFloat LBC_BLAST_SCALE = 1.0f;
const CGFloat LBC_CLOUD_SCALE = 1.2f;
const CGFloat LBC_TEXT_SCALE = 0.7f;
// How long the explosion lasts
const CGFloat LBC_BLAST_DURATION = 0.3f;

+ (id) lightBlastCloudAt:(CGPoint)pos
{
    return [[[self alloc] initLightBlastCloudAt:pos size:1.0f text:kRandomDeathText movements:nil] autorelease];
}

+ (id) lightBlastCloudAt:(CGPoint)pos movements:(NSMutableArray *)movements
{
    return [[[self alloc] initLightBlastCloudAt:pos size:1.0f text:kRandomDeathText movements:movements] autorelease];    
}

+ (id) lightBlastCloudAt:(CGPoint)pos size:(CGFloat)size text:(EventText)text movements:(NSMutableArray *)movements
{
    return [[[self alloc] initLightBlastCloudAt:pos size:size text:text movements:movements] autorelease];
}

- (id) initLightBlastCloudAt:(CGPoint)pos size:(CGFloat)size text:(EventText)text movements:(NSMutableArray *)movements
{
    if ((self = [super init])) {
        
        self.position = pos;
        zDepth_ = kBlastCloudDepth;
        
        [self addSprites:text size:size];
        
        CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:LBC_BLAST_DURATION];
        CCCallFunc *method = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
        [self runAction:[CCSequence actions:delay, method, nil]];
        
        for (Movement *movement in movements) {
            [movements_ addObject:[[movement copy] autorelease]];
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
    
    blastCloud.scale = LBC_CLOUD_SCALE * size;
    blast.scale = LBC_BLAST_SCALE * size;
    textSprite.scale = LBC_TEXT_SCALE * size;
    
    [self addChild:blastCloud];
    [self addChild:blast];
    [self addChild:textSprite];
}

- (void) destroy
{
    destroyed_ = YES;
}

@end
