//
//  HGViewController.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/20/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

// Project includes
#import "HGAppDelegate.h"
#import "HGStrikeDetailViewController.h"
#import "HGStrikeDays.h"
#import "HGStrike.h"
#import "HGUtils.h"

// Framework includes
#import "PullRefreshTableViewController.h"
#import <UIKit/UIKit.h>

#define kArrowFilename (@"blackArrow")

// Tags for the StrikeListTableViewCell's subviews
#define kCellTagTitle         11
#define kCellTagSubtitle      12
#define kCellTagComment       13
#define kCellTagCanceledImage 14
#define kCellTagDay           15
#define kCellTagMonth         16

// Sizes for the offline banner
#define kOfflineBannerHeight 22
#define kOfflineBannerFontSize 14
#define kOfflineBannerLabelX 10  // == kHeaderLabelMargin

@interface HGStrikeListTableViewController : PullRefreshTableViewController
  <UITableViewDelegate,UITableViewDataSource>

#if DEBUG==1
@property (nonatomic) BOOL debug;
@property (nonatomic, retain) UIBarButtonItem *toggleDebugButton;
#endif
@property (nonatomic) BOOL isOffline;
@property (nonatomic, retain) UIView *offlineToolbar;
@property (nonatomic, retain) HGStrikeDays *strikeDays;
@property (nonatomic, retain) IBOutlet UITableViewCell *protoCell;

- (BOOL)saveStrikeDaysToCache;

#pragma mark - TableView dataSource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
- (NSInteger)realRowNumberForIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Text to present in the UI
- (NSString *)cellTitleTextForStrike:(HGStrike *)strike;
- (NSString *)cellSubtitleTextForStrike:(HGStrike *)strike;
- (NSString *)cellCommentTextForStrike:(HGStrike *)strike;

#pragma mark - Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender;

#pragma mark - View lifecycle
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

#pragma mark - pull to refresh handler
- (void)refresh;
- (void)updateStrikes;

#pragma mark - Reloading data
- (void)reloadDataAndStopLoading;
- (void)reloadData;

#if DEBUG==1
#pragma mark - Debug
- (IBAction)toggleDebugTable:(id)sender;
#endif

#pragma mark - Misc methods
- (void)alertUserForError:(NSError*)error;
- (void)showOfflineBanner:(BOOL)animated;
- (void)hideOfflineBanner:(BOOL)animated;
- (void)setStrikeDays:(HGStrikeDays*)strikeDays;

- (UIColor *)backgroundColorForOddRows;
- (UIColor *)backgroundColorForEvenRows;
- (UIColor *)offlineToolbarTint;

@end
