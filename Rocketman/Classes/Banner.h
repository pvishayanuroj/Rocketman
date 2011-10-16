//
//  Banner.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 10/12/11.
//  Copyright 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"
#import "cocos2d.h"
#import "BannerDelegate.h"

@interface Banner : CCNode <CCTargetedTouchDelegate> {

    CCSprite *sprite_;

    id <BannerDelegate> delegate_;
    
}

@property (nonatomic, assign) id <BannerDelegate> delegate;

+ (id) banner:(NSString *)bannerName delay:(CGFloat)delay;

- (id) initBanner:(NSString *)bannerName delay:(CGFloat)delay;

- (void) moveIn;

- (void) delayedMoveIn:(CGFloat)delay;

- (void) moveOut;

@end
