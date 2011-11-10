//
//  HGUtils.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 11/5/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

// Project includes
#include "HGStrike.h"

// Framework includes
#import <Foundation/Foundation.h>

#define HGDISPATCH_QUEUE_NAME "com.hagreve.dispatch-queue"

@interface HGUtils : NSObject

+ (NSString *)cellTitleTextForStrike:(HGStrike *)strike;
+ (NSString *)cellSubtitleTextForStrike:(HGStrike *)strike;
+ (NSString *)cellCommentTextForStrike:(HGStrike *)strike;

@end
