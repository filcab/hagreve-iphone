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

@synthesize allDay = _all_day;
@synthesize startDate = _startDate;
@synthesize endDate = _endDate;

@synthesize canceled = _canceled;
@synthesize comment = _comment;
@synthesize sourceLink = _sourceLink;
@synthesize url = _url;

@synthesize company = _company;
@synthesize submitter = _submitter;

- (HGStrike*)init {
    if (!(self = [super init]))
        return nil;

    self.id = -1;

    self.allDay = false;
    self.startDate = nil;
    self.endDate = nil;

    self.canceled = false;
    self.comment = @"No description";
    self.sourceLink = [NSURL URLWithString:@"http://hagreve.com"];
    self.url = [NSURL URLWithString:@"http://hagreve.com"];

    self.company = nil;
    self.submitter = nil;

    return self;
}

#pragma mark - NSCoding
- (HGStrike*)initWithCoder:(NSCoder*)aCoder {
    if (!(self = [super init]))
        return nil;

    self.id = [aCoder decodeIntegerForKey:@"id"];

    self.allDay = [aCoder decodeBoolForKey:@"allDay"];
    self.startDate = [aCoder decodeObjectForKey:@"startDate"];
    self.endDate = [aCoder decodeObjectForKey:@"endDate"];

    self.canceled = [aCoder decodeBoolForKey:@"canceled"];
    self.comment = [aCoder decodeObjectForKey:@"comment"];
    self.sourceLink = [aCoder decodeObjectForKey:@"sourceLink"];
    self.url = [aCoder decodeObjectForKey:@"url"];

    self.company = [aCoder decodeObjectForKey:@"company"];
    self.submitter = [aCoder decodeObjectForKey:@"submitter"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:self.id forKey:@"id"];

    [aCoder encodeBool:self.allDay forKey:@"allDay"];
    [aCoder encodeObject:self.startDate forKey:@"startDate"];
    [aCoder encodeObject:self.endDate forKey:@"endDate"];

    [aCoder encodeBool:self.canceled forKey:@"canceled"];
    [aCoder encodeObject:self.comment forKey:@"comment"];
    [aCoder encodeObject:self.sourceLink forKey:@"sourceLink"];
    [aCoder encodeObject:self.url forKey:@"url"];

    [aCoder encodeObject:self.company forKey:@"company"];
    [aCoder encodeObject:self.submitter forKey:@"submitter"];
}


@end
