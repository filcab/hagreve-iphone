//
//  HGStrikeDays.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/28/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

#import "HGStrike.h"
#import "HGStrikeDays.h"

@implementation HGStrikeDays

@synthesize strikeDays = _strikeDays;
@synthesize strikes = _strikes;
@synthesize count = _count;

//+ (HGStrikeDays*)strikeDays {
//    HGStrikeDays *sDays = [HGStrikeDays new];
//    sDays.strikeDays = [NSArray array];
//    sDays.strikes = [NSDictionary dictionary];
//    return sDays;
//}

+ (HGStrikeDays*)strikeDaysFromSavedState {
    return nil;
}

+ (HGStrikeDays*)strikeDaysFromWebsite {
    return [HGStrikeDays strikeDaysFromWebsiteReturningError:nil];
}

+ (HGStrikeDays*)strikeDaysFromWebsiteReturningError:(NSError**)error {
    return [HGStrikeDays strikeDaysFromWebsite:HOST_BASE_URL error:error];
}

+ (HGStrikeDays*)strikeDaysFromWebsite:(NSString*)base_url {
    return [HGStrikeDays strikeDaysFromWebsite:base_url error:nil];
}

+ (HGStrikeDays*)strikeDaysFromWebsite:(NSString*)base_url error:(NSError**)error {
    HGSiteCommunicator *communicator = [[HGSiteCommunicator alloc] initWithBaseURL:base_url];

    NSArray *parsedStrikes = [communicator getStrikeList];

    // An error occured.
    if (nil == parsedStrikes) {
        if (error)
            *error = communicator.lastError;
        return nil;
    }

    NSMutableDictionary *strikes = [NSMutableDictionary dictionary];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;

    NSMutableArray *days = [NSMutableArray array];

    for (HGStrike *strike in parsedStrikes) {
        NSDateComponents *day = [cal components:units fromDate:[strike startDate]];
        NSMutableArray *dayStrikes = [strikes objectForKey:day];
        if (nil == dayStrikes) {
            dayStrikes = [NSMutableArray array];
            [strikes setObject:dayStrikes forKey:day];
            [days addObject:day];
        }

        [dayStrikes addObject:strike];
    }

    NSArray *daysWithStrikes = [days sortedArrayUsingComparator:^NSComparisonResult(NSDateComponents *d1, NSDateComponents *d2) {
        return [[cal dateFromComponents:d1] compare: [cal dateFromComponents:d2]];
    }];

    HGStrikeDays *sDays = [[HGStrikeDays alloc] initWithDays:daysWithStrikes strikes:strikes];
    return sDays;
}

- (HGStrikeDays*)initWithDays:(NSArray*)strikeDays strikes:(NSDictionary*)strikes {
    if (!(self = [super init]))
        return nil;

    __block NSUInteger n = 0;
    [strikes enumerateKeysAndObjectsUsingBlock:^(id key, NSDictionary *obj, BOOL *stop) {
        n += obj.count;
    }];

    _strikeDays = strikeDays;
    _strikes = strikes;
    _count = n;
    return self;
}

- (NSArray *)daysWithStrikes {
    return self.strikeDays;
}

- (NSArray *)strikesForStrikeDay:(NSUInteger)aDay {
    return [self.strikes objectForKey:[self.strikeDays objectAtIndex:aDay]];
}

- (NSArray *)strikesForDay:(NSDateComponents *)aDay {
    return [self.strikes objectForKey:aDay];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"strikeDays: %@", self.strikes];
}

- (void)cleanup {
    NSMutableArray *newDays = [NSMutableArray arrayWithCapacity:self.strikeDays.count];
    NSMutableDictionary *newStrikes = [NSMutableDictionary dictionaryWithCapacity:self.strikes.count];

    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *todayDC = [cal components:units fromDate:today];

    for (NSDateComponents *day in self.strikeDays) {
        NSArray *strikesForDay = [self.strikes objectForKey:day];
        NSMutableArray *newStrikesForDay = [NSMutableArray arrayWithCapacity:strikesForDay.count];

        for (HGStrike *strike in strikesForDay) {
            if ([strike.endDate compare:today] == NSOrderedDescending) {
                [newStrikesForDay addObject:strike];
                continue;
            }

            NSDateComponents *end = [cal components:units fromDate:strike.endDate];
            if (end.day == todayDC.day && end.month == todayDC.month && end.year == todayDC.year
                && strike.allDay) {
                [newStrikesForDay addObject:strike];
                continue;
            }
        }

        if (newStrikesForDay.count > 0) {
            [newDays addObject:day];
            [newStrikes setObject:[NSArray arrayWithArray:newStrikesForDay] forKey:day];
        }
    }

    _strikeDays = newDays;
    _strikes = newStrikes;

    __block NSUInteger n = 0;
    [newStrikes enumerateKeysAndObjectsUsingBlock:^(id key, NSDictionary *obj, BOOL *stop) {
        n += obj.count;
    }];

    _count = n;
}

#pragma mark - NSCoding
- (HGStrikeDays*)initWithCoder:(NSCoder *)aCoder {
    if (!(self = [super init]))
        return nil;

    _strikeDays = [aCoder decodeObjectForKey:@"strikeDays"];
    _strikes = [aCoder decodeObjectForKey:@"strikes"];
    _count = [aCoder decodeIntegerForKey:@"count"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.strikeDays forKey:@"strikeDays"];
    [aCoder encodeObject:self.strikes forKey:@"strikes"];
    [aCoder encodeInteger:(NSInteger)self.count forKey:@"count"];
}


@end
