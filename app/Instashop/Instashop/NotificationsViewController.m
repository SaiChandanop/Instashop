//
//  NotificationsViewController.m
//  Instashop
//
//  Created by Josh Klobe on 9/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "NotificationsViewController.h"
#import "ISConstants.h"
#import "NavBarTitleView.h"
#import "NotificationsAPIHandler.h"
#import "InstagramUserObject.h"
#import "NotificationsTableViewCell.h"
#import "NotificationsObject.h"

#import "AppDelegate.h"
#import "AppRootViewController.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController

@synthesize theTableView;
@synthesize contentArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self loadNotifications];
        self.contentArray = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
    return self;
}


-(void)loadNotifications
{
    [NotificationsAPIHandler getAllNotificationsWithInstagramID:[InstagramUserObject getStoredUserObject].userID withDelegate:self];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"NOTIFICATIONS"]];

    [self.theTableView reloadData];
    
    self.theTableView.backgroundColor = [UIColor clearColor];
    
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];
    
}

-(void)notificationsDidFinishWithArray:(NSArray *)theNotificationsArray
{
    [self.contentArray removeAllObjects];
    [self.contentArray addObjectsFromArray:theNotificationsArray];
    
    [self.theTableView reloadData];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    [tableView setSeparatorColor:[UIColor clearColor]];
    
    self.theTableView.backgroundColor = [UIColor clearColor];
    
    [self.theTableView registerNib:[UINib nibWithNibName:@"NotificationsTableViewCell"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"NotificationsTableViewCell"];
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NotificationsTableViewCell";
    
    NotificationsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    if (cell == nil) {
        cell = [[[NotificationsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell clearSubviews];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NotificationsObject *notificationsObject = [self.contentArray objectAtIndex:indexPath.row];
    [cell loadWithNotificationsObject:notificationsObject];
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  82;
}

-(void)backButtonHit
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.appRootViewController popupViewControllerShouldExit:self.navigationController];
    
}



@end
