//
//  HGViewController.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/20/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

// Project includes
#import "HGStrikeDetailController.h"
#import "HGStrikeDays.h"
#import "HGUtils.h"

// Framework includes
#import "PullRefreshTableViewController.h"
#import <UIKit/UIKit.h>

@interface HGStrikeListTableViewController : PullRefreshTableViewController
  <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, retain) HGStrikeDays *strikeDays;
@property (nonatomic, retain) IBOutlet UITableViewCell *protoCell;

@end
