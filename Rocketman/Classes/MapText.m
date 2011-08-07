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
        NSString *fontName = @"Verdana-Bold";
        CGFloat fontSize = 14;
        
        text_ = [[CCLabelTTF labelWithString:@"" fontName:fontName fontSize:fontSize] retain];
        
        [self addChild:text_];
        text_.position = ccp(0, -5);
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
    title_ = [[NSString stringWithString:title] retain];
    NSString *fullText = [NSString stringWithFormat:@"%@: %@", title_, desc_];
    [text_ setString:fullText];
}

- (void) setDesc:(NSString *)desc
{
    desc_ = [[NSString stringWithString:desc] retain];
    NSString *fullText = [NSString stringWithFormat:@"%@: %@", title_, desc_];
    [text_ setString:fullText];    
}

- (void) moveDown
{
    CGPoint move = ccp(0, -105);
    CCActionInterval *down = [CCMoveBy actionWithDuration:0.5 position:move];
    CCActionInstant *done = [CCCallFunc actionWithTarget:self selector:@selector(doneMovingDown)];
    [self stopAllActions];
    [self runAction:[CCSequence actions:down, done, nil]];
}

- (void) moveUp
{
    CGPoint move = ccp(0, 105);
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
