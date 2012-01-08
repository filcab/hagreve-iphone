//
//  Strike.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/26/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

#import "HGStrike.h"

@implementation HGStrike

@synthesize id = _id;

@synthesize all_day = _all_day;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;

@synthesize canceled = _canceled;
@synthesize comment = _comment;
@synthesize sourceLink = _sourceLink;

@synthesize company = _company;
@synthesize submitter = _submitter;

- (HGStrike*)init {
    if (!(self = [super init]))
        return nil;

    self.id = -1;

    self.all_day = false;
    self.startDate = nil;
    self.endDate = nil;

    self.canceled = false;
    self.comment = @"No description";
    self.sourceLink = [NSURL URLWithString:@"http://example.com"];

    self.company = nil;
    self.submitter = nil;

    return self;
}

@end
