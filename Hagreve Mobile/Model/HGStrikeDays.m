//
//  HGStrikeDay.m
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
@synthesize communicator = _communicator;

- (void)update
{
    if (nil == self.communicator) {
        self.communicator = [[HGSiteCommunicator alloc] init];
    }

    NSArray *parsedStrikes = [self.communicator getStrikeList];

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

    self.strikeDays = [days sortedArrayUsingComparator:^NSComparisonResult(NSDateComponents *d1, NSDateComponents *d2) {
        return [[cal dateFromComponents:d1] compare: [cal dateFromComponents:d2]];
    }];
    self.strikes = strikes;
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

@end
