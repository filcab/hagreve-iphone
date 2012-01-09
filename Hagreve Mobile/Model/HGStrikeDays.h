//
//  HGStrikeDays.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/28/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

// Project includes
#include "HGSiteCommunicator.h"

// Framework includes
#import <Foundation/Foundation.h>

@interface HGStrikeDays : NSObject

@property (nonatomic, retain) NSURL *baseURL;
@property (nonatomic, retain) NSArray *strikeDays;
@property (nonatomic, retain) NSDictionary *strikes;
@property (nonatomic, retain) HGSiteCommunicator *communicator;

+ (HGStrikeDays*)strikeDaysFromWebsite;
+ (HGStrikeDays*)strikeDaysFromSavedState;
+ (HGStrikeDays*)strikeDaysFromWebsite:(NSString*)base_url;

- (NSArray *)daysWithStrikes;
- (NSArray *)strikesForDay:(NSDateComponents *)aDay;
- (NSArray *)strikesForStrikeDay:(NSUInteger)aDay;

- (NSString *)description;

@end
