//
//  Strike.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HGStrike.h"

@implementation HGStrike

@synthesize all_day = _all_day;
@synthesize start_date = _start_date;
@synthesize end_date = _end_date;

@synthesize canceled = _canceled;
@synthesize description = _description;
@synthesize source_link = _source_link;

@synthesize region = _region;
@synthesize company = _company;
@synthesize submitter = _submitter;

- (HGStrike*)init {
    if (!(self = [super init]))
        return nil;

    self.all_day = false;
    self.start_date = nil;
    self.end_date = nil;

    self.canceled = false;
    self.description = @"No description";
    self.source_link = [NSURL URLWithString:@"http://example.com"];

    self.region = nil;
    self.company = nil;
    self.submitter = nil;

    return self;
}

@end
