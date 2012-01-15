//
//  HGAppDelegate.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/20/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

// Project includes
#import "HGUtils.h"
#import "HGStrikeDays.h"
#import "HGStrikeDetailViewController.h"
#import "HGStrikeListTableViewController.h"

// Framework includes
#import <UIKit/UIKit.h>

#define kSaveStrikesPath (@"savedStrikes.plist")

@interface HGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (BOOL)saveStrikeDaysToCache:(HGStrikeDays*)strikeDays;

@end
