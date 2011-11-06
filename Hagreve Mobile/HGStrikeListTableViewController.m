//
//  HGViewController.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 10/20/11.
//  Copyright (c) 2011 HáGreve. All rights reserved.
//

#import "HGStrikeListTableViewController.h"

@implementation HGStrikeListTableViewController

@synthesize strikeDays = _strikeDays;
@synthesize protoCell = _protoCell;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - TableView delegate



#pragma mark - TableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.strikeDays.strikes.count;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.strikeDays.daysWithStrikes.count];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
//    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
//
//    // The arrays will have the same order.
//    for (NSDateComponents *d in self.strikeDays.daysWithStrikes) {
//        NSString *title = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateFromComponents:d]];
//        [titles addObject:title];
//    }
//
//    return [titles copy];
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"StrikeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        NSLog(@"dequeueReusableCellWithIdentifier:@\"%@\" == nil", MyIdentifier);
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[NSBundle mainBundle] loadNibNamed:@"StrikeCell" owner:self options:nil];
        cell = _protoCell;
        self.protoCell = nil;
    }

    NSArray *strikesForDay = [self.strikeDays strikesForStrikeDay:indexPath.section];
    HGStrike *strike = [strikesForDay objectAtIndex:indexPath.row];

    UILabel *label = (UILabel *)[cell viewWithTag:TAG_TITLE];
    label.text = [HGUtils cellTitleTextForStrike:strike];

    label = (UILabel *)[cell viewWithTag:TAG_SUBTITLE];
    label.text = [HGUtils cellSubtitleTextForStrike:strike];

    label = (UILabel *)[cell viewWithTag:TAG_COMMENT];
    label.text = [HGUtils cellCommentTextForStrike:strike];

//    cell.textLabel.text = strike.company.name;
//    cell.detailTextLabel.text = strike.comment;
    return cell;
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

#pragma mark - View lifecycle

- (void)viewDidLoad {
    // Initialize stuff.
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
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
