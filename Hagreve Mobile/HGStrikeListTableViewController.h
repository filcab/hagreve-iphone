//
//  HGViewController.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/20/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

// Project includes
#import "HGStrikeDetailTableViewController.h"
#import "HGStrikeDays.h"
#import "HGUtils.h"

// Framework includes
#import "PullRefreshTableViewController.h"
#import <UIKit/UIKit.h>

#define ARROW_FILENAME (@"arrow2")

// Tags for the StrikeListTableViewCell's subviews
#define TAG_TITLE       1
#define TAG_SUBTITLE    2
#define TAG_COMMENT     3
#define TAG_CANCELEDIMG 4

// Sizes for the StrikeList views
#define HEADER_LABEL_WIDTH  300.0
#define HEADER_LABEL_HEIGHT 28.0
#define HEADER_LABEL_MARGIN 10.0

#define HEADER_SIDELINE_VMARGIN 2.0
#define HEADER_SIDELINE_HMARGIN 2.0
#define HEADER_SIDELINE_WIDTH 1.0

#define HEADER_TOPLINE_HMARGIN 3.0
#define HEADER_TOPLINE_VMARGIN 2.0
#define HEADER_TOPLINE_HEIGHT 1.0


@interface HGStrikeListTableViewController : PullRefreshTableViewController
  <UITableViewDelegate,UITableViewDataSource>

#if DEBUG==1
@property (nonatomic) BOOL debug;
#endif
@property (nonatomic, retain) IBOutlet UIBarButtonItem *toggleDebugButton;
@property (nonatomic, retain) HGStrikeDays *strikeDays;
@property (nonatomic, retain) IBOutlet UITableViewCell *protoCell;

#pragma mark - TableView dataSource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)realRowNumberForIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - TableView selection
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

- (IBAction)toggleDebugTable:(id)sender;

#pragma mark - View lifecycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

#pragma mark - pull to refresh handler
- (void)refresh;
- (void)updateStrikes;

#pragma mark - Misc methods
- (UIColor *)backgroundColorForOddRows;
- (UIColor *)backgroundColorForEvenRows;

@end
