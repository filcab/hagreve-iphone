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
@synthesize debug = _debug;
@synthesize toggleDebugButton = _toggleDebugButton;
#endif
@synthesize isOffline = _isOffline;
@synthesize offlineToolbar;
@synthesize strikeDays = _strikeDays;
@synthesize protoCell = _protoCell;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
    if (!self.isOffline) {
        [self.offlineToolbar removeFromSuperview];
        self.offlineToolbar = nil;
    }
}

- (BOOL)saveStrikeDaysToCache {
    return [(HGAppDelegate*)[[UIApplication sharedApplication] delegate] saveStrikeDaysToCache:self.strikeDays];
}

#pragma mark - TableView dataSource and delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.strikeDays || 0 == self.strikeDays.count) {
        NSString *identifier = @"NoStrikesCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            DLog(@"oh crap! NoStrikesCell didn't get dequeued.");
            exit(1);
        }
        UILabel *noStrikeText = (UILabel*)[cell viewWithTag:1];
        noStrikeText.text = @"Woohoo!\nNão há greves, podemos ir trabalhar! 😃";
        return cell;
    }

    static NSString *MyIdentifier = @"StrikeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"StrikeCell" owner:self options:nil];
        cell = _protoCell;
        self.protoCell = nil;
    }

    NSArray *days = self.strikeDays.strikeDays;
    // 'today' will always be larger that any strike's NSDateComponents for today
    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];

    NSUInteger nSections = 0;
    NSUInteger nStrikes = 0;
    while (nSections < days.count
           && [[cal dateFromComponents:[days objectAtIndex:nSections]] compare:today] == NSOrderedAscending) {
        nStrikes += [self.strikeDays strikesForStrikeDay:nSections].count;
        ++nSections;
    }

    NSArray *strikesForDay;
    NSInteger row = indexPath.row;
    if (0 == nSections) { // No strikes up to tomorrow
        strikesForDay = [self.strikeDays strikesForStrikeDay:indexPath.section];
    } else if (0 == indexPath.section) { // Today's section
        nSections = 0;
        while (nSections < days.count
               && [[cal dateFromComponents:[days objectAtIndex:nSections]] compare:today] == NSOrderedAscending) {
            strikesForDay = [self.strikeDays strikesForStrikeDay:nSections];
            NSInteger n = strikesForDay.count;
            if (n <= row)
                row -= n;
            else
                break;
            ++nSections;
        }
    } else { // There are strikes that started before today (or today). Not today's section.
        strikesForDay = [self.strikeDays strikesForStrikeDay:(nSections + indexPath.section - 1)];
    }

    HGStrike *strike = [strikesForDay objectAtIndex:row];

    UILabel *label = (UILabel *)[cell viewWithTag:kCellTagTitle];
    label.text = [self cellTitleTextForStrike:strike];

    label = (UILabel *)[cell viewWithTag:kCellTagSubtitle];
    label.text = [self cellSubtitleTextForStrike:strike];

    label = (UILabel *)[cell viewWithTag:kCellTagComment];
    label.text = [self cellCommentTextForStrike:strike];

    UIImageView *imageView = (UIImageView*)[cell viewWithTag:kCellTagCanceledImage];
    if (strike.canceled) {
        imageView.hidden = NO;
    } else {
        imageView.hidden = YES;
    }

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.strikeDays || 0 == self.strikeDays.count)
        return 1;

    __block NSInteger n = 0;
    NSArray *days = self.strikeDays.strikeDays;
    // 'today' will always be larger that any strike's NSDateComponents for today
    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];

    [days enumerateObjectsUsingBlock:^(NSDateComponents *date, NSUInteger i, BOOL *stop) {
        if ([[cal dateFromComponents:date] compare:today] == NSOrderedAscending)
            ++n;
    }];

    if (n > 0)
        return days.count - n + 1;
    else
        return days.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.strikeDays || 0 == self.strikeDays.count)
        return 1;

    NSInteger n = 0;
    NSArray *days = [self.strikeDays daysWithStrikes];
    // 'today' will always be larger that any strike's NSDateComponents for today
    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];

    NSUInteger nSections = 0;
    NSUInteger nStrikes = 0;
    while (nSections < days.count &&
           [[cal dateFromComponents:[days objectAtIndex:nSections]] compare:today] == NSOrderedAscending) {
        nStrikes += [self.strikeDays strikesForStrikeDay:nSections].count;
        ++nSections;
    }

    if (0 == nSections) { // No strikes up to tomorrow
        n = [self.strikeDays strikesForStrikeDay:section].count;
    } else if (0 == section) { // Today's section
        n = nStrikes;
    } else { // There are strikes that started before today (or today). Not today's section.
        n = [self.strikeDays strikesForStrikeDay:(nSections + section - 1)].count;
    }

    return n;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!self.strikeDays || 0 == self.strikeDays.count)
        return @"";

    NSArray *days = self.strikeDays.strikeDays;
    // 'today' will always be larger that any strike's NSDateComponents for today
    NSDate *today = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];

    NSUInteger n = 0;
    while (n < days.count
           && [[cal dateFromComponents:[days objectAtIndex:n]] compare:today] == NSOrderedAscending) {
        ++n;
    }

    NSDateComponents *day;
    if (0 == n) { // No strikes up to tomorrow
        day = [days objectAtIndex:section];
    } else if (0 == section) { // Today's section
        NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
        day = [cal components:units fromDate:today];
    } else { // There are strikes that started before today (or today). Not today's section.
        day = [days objectAtIndex:(n + section - 1)];
    }

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];

    return [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateFromComponents:day]];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (!self.strikeDays || 0 == self.strikeDays.count)
        return nil;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    NSInteger rowNumber = [self realRowNumberForIndexPath:indexPath inTableView:tableView];
    UIColor *bgColor = rowNumber % 2 == 0 ? [self backgroundColorForEvenRows]
                                          : [self backgroundColorForOddRows];

	// create the parent view that will hold the header Label
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
	return (self.strikeDays && 0 != self.strikeDays.count) ? kHeaderLabelHeight : 0;
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

- (NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.strikeDays || 0 == self.strikeDays.count)
        return nil;

    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.strikeDays || 0 == self.strikeDays.count)
        return;

	/*
	 To conform to the Human Interface Guidelines, selections should not be persistent --
	 deselect the row after it has been selected.
	 */
    [self performSegueWithIdentifier:@"StrikeDetailSegue" sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Text to present in the UI
- (NSString *)cellTitleTextForStrike:(HGStrike *)strike {
    return strike.company.name;
}

- (NSString *)cellSubtitleTextForStrike:(HGStrike *)strike {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit dayMonthYear = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    
    NSDateComponents *startDayComponents = [cal components:dayMonthYear fromDate:strike.startDate];
    NSDateComponents *endDayComponents   = [cal components:dayMonthYear fromDate:strike.endDate];
    
    NSDate *startDay = [cal dateFromComponents:startDayComponents];
    NSDate *endDay   = [cal dateFromComponents:endDayComponents];
    
    if ([startDay compare:endDay] == NSOrderedSame) {
        if (strike.allDay)
            return @"Todo o dia";
        
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterShortStyle];
        [df setDateStyle:NSDateFormatterNoStyle];
        
        return [NSString stringWithFormat:@"Das %@ às %@",
                [df stringFromDate:strike.startDate],
                [df stringFromDate:strike.endDate]];
    }
    
    // startDay != endDay
    if (strike.allDay) {
        NSDateFormatter *df = [NSDateFormatter new];
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterMediumStyle];
        
        return [NSString stringWithFormat:@"Até %@",
                [df stringFromDate:strike.endDate]];
    }
    
    // !all_day (I don't think this usually happens.
    NSDateFormatter *df = [NSDateFormatter new];
    [df setTimeStyle:NSDateFormatterShortStyle];
    [df setDateStyle:NSDateFormatterMediumStyle];
    
    return [NSString stringWithFormat:@"De %@ até %@",
            [df stringFromDate:strike.startDate],
            [df stringFromDate:strike.endDate]];
}

- (NSString *)cellCommentTextForStrike:(HGStrike *)strike {
    return strike.comment;
}

#pragma mark - segues and transitions

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*
     When a row is selected, the segue creates the detail view controller as the destination.
     Set the detail view controller's detail item to the item associated with the selected row.
     */
    if ([segue.identifier isEqualToString:@"StrikeDetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HGStrikeDetailViewController *detailViewController = [segue destinationViewController];

        NSArray *days = self.strikeDays.strikeDays;
        // 'today' will always be larger that any strike's NSDateComponents for today
        NSDate *today = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        
        NSUInteger nSections = 0;
        NSUInteger nStrikes = 0;
        while (nSections < days.count
               && [[cal dateFromComponents:[days objectAtIndex:nSections]] compare:today] == NSOrderedAscending) {
            nStrikes += [self.strikeDays strikesForStrikeDay:nSections].count;
            ++nSections;
        }

        NSArray *strikesForDay;
        NSInteger row = indexPath.row;
        if (0 == nSections) { // No strikes up to tomorrow
            strikesForDay = [self.strikeDays strikesForStrikeDay:indexPath.section];
        } else if (0 == indexPath.section) { // Today's section
            nSections = 0;
            while (nSections < days.count
                   && [[cal dateFromComponents:[days objectAtIndex:nSections]] compare:today] == NSOrderedAscending) {
                strikesForDay = [self.strikeDays strikesForStrikeDay:nSections];
                NSInteger n = strikesForDay.count;
                if (n <= row)
                    row -= n;
                else
                    break;
                ++nSections;
            }
        } else { // There are strikes that started before today (or today). Not today's section.
            strikesForDay = [self.strikeDays strikesForStrikeDay:(nSections + indexPath.section - 1)];
        }

        detailViewController.strike = [strikesForDay objectAtIndex:row];
    }
}

#if DEBUG==1
- (IBAction)toggleDebugTable:(id)sender {
    self.debug = !self.debug;

    if (self.debug) {
        self.toggleDebugButton.title = @"Current";
    } else {
        self.toggleDebugButton.title = @"Debug";
    }

    [self scrollToTopAndRefresh];
}
#endif

#pragma mark - View lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageFileName = kArrowFilename;
    self.offlineToolbar = nil;
}

- (void)viewDidLoad {
    // Initialize stuff.
#if DEBUG==1
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Debug" style:UIBarButtonItemStylePlain target:self action:@selector(toggleDebugTable:)];
    button.possibleTitles = [NSSet setWithObjects:@"Debug", @"Current", nil];
    self.navigationItem.rightBarButtonItem = button;
    self.toggleDebugButton = button;
#endif

    [super viewDidLoad];
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
        return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
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
    NSError *error;

#if DEBUG==1
    if (self.debug) {
        strikeDays = [HGStrikeDays strikeDaysFromWebsite:DEBUG_HOST_URL error:&error];
    } else {
        strikeDays = [HGStrikeDays strikeDaysFromWebsiteReturningError:&error];
    }
#else
    strikeDays = [HGStrikeDays strikeDaysFromWebsiteReturningError:&error];
#endif

    if (strikeDays) {
        self.strikeDays = strikeDays;
        if (self.isOffline) {
            self.isOffline = NO;
            // HACK: We don't pass nil => animated == YES
            [self performSelectorOnMainThread:@selector(hideOfflineBanner:) withObject:self waitUntilDone:NO];
        }
    } else {
        // If we don't have any useful (old) information, set strikeDays to nil
        if (self.strikeDays && 0 == self.strikeDays.count)
            self.strikeDays = nil;

        self.isOffline = YES;
        [self performSelectorOnMainThread:@selector(showOfflineBanner:) withObject:self waitUntilDone:NO];

        [self performSelectorOnMainThread:@selector(alertUserForError:) withObject:error waitUntilDone:NO];
    }

    [self performSelectorOnMainThread:@selector(reloadDataAndStopLoading) withObject:nil waitUntilDone:YES];
}

#pragma mark - Reloading data
- (void)reloadDataAndStopLoading {
    [self reloadData];
    [self stopLoading];
}

- (void)reloadData {
    [self.strikeDays cleanup];
    [self.tableView reloadData];
}

#pragma mark - Misc methods
- (void)alertUserForError:(NSError*)error {
    NSString *errorString;

    if ([NSURLErrorDomain isEqualToString:error.domain]) {
        errorString = @"Foi impossível contactar o site.";
    } else {
        errorString = @"Ocorreu um erro ao obter informações.";
    }

#if DEBUG == 1
    errorString = [NSString stringWithFormat:@"%@\n%@\n%@",
                   errorString, error.localizedDescription, error.debugDescription];
#endif

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Erro"
                                                        message:errorString
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)showOfflineBanner:(BOOL)animated {
    if (nil == self.offlineToolbar) {
        // Initialize off-screen.
        UIToolbar *offlineToolbar_= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 480, 320, kOfflineBannerHeight)];
        offlineToolbar_.barStyle = UIBarStyleDefault;
        offlineToolbar_.tintColor = [UIColor colorWithRed:0.90f green:0.10f blue:0.10f alpha:1.0];
        UILabel *offlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(kOfflineBannerLabelX, 0, 320, kOfflineBannerHeight)];
        offlineLabel.font = [UIFont boldSystemFontOfSize:kOfflineBannerFontSize];
        offlineLabel.backgroundColor = [UIColor clearColor];
        offlineLabel.text = @"Offline";
        [offlineToolbar_ addSubview:offlineLabel];
        self.offlineToolbar = offlineToolbar_;
        [self.navigationController.view addSubview:self.offlineToolbar];
    }

    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.42];
    }
    self.offlineToolbar.frame = CGRectMake(0, 480 - kOfflineBannerHeight, 320, kOfflineBannerHeight);
    if (animated)
        [UIView commitAnimations];
}

- (void)hideOfflineBanner:(BOOL)animated {
    if (self.offlineToolbar) {
        if (animated) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.42];
        }
        self.offlineToolbar.frame = CGRectMake(0, 480, 320, kOfflineBannerHeight);
        if (animated)
            [UIView commitAnimations];
    }
}

- (void)setStrikeDays:(HGStrikeDays*)strikeDays {
    _strikeDays = strikeDays;
    [self performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self saveStrikeDaysToCache];
}

- (UIColor *)backgroundColorForEvenRows {
    static UIColor *evenColor = nil;
    if (nil == evenColor) // Use the same alpha as the gray color
        evenColor = [UIColor colorWithWhite:1.0f alpha:0.90f];

    return evenColor;
}

- (UIColor *)backgroundColorForOddRows {
    static UIColor *oddColor = nil;
    if (nil == oddColor) {
        // rgba(203,203,203,0.3) == rgba(0.7961,0.7961,0.7961,0.3)
        // oddColor = [UIColor colorWithRed:0.7961f green:0.7961f blue:0.7961f alpha:0.3f];
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

- (UIColor *) offlineBannerColor {
    static UIColor *grey = nil;
    if (nil == grey)
        grey = [UIColor colorWithRed:1.0 green:0.8f blue:0.8f alpha:0.95f];

    return grey;
}

@end
