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

@interface HGStrikeDays : NSObject <NSCoding>

@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) NSArray *strikeDays;
@property (nonatomic, readonly) NSDictionary *strikes;

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
- (void)cleanup;

#pragma mark - NSCoding
- (HGStrikeDays*)initWithCoder:(NSCoder *)aCoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
