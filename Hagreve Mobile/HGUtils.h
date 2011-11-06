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

// Tags for the StrikeListTableViewCell's subviews
#define TAG_TITLE    1
#define TAG_SUBTITLE 2
#define TAG_COMMENT  3

@interface HGUtils : NSObject

+ (NSString *)cellTitleTextForStrike:(HGStrike *)strike;
+ (NSString *)cellSubtitleTextForStrike:(HGStrike *)strike;
+ (NSString *)cellCommentTextForStrike:(HGStrike *)strike;

@end
