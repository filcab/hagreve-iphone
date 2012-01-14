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

@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, retain, readonly) NSArray *strikeDays;
@property (nonatomic, retain, readonly) NSDictionary *strikes;

//+ (HGStrikeDays*)strikeDays;
+ (HGStrikeDays*)strikeDaysFromSavedState;
+ (HGStrikeDays*)strikeDaysFromWebsite;
+ (HGStrikeDays*)strikeDaysFromWebsiteReturningError:(NSError**)error;
+ (HGStrikeDays*)strikeDaysFromWebsite:(NSString*)base_url error:(NSError**)error;

- (HGStrikeDays*)initWithDays:(NSArray*)strikeDays strikes:(NSDictionary*)strikes;
- (NSArray *)daysWithStrikes;
- (NSArray *)strikesForDay:(NSDateComponents *)aDay;
- (NSArray *)strikesForStrikeDay:(NSUInteger)aDay;

- (NSString *)description;

@end
