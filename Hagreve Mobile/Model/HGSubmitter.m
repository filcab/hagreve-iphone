//
//  HGSubmitter.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/26/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

#import "HGSubmitter.h"

@implementation HGSubmitter

@synthesize firstName = _firstName;
@synthesize lastName  = _lastName;

#pragma mark - NSCoding
- (HGSubmitter*)initWithCoder:(NSCoder*)aCoder {
    if (!(self = [super init]))
        return nil;
    
    self.lastName = [aCoder decodeObjectForKey:@"lastName"];
    self.firstName = [aCoder decodeObjectForKey:@"firstName"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
}

@end
