//
//  Strike.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/26/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

// Project includes
#include "HGCompany.h"
#include "HGSubmitter.h"

// Framework includes
#import <Foundation/Foundation.h>

@interface HGStrike : NSObject

/*
 * API object for a strike as of 2011/10/26
 *
 * {
 *   "id": 42,
 *
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
 *
 */

@property (nonatomic) NSUInteger id;

@property (nonatomic) BOOL all_day;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;

@property (nonatomic) BOOL canceled;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSURL *sourceLink;

@property (nonatomic, retain) HGCompany *company;
@property (nonatomic, retain) HGSubmitter *submitter;

- (HGStrike*)init;

@end
