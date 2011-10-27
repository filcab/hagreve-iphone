//
//  HGStrikeList.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

// Project includes
#include "HGSiteCommunicator.h"

// Framework includes
#import <Foundation/Foundation.h>


@interface HGStrikeList : NSObject {

    NSArray *strikes;
    NSArray *companies;
    NSArray *dates;

    HGSiteCommunicator *communicator;

}

@property (nonatomic, retain) NSArray *strikes;
@property (nonatomic, retain) NSArray *companies;
@property (nonatomic, retain) NSArray *dates;
@property (nonatomic, retain) HGSiteCommunicator *communicator;

@end
