//
//  HGUtils.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 11/5/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

// Project includes
// Framework includes
#import <Foundation/Foundation.h>

#ifdef TESTFLIGHT
#  import "TestFlight.h"
#  define TestFlightCheckpoint(name) ([TestFlight passCheckpoint:name])
#else
#  define TestFlightCheckpoint(name)
#endif

#ifdef DEBUG
#  ifdef TESTFLIGHT
#    define DLog(...) TFLog(@"%s:%d  %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#  else
#    define DLog(...) NSLog(@"" __VA_ARGS__)
#  endif
#else
#  ifdef TESTFLIGHT
#    define DLog(...) TFLog(@"%s:%d  %@", __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#  else
#    define DLog(...)
#  endif
#endif
