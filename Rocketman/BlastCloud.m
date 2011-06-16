//
//  BlastCloud.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 6/14/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "BlastCloud.h"

@implementation BlastCloud

@synthesize destroyed = destroyed_;

+ (id) blastCloudAt:(CGPoint)pos size:(CGFloat)size text:(EventText)text
{
    return [[[self alloc] initBlastCloudAt:pos size:size text:text] autorelease];
}

- (id) initBlastCloudAt:(CGPoint)pos size:(CGFloat)size text:(EventText)text
{
    if ((self = [super init])) {
        
        self.position = pos;
        destroyed_ = NO;
        
        [self addSprites:text size:size];
        
        CCFiniteTimeAction *delay = [CCDelayTime actionWithDuration:0.3f];
        CCCallFunc *method = [CCCallFunc actionWithTarget:self selector:@selector(destroy)];
        [self runAction:[CCSequence actions:delay, method, nil]];
        
    }
    return self;
}

- (void) dealloc
{
#if DEBUG_DEALLOCS
    NSLog(@"Blast Cloud dealloc'd");
#endif
    
    [super dealloc];
}

- (void) addSprites:(EventText)text size:(CGFloat)size
{
    CCSprite *blastCloud = [CCSprite spriteWithSpriteFrameName:@"Blast Cloud.png"];    
    CCSprite *blast = [CCSprite spriteWithSpriteFrameName:@"Blast.png"];        
    CCSprite *textSprite;
    
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
    
    blastCloud.scale = 1.2 * size;
    blast.scale = size;
    textSprite.scale = 0.7 * size;
    
    [self addChild:blastCloud];
    [self addChild:blast];
    [self addChild:textSprite];
}

- (void) fall:(CGFloat)speed
{
    CGPoint p = CGPointMake(0, speed);
    self.position = ccpSub(self.position, p);    
}

- (void) destroy
{
    destroyed_ = YES;
    [self removeFromParentAndCleanup:YES];
}

@end
