//
//  HGViewController.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

// Project includes
#import "HGStrikeDays.h"
#import "HGUtils.h"

// Framework includes
#import <UIKit/UIKit.h>

@interface HGStrikeListTableViewController : UITableViewController
  <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) HGStrikeDays *strikeDays;
@property (nonatomic, retain) IBOutlet UITableViewCell *protoCell;

@end
