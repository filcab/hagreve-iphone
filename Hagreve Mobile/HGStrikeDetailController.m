//
//  HGStrikeDetailController.m
//  Hagreve Mobile
//
//  Created by Filipe Cabecinhas on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HGStrikeDetailController.h"

static NSString *sections[] =
 { @"Datas", @"Empresa", @"Descrição", @"Hiperligação" };

@implementation HGStrikeDetailController

@synthesize strike;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sizeof(sections)/sizeof(*sections);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return sections[section];
}

@end
