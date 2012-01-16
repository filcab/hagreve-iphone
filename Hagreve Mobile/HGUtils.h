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

#if TESTFLIGHT==1
#  import "TestFlight.h"
#  define TestFlightCheckpoint(name) ([TestFlight passCheckpoint:name])
#endif

#if DEBUG==1
#  if TESTFLIGHT==1
#    define DLog(__FORMAT__, ...) TFLog((@"%s:%d  " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#  else
#    define DLog(__FORMAT__, ...) NSLog(__FORMAT__, __VA_ARGS__)
#  endif
#else
#  if TESTFLIGHT==1
#    define DLog(__FORMAT__, ...) TFLog((@"%s:%d  " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#  else
#    define DLog(...)
#  endif
#endif
