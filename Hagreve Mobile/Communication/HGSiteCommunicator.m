//
//  HGSiteCommunicator.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HGStrike.h"
#import "HGCompany.h"
#import "HGSubmitter.h"

#import "HGSiteCommunicator.h"

@implementation HGSiteCommunicator

@synthesize baseURL = _baseURL;
@synthesize apiURL  = _apiURL;

- (HGSiteCommunicator*)initWithBaseURL:(NSString*)base_url andAPIPath:(NSString*)api_path {
    if (!(self = [super init]))
        return nil;

    self.baseURL = [NSURL URLWithString:base_url];
    self.apiURL  = [NSURL URLWithString:api_path relativeToURL:self.baseURL];

    return self;
}

- (HGSiteCommunicator*)init {
    if (!(self = [self initWithBaseURL:HOST_BASE_URL andAPIPath:API_RELATIVE_PATH]))
        return nil;

    return self;
}

#if defined NO_COMMUNICATION
/*
 * {
 *   "all_day": false,
 *   "start_date": "2011-11-01 23:23:50",
 *   "end_date": "2011-11-03 23:23:52",
 *
 *   "canceled": false,
 *   "description": "Greve sobre Lx.",
 *   "source_link": "http://example.com/greve-airplane",
 *
 *   "region": {
 *     "name": "Lisboa"
 *   },
 *
 *   "company": {
 *     "name": "Airplane company"
 *   },
 *
 *   "submitter": {
 *     "first_name": "",
 *     "last_name": ""
 *   }
 * }
 */
- (NSArray*)getStrikeList {

    // Open stream to server
    // Parse JSON object
    // Convert to NSArray of HGStrike objects
    // return that

    HGCompany *c = [HGCompany new];
    c.name = @"Big Brother, Ltd.";

#define DAY (3600*24)

    HGStrike *s1 = [HGStrike new];
    s1.start_date = [NSDate dateWithTimeIntervalSinceNow:3*DAY];
    s1.end_date   = [NSDate dateWithTimeIntervalSinceNow:5*DAY];
    s1.comment = @"Strike 1!";
    s1.company = c;

    HGStrike *s2 = [HGStrike new];
    s2.start_date = [NSDate dateWithTimeIntervalSinceNow: 5*DAY];
    s2.end_date   = [NSDate dateWithTimeIntervalSinceNow: 5*DAY];
    s2.all_day = true;
    s2.company = c;

#undef DAY

    return [NSArray arrayWithObjects:s1, s2, nil];
}

#else

- (NSArray*)getStrikeList {
    return nil;
}

#endif

@end
