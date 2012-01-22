//
//  HGStrikeDetailViewController.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 2012/01/09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HGStrikeDetailViewController.h"
#import "HGUtils.h"
#import <Twitter/Twitter.h>

@implementation HGStrikeDetailViewController

@synthesize strike            =            _strike,
            canceledImageView = _canceledImageView,
            scrollView        =        _scrollView,
            startDateLabel    =    _startDateLabel,
            startLabel        =        _startLabel,
            endDateLabel      =      _endDateLabel,
            endLabel          =          _endLabel,
            companyLabel      =      _companyLabel,
            commentLabel      =      _commentLabel,
            datesTitleLabel   =   _datesTitleLabel,
            companyTitleLabel = _companyTitleLabel,
            commentTitleLabel = _commentTitleLabel,
            sourceButton      =      _sourceButton,
            tweetButton       =       _tweetButton;

#pragma mark - Button actions

- (IBAction)tweetTouch:(id)sender {
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];

    [twitter addURL:self.strike.url];

    NSString *text;
    if ([@"Greve geral" isEqualToString:self.strike.company.name]) {
        text = @"A ver se consigo chegar ao trabalho, apesar da greve geral. #hagreve";
    } else  if ([@"Táxis" isEqualToString:self.strike.company.name]) {
        text = @"A ver se consigo chegar ao trabalho, apesar da greve dos táxis. #hagreve";
    } else {
        text = [NSString stringWithFormat:@"A ver se consigo chegar ao trabalho, apesar da greve da %@. #hagreve",
                self.strike.company.name];
    }
    [twitter setInitialText:text];

    // Show the controller
    [self presentModalViewController:twitter animated:YES];
}


- (IBAction)sourceTouch:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel action on source button") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Copy", @"Copy source URL to pasteboard"), NSLocalizedString(@"Open", @"Open source URL in browser"), nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheet delegate

#define SHEET_COPY_IDX 0
#define SHEET_OPEN_IDX 1
#define SHEET_CANCEL_IDX 2

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case SHEET_COPY_IDX: {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setURL:self.strike.sourceLink];
            break;
        }
        case SHEET_OPEN_IDX:
            [[UIApplication sharedApplication] openURL:self.strike.sourceLink];
            break;
        case SHEET_CANCEL_IDX:
            // No-op
            break;
    }
}

#pragma mark - View

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    // Setup the UILabels for the strike information.
    self.companyLabel.text   = self.strike.company.name;

    [self setupStrikeDateUIElements];

    if (self.strike.canceled){
        self.canceledImageView.hidden = NO;
    } else {
        self.canceledImageView.hidden = YES;
    }

    self.commentLabel.text  = self.strike.comment;

    [self layoutUIElements];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.sourceButton setTitle:NSLocalizedString(@"Source", "Source button text on the strike detail view.") forState:UIControlStateNormal];
    [self.sourceButton setTitle:NSLocalizedString(@"Source", "Source button text on the strike detail view.") forState:UIControlStateHighlighted];
    
    [self.tweetButton setTitle:NSLocalizedString(@"Tweet", "Tweet button text on the strike detail view.") forState:UIControlStateNormal];
    [self.tweetButton setTitle:NSLocalizedString(@"Tweet", "Tweet button text on the strike detail view.") forState:UIControlStateHighlighted];

    self.navigationItem.title = NSLocalizedString(@"Strike", @"Strike detail screen title (for navigation).");

    self.datesTitleLabel.text   = NSLocalizedString(@"Dates", @"'Dates' strike detail view label.");
    self.companyTitleLabel.text = NSLocalizedString(@"Company", @"'Company' strike detail view label.");
    self.commentTitleLabel.text = NSLocalizedString(@"Comment", @"'Comment' strike detail view label.");
}


- (void)viewDidUnload
{
    TestFlightCheckpoint(@"Exited strike detail view.");
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // It seems almost no iPhone app uses UIInterfaceOrientationPortraitUpsideDown
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self layoutUIElements];
}

#pragma mark - Date formatters
- (NSString*)labelForDate:(NSDate*)date allDay:(BOOL)all_day {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];

    if (all_day)
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    else
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

    return [dateFormatter stringFromDate:date];
}

#pragma mark - Misc methods
- (void)layoutUIElements {
    CGRect frame = self.commentLabel.frame;
    CGSize textSize = {0, 0};
    NSString *text = self.strike.comment;
    if (text && ![text isEqualToString:@""])
        textSize = [text sizeWithFont:self.commentLabel.font
                    constrainedToSize:CGSizeMake(self.commentLabel.frame.size.width, CGFLOAT_MAX)
                        lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = fmaxf(textSize.height, kCommentMinHeight);

    self.commentLabel.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), height);

    // Let's fix the UIScrollView's contentSize. Start by filling the whole UIScrollView
    CGSize scrollSize = self.scrollView.frame.size;

    // The default tableView sizes for each orientation (with top navbar)
    CGFloat minContentHeight = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? 441 : 320;
    CGFloat minCommentLabelSize = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? 123 : 21;

    // Height of the footer for the buttons.
    CGFloat buttonFooter = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? 100 : 80;

    self.scrollView.contentSize = CGSizeMake(scrollSize.width, height <= minCommentLabelSize ? minContentHeight : minContentHeight + height - minCommentLabelSize + kCommentFooter);

    CGFloat buttonYCoord = self.scrollView.contentSize.height - buttonFooter;

    // Put the other buttons in place. Autoresize isn't cutting it…
    frame = self.tweetButton.frame;
    self.tweetButton.frame = CGRectMake(CGRectGetMinX(frame), buttonYCoord, CGRectGetWidth(frame), CGRectGetHeight(frame));
    frame = self.sourceButton.frame;
    self.sourceButton.frame = CGRectMake(CGRectGetMinX(frame), buttonYCoord, CGRectGetWidth(frame), CGRectGetHeight(frame));
}

- (void)setupStrikeDateUIElements {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSCalendarUnit dayMonthYear = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;

    NSDateComponents *startDayComponents = [cal components:dayMonthYear fromDate:self.strike.startDate];
    NSDateComponents *endDayComponents   = [cal components:dayMonthYear fromDate:self.strike.endDate];

    NSDate *startDay = [cal dateFromComponents:startDayComponents];
    NSDate *endDay   = [cal dateFromComponents:endDayComponents];

    NSDateFormatter *df = [NSDateFormatter new];

    if ([startDay compare:endDay] == NSOrderedSame) {
        if (self.strike.allDay) {
            [df setTimeStyle:NSDateFormatterNoStyle];
            [df setDateStyle:NSDateFormatterMediumStyle];

            self.startLabel.hidden = YES;
            self.startDateLabel.text = [df stringFromDate:self.strike.startDate];
            self.endLabel.hidden = YES;
            self.endDateLabel.text = NSLocalizedString(@"All day-detail", @"'All day' to be used in the detailed strike view.");
        } else {
            [df setTimeStyle:NSDateFormatterShortStyle];
            [df setDateStyle:NSDateFormatterMediumStyle];

            self.endLabel.hidden = NO;
            self.startLabel.hidden = NO;

            self.startDateLabel.text = [df stringFromDate:self.strike.startDate];
            self.endDateLabel.text = [df stringFromDate:self.strike.endDate];
        }

        return;
    }

    // startDay != endDay
    if (self.strike.allDay) {
        [df setTimeStyle:NSDateFormatterNoStyle];
        [df setDateStyle:NSDateFormatterMediumStyle];

        self.endDateLabel.text = [df stringFromDate:self.strike.endDate];
        self.startDateLabel.text = [df stringFromDate:self.strike.startDate];

        return;
    } else {
        // Several days, but
        // !all_day (I don't think this usually happens.
        [df setTimeStyle:NSDateFormatterShortStyle];
        [df setDateStyle:NSDateFormatterMediumStyle];

        self.startDateLabel.text = [df stringFromDate:self.strike.startDate];
        self.endDateLabel.text   = [df stringFromDate:self.strike.endDate];
    }
}

@end
