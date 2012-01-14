//
//  HGCompany.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/26/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGCompany : NSObject

/*
 * API interface as of 2011/10/26
 *
 *   "company": {
 *     "name": "Airplane company"
 *   }
 *
 */

@property (nonatomic, retain) NSString *name;

- (HGCompany*)init;
- (NSComparisonResult)compare:(HGCompany *)aString;

#pragma mark - NSCoding
- (HGCompany*)initWithCoder:(NSCoder*)aCoder;
- (void)encodeWithCoder:(NSCoder *)aCoder;

@end
