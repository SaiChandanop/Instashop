//
//  DiscoverTableViewController.m
//  Instashop
//
//  Created by Josh Klobe on 6/7/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "DiscoverTableViewController.h"
#import "DiscoverViewController.h"
@interface DiscoverTableViewController ()

@end

@implementation DiscoverTableViewController

@synthesize parentController;
@synthesize contentArray;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setContentWithArray:(NSArray *)theArray
{
    self.contentArray = [[NSArray alloc] initWithArray:theArray];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentArray count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [self.contentArray objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.parentController tableOptionSelectedWithTableViewController:self withOption:[self.contentArray objectAtIndex:indexPath.row]];
}

@end
