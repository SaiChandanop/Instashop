//
//  ObjectSelectTableViewController.m
//  Instashop
//
//  Created by Josh Klobe on 9/12/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ObjectSelectTableViewController.h"

@interface ObjectSelectTableViewController ()

@end

@implementation ObjectSelectTableViewController

@synthesize parentController;
@synthesize cellDelegate;
@synthesize contentArray;
@synthesize contentRequestParameters;
@synthesize referenceTableView;
@synthesize productRequestorType;
@synthesize productRequestorReferenceObject;
@synthesize searchRequestObject;



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshContent)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;

}


- (void)request:(IGRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"%@ request did fail with error: %@", self, error);
}








- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = @"wrong";
    // Configure the cell...
    
    return cell;
}




@end
