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
        
        [NotificationsAPIHandler getAllNotificationsWithInstagramID:[InstagramUserObject getStoredUserObject].userID withDelegate:self];
        self.contentArray = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    
    UIView *cancelCustomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 44, 44)];
    
    UIImageView *cancelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"closebutton_white.png"]];
    cancelImageView.frame = CGRectMake(0,0,44,44);
    [cancelCustomView addSubview:cancelImageView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0,0,cancelCustomView.frame.size.width, cancelCustomView.frame.size.height);
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(backButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [cancelCustomView addSubview:cancelButton];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelCustomView];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"NOTIFICATIONS"]];

    [self.theTableView reloadData];
    
    self.theTableView.backgroundColor = [UIColor clearColor];
    
    // Do any additional setup after loading the view from its nib.
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NotificationsObject *notificationsObject = [self.contentArray objectAtIndex:indexPath.row];
//    cell.textLabel.text = notificationObjects.message;
    [cell loadWithNotificationsObject:notificationsObject];
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  80;
}

-(void)backButtonHit
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.appRootViewController popupViewControllerShouldExit:self.navigationController];
    
}



@end
