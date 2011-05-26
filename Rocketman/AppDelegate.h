//
//  AppDelegate.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 5/26/11.
//  Copyright Paul Vishayanuroj 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
