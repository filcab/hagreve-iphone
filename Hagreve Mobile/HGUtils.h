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

#if DEBUG==1
#  define DLog(...) NSLog(__VA_ARGS__)
#else
#  define DLog(...)
#endif

//#define HGDISPATCH_QUEUE_NAME "com.hagreve.dispatch-queue"

@interface HGUtils : NSObject

+ (NSString *)cellTitleTextForStrike:(HGStrike *)strike;
+ (NSString *)cellSubtitleTextForStrike:(HGStrike *)strike;
+ (NSString *)cellCommentTextForStrike:(HGStrike *)strike;

@end
