//
//  HGCompany.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGCompany : NSObject {

    /*
     * API interface as of 2011/10/26
     *
     *   "company": {
     *     "name": "Airplane company"
     *   }
     *
     */
    
    NSString *name;
}

@property (nonatomic, retain) NSString *name;

@end