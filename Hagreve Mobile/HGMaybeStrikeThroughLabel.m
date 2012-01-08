//
//  HGMaybeStrikeThroughLabel.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 2012/01/06.
//  Copyright (c) 2012 hagreve.com. All rights reserved.
//

#import "HGMaybeStrikeThroughLabel.h"

@implementation HGMaybeStrikeThroughLabel

@synthesize strikeThrough = _strikeThrough;

- (void)loadFromNib {
    self.strikeThrough = false;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:rect];

    CGSize textSize = [self.text sizeWithFont:self.font];
    CGFloat strikeWidth = textSize.width;

    if (self.strikeThrough) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextFillRect(context,CGRectMake(0,rect.size.height/2,strikeWidth,1));
    }
}

@end
