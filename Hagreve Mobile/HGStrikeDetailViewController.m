//
//  HGStrikeDetailViewController.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 2012/01/09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HGStrikeDetailViewController.h"
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
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Copiar", @"Abrir", nil];
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
    self.startDateLabel.text = [self labelForDate:self.strike.startDate allDay:self.strike.all_day];
    self.endDateLabel.text   = [self labelForDate:self.strike.endDate allDay:self.strike.all_day];
    self.companyLabel.text   = self.strike.company.name;

    if (self.strike.canceled){
        self.canceledImageView.hidden = NO;
    } else {
        self.canceledImageView.hidden = YES;
    }

    CGRect frame = self.commentLabel.frame;
    CGSize textSize = {0, 0};
    NSString *text = self.strike.comment;
    if (text && ![text isEqualToString:@""])
        textSize = [text sizeWithFont:self.commentLabel.font
                    constrainedToSize:CGSizeMake(self.commentLabel.frame.size.width, CGFLOAT_MAX)
                    lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = fmaxf(textSize.height, kCommentMinHeight);

    self.commentLabel.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame), height);
    self.commentLabel.text  = self.strike.comment;

    // Let's fix the UIScrollView's contentSize. Start by filling the whole UIScrollView
    CGSize scrollSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(scrollSize.width, height <= 103 ? scrollSize.height : scrollSize.height + height - 103 + kCommentFooter);

    // Put the other buttons in place. Autoresize isn't cutting it…
    frame = self.tweetButton.frame;
    self.tweetButton.frame = CGRectMake(CGRectGetMinX(frame), self.scrollView.contentSize.height - 120, CGRectGetWidth(frame), CGRectGetHeight(frame));
    frame = self.sourceButton.frame;
    self.sourceButton.frame = CGRectMake(CGRectGetMinX(frame), self.scrollView.contentSize.height - 120, CGRectGetWidth(frame), CGRectGetHeight(frame));
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

@end
