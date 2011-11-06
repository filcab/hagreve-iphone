//
//  HGCompany.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/26/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

#import "HGCompany.h"

@implementation HGCompany

@synthesize name = _name;

- (HGCompany*)init {
    if (!(self = [super init]))
        return nil;

    self.name = @"";
    return self;
}

- (NSComparisonResult)compare:(HGCompany *)aCompany {
    return [self.name compare:aCompany.name];
}

@end
