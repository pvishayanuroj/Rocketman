//
//  VictoryScene.m
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/15/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "VictoryScene.h"
#import "IncrementingText.h"
#import "FallingRocket.h"

@implementation VictoryScene

static const CGFloat VS_TITLE_X = 0.02f;
static const CGFloat VS_SCORE_X = 0.9f;
static const CGFloat VS_SCORE_Y_TOP = 0.7f;
static const CGFloat VS_SCORE_Y_SEPERATION = 0.1f;

+ (id) victoryScene:(SRSMScore)score
{
    return [[[self alloc] initVictoryScene:score] autorelease];
}

- (id) initVictoryScene:(SRSMScore)score
{
    if ((self = [super init])) {
        
        CGSize size = [[CCDirector sharedDirector] winSize];        
        
        // Add background sky
        NSString *backgroundName = [NSString stringWithFormat:@"Sky Background.png"];
        CCSprite *bg = [CCSprite spriteWithFile:backgroundName];
        [self addChild:bg z:0];
        bg.anchorPoint = CGPointZero;        
        
        // Add foreground element
        NSString *foregroundName = [NSString stringWithFormat:@"Mountains Parallax.png"];
        CCSprite *fg = [CCSprite spriteWithFile:foregroundName];
        fg.anchorPoint = CGPointZero;
        [self addChild:fg z:1];
        
        NSArray *scoreTitles = [self createScoreTitles];
        scoreLabels_ = [[self createScoreLabels:score] retain];
        
        // Add score titles
        NSInteger count = 0;        
        for (CCLabelBMFont *title in scoreTitles) {
            title.position = CGPointMake(size.width * VS_TITLE_X, size.height * (VS_SCORE_Y_TOP - VS_SCORE_Y_SEPERATION * count));
            title.anchorPoint = CGPointMake(0.0f, 0.5f);
            [self addChild:title z:3];
            count++;
        }        
        
        // Add scores
        count = 0;
        for (IncrementingText *text in scoreLabels_) {
            text.unitID = count;
            text.delegate = self;
            text.position = CGPointMake(size.width * VS_SCORE_X, size.height * (VS_SCORE_Y_TOP - VS_SCORE_Y_SEPERATION * count));
            [self addChild:text z:3];
            count++;
        }
        
        // Add the falling rocket
        FallingRocket *rocket = [FallingRocket fallingRocket];
        [self addChild:rocket z:2];
    }
    return self;
}

- (void) dealloc
{
    [scoreLabels_ release];
    
    [super dealloc];
}

- (NSArray *) createScoreTitles
{
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:10];
    
    CCLabelBMFont *elapsedTime = [CCLabelBMFont labelWithString:@"Time" fntFile:R_DARK_FONT];
    [titles addObject:elapsedTime];    
    
    CCLabelBMFont *enemiesKilled = [CCLabelBMFont labelWithString:@"Killed" fntFile:R_DARK_FONT];
    [titles addObject:enemiesKilled];
    
    CCLabelBMFont *collisions = [CCLabelBMFont labelWithString:@"Coll." fntFile:R_DARK_FONT];
    [titles addObject:collisions];    
    
    return titles;        
}

- (NSArray *) createScoreLabels:(SRSMScore)score
{
    NSMutableArray *labels = [NSMutableArray arrayWithCapacity:10];

    NSInteger elapsedTime = round(score.elapsedTime * 10);
    IncrementingText *time = [IncrementingText incrementingText:elapsedTime font:R_DARK_FONT alignment:kRightAligned isTime:YES];
    [labels addObject:time];
    
    IncrementingText *numKilled = [IncrementingText incrementingText:score.numEnemiesKilled font:R_DARK_FONT alignment:kRightAligned isTime:NO];
    [labels addObject:numKilled];    
    
    IncrementingText *collisions = [IncrementingText incrementingText:score.numCollisions font:R_DARK_FONT alignment:kRightAligned isTime:NO];
    [labels addObject:collisions];        
    
    return labels;
}

- (void) incrementationDone:(IncrementingText *)text
{
    // Kick off the next score
    NSInteger index = text.unitID + 1;
    if ([scoreLabels_ count] > index) {
        IncrementingText *scoreText = [scoreLabels_ objectAtIndex:index];
        [scoreText startIncrementing];
    }
}

@end
