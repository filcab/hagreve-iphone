//
//  HGSubmitter.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/26/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGSubmitter : NSObject

/*
 * API interface as of 2011/10/26
 *
 *   "submitter": {
 *     "first_name": "",
 *     "last_name": ""
 *   }
 *
 */

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;

#pragma mark - NSCoding
- (HGSubmitter*)initWithCoder:(NSCoder*)aCoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
