//
//  HGSiteCommunicator.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HOST_BASE_URL (@"http://localhost:8000")
#define API_RELATIVE_PATH (@"/api/v1")

@interface HGSiteCommunicator : NSObject {
    NSURL *baseURL;
    NSURL *apiURL;
}

@property (nonatomic, retain) NSURL *baseURL;
@property (nonatomic, retain) NSURL *apiURL;

- (HGSiteCommunicator*)init;
- (HGSiteCommunicator*)initWithBaseURL:(NSString*)base_url andAPIPath:(NSString*)api_path;

- (NSArray*)getStrikeList;

@end
