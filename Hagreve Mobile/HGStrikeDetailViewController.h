//
//  HGStrikeDetailViewController.h
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 2012/01/09.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HGStrike.h"

#import <UIKit/UIKit.h>

@interface HGStrikeDetailViewController : UIViewController <UIActionSheetDelegate>

@property (nonatomic, retain) HGStrike *strike;

@property (nonatomic, retain) IBOutlet UIImageView *canceledImageView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) IBOutlet UILabel *startDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *startLabel;
@property (nonatomic, retain) IBOutlet UILabel *endDateLabel;
@property (nonatomic, retain) IBOutlet UILabel *endLabel;
@property (nonatomic, retain) IBOutlet UILabel *companyLabel;
@property (nonatomic, retain) IBOutlet UILabel *commentLabel;

@property (nonatomic, retain) IBOutlet UILabel *datesTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *companyTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *commentTitleLabel;

#pragma mark - Date formatters
- (NSString*)labelForDate:(NSDate*)date allDay:(BOOL)all_day;

#define kCommentMinHeight 21

#pragma mark - Misc methods
- (void)layoutUIElements;
- (void)setupStrikeDateUIElements;

@end
