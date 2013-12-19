//
//  CommentsTableViewController.m
//  Instashop
//
//  Created by Josh Klobe on 10/29/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CommentsTableViewController.h"
#import "CommentsTableViewCell.h"
@interface CommentsTableViewController ()

@end

@implementation CommentsTableViewController

@synthesize commentsDataArray;
@synthesize parentController;

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
    
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    [self.tableView registerNib:[UINib nibWithNibName:@"CommentsTableViewCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"CommentsTableViewCell"];
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    NSLog(@"numberOfRowsInSection, count: %d", [self.commentsDataArray count]);
    return [self.commentsDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CommentsTableViewCell";
    CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[[CommentsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] autorelease];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.parentController = self;
        
    }
    
    cell.parentController = self;
    if (indexPath.row % 2 == 0)
        cell.backgroundColor = [UIColor colorWithRed:196.0f/255.0f green:189.0f/255.0f blue:196.0f/255.0f alpha:1];
    else
        cell.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:210.0f/255.0f blue:211.0f/255.0f alpha:1];
    
    if (indexPath.row < [self.commentsDataArray count])
        [cell loadWithCommentObject:[self.commentsDataArray objectAtIndex:indexPath.row] withIndexPath:indexPath];

    
    
    return cell;
}


@end
