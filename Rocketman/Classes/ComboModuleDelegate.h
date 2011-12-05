//
//  ComboModuleDelegate.h
//  Rocketman
//
//  Created by Paul Vishayanuroj on 11/19/11.
//  Copyright (c) 2011 Paul Vishayanuroj. All rights reserved.
//

#import "CommonHeaders.h"

@protocol ComboModuleDelegate <NSObject>

- (void) comboCountUpdate:(NSInteger)count;

- (void) comboActivated;

- (void) comboDeactivated;

@end

