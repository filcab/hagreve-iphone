//
//  HGStrikeList.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HGStrike.h"
#import "HGStrikeList.h"

@implementation HGStrikeList

@synthesize strikes      = _strikes;
@synthesize companies    = _companies;
@synthesize dates        = _dates;
@synthesize communicator = _communicator;


-(void)updateFields {
    // We're not doing this when parsing because the number of strikes is
    // always fairly low.
    NSMutableSet *companies_set;
    NSMutableSet *dates_set;

    // Collect unique companies/dates
    for (HGStrike *strike in strikes) {
        [companies_set addObject:strike.company];
        [dates_set     addObject:strike.start_date];
    }

    self.companies = [[companies_set allObjects] sortedArrayUsingSelector:@selector(compare:)];
    self.dates = [[dates_set allObjects] sortedArrayUsingSelector:@selector(compare:)];
}

-(void)update
{
    if (nil == communicator) {
        self.communicator = [[HGSiteCommunicator alloc] init];
    }

    self.strikes = [communicator getStrikeList];
    [self updateFields];
}

@end
