//
//  HGSiteCommunicator.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/27/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HOST_BASE_URL (@"http://kiff:8000")
//#define HOST_BASE_URL (@"http://hagreve.com")
#define API_RELATIVE_PATH (@"/api/v1/")
#define API_STRIKE_LIST_PATH (@"strikes")

@interface HGSiteCommunicator : NSObject

@property (nonatomic, retain) NSURL *baseURL;
@property (nonatomic, retain) NSURL *apiURL;
@property (nonatomic, retain) NSURL *apiStrikeListURL;

- (HGSiteCommunicator *)init;
- (HGSiteCommunicator *)initWithBaseURL:(NSString*)base_url andAPIPath:(NSString*)api_path;

- (NSArray *)getStrikeList;

@end
