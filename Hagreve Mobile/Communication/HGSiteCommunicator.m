//
//  HGSiteCommunicator.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/27/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

#import "HGUtils.h"
#import "HGStrike.h"
#import "HGCompany.h"
#import "HGSubmitter.h"

#import "HGSiteCommunicator.h"

@implementation HGSiteCommunicator

@synthesize baseURL = _baseURL;
@synthesize apiURL  = _apiURL;
@synthesize apiStrikeListURL = _apiStrikeListURL;

- (HGSiteCommunicator *)initWithBaseURL:(NSString*)base_url andAPIPath:(NSString*)api_path {
    if (!(self = [super init]))
        return nil;

    self.baseURL = [NSURL URLWithString:base_url];
    self.apiURL  = [NSURL URLWithString:api_path relativeToURL:self.baseURL];
    self.apiStrikeListURL = [NSURL URLWithString:API_STRIKE_LIST_PATH relativeToURL:self.apiURL];

    return self;
}

- (HGSiteCommunicator *)initWithBaseURL:(NSString*)base_url {
    if (!(self = [self initWithBaseURL:base_url andAPIPath:API_RELATIVE_PATH]))
        nil;

    return self;
}

- (HGSiteCommunicator *)init {
    if (!(self = [self initWithBaseURL:HOST_BASE_URL andAPIPath:API_RELATIVE_PATH]))
        return nil;

    return self;
}

#if !defined NO_COMMUNICATION
/* Fields for the mock objects.
 *
 * {
 *   "all_day": false,
 *   "start_date": "2011-11-01 23:23:50",
 *   "end_date": "2011-11-03 23:23:52",
 *
 *   "canceled": false,
 *   "description": "Greve sobre Lx.",
 *   "source_link": "http://example.com/greve-airplane",
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
- (NSArray *)getStrikeList {

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

- (NSArray *)getStrikeList {
    
    // Open stream to server
    NSURLRequest *request = [NSURLRequest requestWithURL:self.apiStrikeListURL];
    NSURLResponse *response;
    NSError *error;

    // With this synchronous request, we have no control on caching nor auth.
    // The defaults will be used. We may have to change this later.
    NSData *unparsed = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (nil == unparsed) {
        DLog(@"Didn't get any data from %@. Bailing out!", request.URL);
        return nil;
    }

    // Parse JSON object (from the API, we know it's an array)
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:unparsed options:0 error:&error];
    if (nil == jsonObject) {
        DLog(@"jsonObject == nil. Bailing out!");
        return nil;
    }

    DLog(@"JSON: %@", jsonObject);
    // Convert to NSArray of HGStrike objects
    NSMutableArray *strikeList = [NSMutableArray arrayWithCapacity:jsonObject.count];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    for (NSDictionary *jsonStrike in (NSArray*)jsonObject) {
        HGStrike *strike = [HGStrike new];
        strike.id = [(NSNumber*)[jsonStrike valueForKey:@"id"] unsignedIntegerValue];

        strike.all_day = [(NSNumber*)[jsonStrike valueForKey:@"all_day"] boolValue];
        strike.startDate = [dateFormatter dateFromString:[jsonStrike valueForKey:@"start_date"]];
        strike.endDate = [dateFormatter dateFromString:[jsonStrike valueForKey:@"end_date"]];

        strike.canceled = [(NSNumber*)[jsonStrike valueForKey:@"canceled"] boolValue];
        strike.comment  = [jsonStrike valueForKey:@"description"];
        strike.sourceLink = [NSURL URLWithString:[jsonStrike valueForKey:@"source_link"]];

        HGCompany *company = [HGCompany new];
        strike.company = company;
        company.name = [[jsonStrike valueForKey:@"company"] valueForKey:@"name"];

        HGSubmitter *submitter = [HGSubmitter new];
        strike.submitter = submitter;
        NSDictionary *jsonSubmitter = [jsonStrike valueForKey:@"submitter"];
        submitter.lastName = [jsonSubmitter valueForKey:@"first_name"];
        submitter.lastName = [jsonSubmitter valueForKey:@"last_name"];

        [strikeList addObject:strike];
    }

    return strikeList;
}

#endif

@end
