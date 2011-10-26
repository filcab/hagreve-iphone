//
//  HGSubmitter.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGSubmitter : NSObject {
    /*
     * API interface as of 2011/10/26
     *
     *   "submitter": {
     *     "first_name": "",
     *     "last_name": ""
     *   }
     *
     */

    NSString *first_name;
    NSString *last_name;

}

@property (nonatomic, retain) NSString *first_name;
@property (nonatomic, retain) NSString *last_name;

@end
