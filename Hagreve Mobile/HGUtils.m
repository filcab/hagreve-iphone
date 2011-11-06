//
//  HGUtils.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 11/5/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HGUtils.h"

@implementation HGUtils

+ (NSString *)cellTitleTextForStrike:(HGStrike *)strike {
    return strike.company.name;
}

+ (NSString *)cellSubtitleTextForStrike:(HGStrike *)strike {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit dayMonthYear = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;

    NSDateComponents *startDayComponents = [cal components:dayMonthYear fromDate:strike.start_date];
    NSDateComponents *endDayComponents   = [cal components:dayMonthYear fromDate:strike.end_date];

    NSDate *startDay = [cal dateFromComponents:startDayComponents];
    NSDate *endDay   = [cal dateFromComponents:endDayComponents];

    if ([startDay compare:endDay] == NSOrderedSame) {
        if (strike.all_day)
            return @"Todo o dia";

        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterShortStyle];
        [df setDateStyle:NSDateFormatterNoStyle];

        return [NSString stringWithFormat:@"Das %@ às %@",
                         [df stringFromDate:strike.start_date],
                         [df stringFromDate:strike.end_date]];
    }

    // startDay != endDay
    if (strike.all_day) {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterMediumStyle];

        return [NSString stringWithFormat:@"Até %@",
                         [df stringFromDate:strike.end_date]];
    }

    // !all_day (I don't think this usually happens.
    NSDateFormatter *df = [NSDateFormatter new];
    [df setTimeStyle:NSDateFormatterShortStyle];
    [df setDateStyle:NSDateFormatterMediumStyle];

    return [NSString stringWithFormat:@"De %@ até %@",
                     [df stringFromDate:strike.start_date],
                     [df stringFromDate:strike.end_date]];
}

+ (NSString *)cellCommentTextForStrike:(HGStrike *)strike {
    return strike.comment;
}

@end
