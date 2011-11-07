//
//  HGStrikeDetailController.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HGStrikeDetailController.h"

@implementation HGStrikeDetailController

- (void) awakeFromNib {
    sections = [NSArray arrayWithObjects:@"Datas", @"Empresa", @"Descrição",
                @"Hiperligação", nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sections objectAtIndex:section];
}

@end
