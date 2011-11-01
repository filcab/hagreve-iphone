//
//  HGViewController.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

// Project includes
#include "HGStrike.h"
#include "HGStrikeDays.h"

// Framework includes
#import <UIKit/UIKit.h>

@interface HGStrikeListTableViewController : UITableViewController
  <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) HGStrikeDays *strikeDays;

@end
