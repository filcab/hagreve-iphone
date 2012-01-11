//
//  HGViewController.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/20/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

#import "HGStrikeListTableViewController.h"

@implementation HGStrikeListTableViewController

#if DEBUG==1
@synthesize toggleDebugButton = _toggleDebugButton;
@synthesize debug = _debug;
#endif
@synthesize strikeDays = _strikeDays;
@synthesize protoCell = _protoCell;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - TableView dataSource and delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"StrikeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[NSBundle mainBundle] loadNibNamed:@"StrikeCell" owner:self options:nil];
        cell = _protoCell;
        self.protoCell = nil;
    }

    NSArray *strikesForDay = [self.strikeDays strikesForStrikeDay:indexPath.section];
    HGStrike *strike = [strikesForDay objectAtIndex:indexPath.row];

    UILabel *label = (UILabel *)[cell viewWithTag:kCellTagTitle];
    label.text = [HGUtils cellTitleTextForStrike:strike];

    label = (UILabel *)[cell viewWithTag:kCellTagSubtitle];
    label.text = [HGUtils cellSubtitleTextForStrike:strike];

    label = (UILabel *)[cell viewWithTag:kCellTagComment];
    label.text = [HGUtils cellCommentTextForStrike:strike];

    UIImageView *imageView = (UIImageView*)[cell viewWithTag:kCellTagCanceledImage];
    if (strike.canceled) {
        imageView.hidden = NO;
    } else {
        imageView.hidden = YES;
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.strikeDays.strikes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.strikeDays strikesForStrikeDay:section].count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    NSDateComponents *day = [self.strikeDays.daysWithStrikes objectAtIndex:section];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];

    return [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateFromComponents:day]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    NSInteger rowNumber = [self realRowNumberForIndexPath:indexPath inTableView:tableView];
    UIColor *bgColor = rowNumber % 2 == 0 ? [self backgroundColorForEvenRows]
                                          : [self backgroundColorForOddRows];

	// create the parent view that will hold header Label
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kHeaderLabelWidth, kHeaderLabelHeight)];
    UIView *sideLineView = [[UIView alloc] initWithFrame:CGRectMake(kHeaderSideLineHMargin, kHeaderSideLineVMargin, kHeaderSideLineWidth, kHeaderLabelHeight - 2*kHeaderSideLineVMargin)];
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(kHeaderTopLineHMargin, kHeaderTopLine_VMargin, kHeaderLabelWidth - 2*kHeaderTopLineHMargin, kHeaderTopLineHeight)];
    [sideLineView setBackgroundColor:[UIColor blackColor]];
    [topLineView setBackgroundColor:[UIColor blackColor]];

    // create the button object
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(kHeaderLabelMargin, 0.0,kHeaderLabelWidth, kHeaderLabelHeight)];
    headerLabel.opaque = NO;
    headerLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16];

    headerLabel.text = [self tableView:tableView titleForHeaderInSection:section];

    [customView addSubview:sideLineView];
    [customView addSubview:topLineView];
    [customView addSubview:headerLabel];

    customView.opaque = NO;
    customView.backgroundColor = bgColor;

    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 28.0;
}


- (NSInteger)realRowNumberForIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView *)tableView
{
	NSInteger realNumber = 0;
	if (!indexPath.section)	{
		return indexPath.row;
	}

	for (int i = 0 ; i < indexPath.section ; ++i) {
		realNumber += [tableView numberOfRowsInSection:i];
    }

	return realNumber + indexPath.row;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    static UIColor *colorEven, *colorOdd;
    if (nil == colorEven)
        colorEven = [self backgroundColorForEvenRows];
    if (nil == colorOdd)
        colorOdd  = [self backgroundColorForOddRows];

	NSInteger n = [self realRowNumberForIndexPath:indexPath inTableView:tableView];
	cell.backgroundColor = (n % 2) ? colorOdd : colorEven;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	/*
	 To conform to the Human Interface Guidelines, selections should not be persistent --
	 deselect the row after it has been selected.
	 */
    [self performSegueWithIdentifier:@"StrikeDetailSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - segues and transitions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*
     When a row is selected, the segue creates the detail view controller as the destination.
     Set the detail view controller's detail item to the item associated with the selected row.
     */
    DLog(@"Preparing segue with identifier \"%@\".", segue.identifier);
    if ([segue.identifier isEqualToString:@"StrikeDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HGStrikeDetailTableViewController *detailViewController = [segue destinationViewController];

        NSArray *strikesForDay = [self.strikeDays strikesForStrikeDay:indexPath.section];
        detailViewController.strike = [strikesForDay objectAtIndex:indexPath.row];
    }
}

- (IBAction)toggleDebugTable:(id)sender {
#if DEBUG==1
    self.debug = !self.debug;

    if (self.debug) {
        self.toggleDebugButton.title = @"Current";
    } else {
        self.toggleDebugButton.title = @"Debug";
    }

    DLog(@"Scrolling to top and refreshing");
    [self scrollToTopAndRefresh];
#endif
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize stuff.

    self.imageFileName = kArrowFilename;
#if DEBUG==1
    self.toggleDebugButton.possibleTitles = [NSSet setWithObjects:@"Debug", @"Current", nil];
#else
    self.toggleDebugButton = nil;
#endif
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation == UIInterfaceOrientationPortrait);
    } else {
        return YES;
    }
}

#pragma mark - pull to refresh handler
- (void)refresh {
    [self performSelectorInBackground:@selector(updateStrikes) withObject:nil];
}

- (void)updateStrikes {
    HGStrikeDays *strikeDays;

#if DEBUG==1
    if (self.debug) {
        strikeDays = [HGStrikeDays strikeDaysFromWebsite:DEBUG_HOST_URL];
    } else {
        strikeDays = [HGStrikeDays strikeDaysFromWebsite];
    }
#else
    strikeDays = [HGStrikeDays strikeDaysFromWebsite];
#endif

    if (strikeDays) {
        self.strikeDays = strikeDays;
    } // else: Warn the user?

    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    [self.tableView setNeedsLayout];
    [self performSelectorOnMainThread:@selector(stopLoading) withObject:nil waitUntilDone:YES];
}

#pragma mark - Misc methods
- (void)setStrikeDays:(HGStrikeDays*)strikeDays {
    _strikeDays = strikeDays;
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

- (UIColor *)backgroundColorForEvenRows {
    static UIColor *evenColor;
    if (nil == evenColor) // Use the same alpha as the gray color
        evenColor = [UIColor colorWithWhite:1.0f alpha:0.90f];

    return evenColor;
}

- (UIColor *)backgroundColorForOddRows {
    static UIColor *oddColor;
    if (nil == oddColor) {
        // rgba(203,203,203,0.3) == rgba(0.7961,0.7961,0.7961,0.3)
//        oddColor = [UIColor colorWithRed:0.7961f green:0.7961f blue:0.7961f alpha:0.3f];
        // From wikipedia/alpha_blending:
        // out_RGB = src_RGB * src_A + dst_RGB * (1-src_A)
        // true color over white:
        // out = 0.7961 * 0.3 + 1 * 0.7 == 0.9388

        // to have alpha = 0.9f:
        // 0.9388 = x * 0.9 + 1 * 0.1 <=> x = (0.9388 - 0.1)/0.9
        // x == 0.932
        // oddColor = [UIColor colorWithWhite:0.932f alpha:0.90f];

        // to have alpha = 0.95f:
        // 0.9388 = x * 0.95 + 1 * 0.05 <=> x = (0.9388 - 0.05)/0.95
        // x == 0.9356
        oddColor = [UIColor colorWithWhite:0.9356f alpha:0.95f];
    }


    return oddColor;
}

@end
