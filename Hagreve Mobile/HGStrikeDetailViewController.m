//
//  HGStrikeDetailController.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HGUtils.h"
#import "HGStrikeDetailViewController.h"

#define DATES_SECT 0
#define COMPANY_SECT 1
#define DESCRIPTION_SECT 2
#define LINK_SECT 3
static NSString *sections[] =
 { @"Datas", @"Empresa", @"Descrição", @"Fonte" };

@implementation HGStrikeDetailViewController

@synthesize strike;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sizeof(sections)/sizeof(*sections);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case DATES_SECT:
            return 2;

        case COMPANY_SECT:
        case DESCRIPTION_SECT:
        case LINK_SECT:
            return 1;

        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return sections[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"StrikeDetailCell";
    static NSString *DateCellIdentifier = @"StrikeDetailDateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];

    switch (indexPath.section) {
        case DATES_SECT: {
            // Special-case this one.
            cell = [tableView dequeueReusableCellWithIdentifier:DateCellIdentifier];
            if (cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DateCellIdentifier];

            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            if (strike.all_day)
                [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
            else
                [dateFormatter setTimeStyle:NSDateFormatterShortStyle];

            DLog(@"going for additional cell labels: %@", cell);
            if (indexPath.row == 0) {
                cell.textLabel.text = [dateFormatter stringFromDate:strike.startDate];
                cell.detailTextLabel.text = @"Início";
            } else {
                cell.textLabel.text = [dateFormatter stringFromDate:strike.endDate];
                cell.detailTextLabel.text = @"Fim";
            }

            if (strike.canceled) {

            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case COMPANY_SECT:
            if (cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];

            cell.textLabel.text = strike.company.name;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;

        case DESCRIPTION_SECT: {
            if (cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];


            [self tableView:tableView heightForRowAtIndexPath:indexPath];

            cell.textLabel.text = strike.comment;
            cell.textLabel.numberOfLines = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        case LINK_SECT: {
            if (cell == nil)
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];

            // Do we want to hide most of the URL?
            NSString *linkStr = [NSString stringWithFormat:@"%@://%@/…", strike.sourceLink.scheme, strike.sourceLink.host];
            cell.textLabel.text = linkStr;
            break;
        }
        default:
            cell.textLabel.text = @"Error";
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case DATES_SECT:
            return DATE_CELL_HEIGHT;
            
        case COMPANY_SECT:
        case LINK_SECT:
            return CELL_HEIGHT;

        case DESCRIPTION_SECT: {
            CGSize textSize = {0, 0};
            NSString *text = strike.comment;
            if (text && ![text isEqualToString:@""]) 
                textSize = [text sizeWithFont:[self regularFont]
                            constrainedToSize:CGSizeMake(CELL_WIDTH, 42000)
                                lineBreakMode:UILineBreakModeWordWrap];
            return CELL_HEIGHT < textSize.height ? textSize.height + CELL_BORDERS : CELL_HEIGHT;
        }
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (LINK_SECT == indexPath.section && 0 == indexPath.row) {
        /*
         To conform to the Human Interface Guidelines, selections should not be persistent --
         deselect the row after it has been selected.
         */
        NSLog(@"Opening URL: %@", strike.sourceLink);
        [self openOrCopyURL:strike.sourceLink];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UIActionSheet creator and delegate

#define SHEET_COPY_IDX 0
#define SHEET_OPEN_IDX 1
#define SHEET_CANCEL_IDX 2

- (void)openOrCopyURL:(NSURL *)url {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancelar" destructiveButtonTitle:nil otherButtonTitles:@"Copiar", @"Abrir", nil];
    sheet.actionSheetStyle = UIActionSheetStyleAutomatic;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case SHEET_COPY_IDX: {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setURL:strike.sourceLink];
            break;
        }
        case SHEET_OPEN_IDX:
            [[UIApplication sharedApplication] openURL:strike.sourceLink];
            break;
        case SHEET_CANCEL_IDX:
            // No-op
            break;
    }
}

#pragma mark - Font stuff

- (UIFont *)regularFont {
    static UIFont *font;
    if (nil == font)
        font = [UIFont boldSystemFontOfSize:REGULAR_FONT_SIZE];
    return font;
}

- (UIFont *)titleFont {
    static UIFont *font;
    if (nil == font)
        font = [UIFont boldSystemFontOfSize:TITLE_FONT_SIZE];
    return font;
}

- (UIFont *)subtitleFont {
    static UIFont *font;
    if (nil == font)
        font = [UIFont boldSystemFontOfSize:SUBTITLE_FONT_SIZE];
    return font;
}


#undef DATES_SECT
#undef COMPANY_SECT
#undef DESCRIPTION_SECT
#undef LINK_SECT

@end
