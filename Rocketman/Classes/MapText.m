//
//  MapText.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 7/24/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "MapText.h"

@implementation MapText

@synthesize delegate = delegate_;

+ (id) mapTextWithPos:(CGPoint)pos
{
    return [[[self alloc] initMapTextWithPos:pos] autorelease];
}

- (id) initMapTextWithPos:(CGPoint)pos
{
    if ((self = [super init])) {
        
        self.position = pos;
        
        // Background
        CCSprite *background = [CCSprite spriteWithFile:@"text_background.png"];
        [self addChild:background];
        
        // Text
        NSString *fontName = @"Helvetica";
        CGFloat fontSize = 14;
        
        title_ = [[CCLabelTTF labelWithString:@"" fontName:fontName fontSize:fontSize] retain];
        desc_ = [[CCLabelTTF labelWithString:@"" fontName:fontName fontSize:fontSize] retain];
        
        [self addChild:title_];
        [self addChild:desc_];
        title_.position = ccp(0, 0);
        desc_.position = ccp(0, -20);
        
    }
    return self;
}

- (void) dealloc
{
    [title_ release];
    [desc_ release];
    
    [super dealloc];
}

- (void) setTitle:(NSString *)title
{
    [title_ setString:title];
}

- (void) setDesc:(NSString *)desc
{
    [desc_ setString:desc];
}

- (void) moveDown
{
    CGPoint move = ccp(0, -100);
    CCActionInterval *down = [CCMoveBy actionWithDuration:0.5 position:move];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(doneMovingDown)];
    [self stopAllActions];
    [self runAction:[CCSequence actions:down, done, nil]];
}

- (void) moveUp
{
    CGPoint move = ccp(0, 100);
    CCActionInterval *up = [CCMoveBy actionWithDuration:0.5 position:move];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(doneMovingUp)];
    [self stopAllActions];
    [self runAction:[CCSequence actions:up, done, nil]];    
}

- (void) doneMovingDown
{
    [delegate_ mapTextMovedDown:self];
}

- (void) doneMovingUp
{
    [delegate_ mapTextMovedUp:self];
}

@end
