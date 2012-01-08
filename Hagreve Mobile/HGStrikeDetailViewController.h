//
//  HGStrikeDetailController.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

// Project includes
#import "HGStrike.h"

// Framework includes
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define CELL_WIDTH 320
#define CELL_HEIGHT 45
#define CELL_BORDERS (10*2)
#define DATE_CELL_HEIGHT 44
#define REGULAR_FONT_SIZE 17.0
#define TITLE_FONT_SIZE 15.0
#define SUBTITLE_FONT_SIZE 12.0

@interface HGStrikeDetailViewController : UITableViewController <UIActionSheetDelegate>

@property (nonatomic, retain) HGStrike *strike;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - UIActionSheet creator and delegate
- (void)openOrCopyURL:(NSURL *)url;
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

#pragma mark - Font stuff
- (UIFont *)regularFont;
- (UIFont *)titleFont;
- (UIFont *)subtitleFont;
@end
