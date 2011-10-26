//
//  Strike.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

// Project includes
#include "HGCompany.h"
#include "HGRegion.h"
#include "HGSubmitter.h"

// Framework includes
#import <Foundation/Foundation.h>

@interface HGStrike : NSObject {

/*
 * API object for a strike as of 2011/10/26
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
 *
 */

bool all_day;
NSDate *start_date;
NSDate *end_date;

bool canceled;
NSString *description;
NSURL *source_link;

HGRegion *region;
HGCompany *company;
HGSubmitter *submitter;

}



@end
