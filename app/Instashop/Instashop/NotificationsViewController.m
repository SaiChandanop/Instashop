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
#import "HomeViewController.h"
@interface NotificationsViewController ()

@end

@implementation NotificationsViewController

@synthesize theTableView;
@synthesize contentArray;
@synthesize referenceCache;
@synthesize requestedCacheIDs;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self loadNotifications];
        self.contentArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.referenceCache = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.requestedCacheIDs = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
    return self;
}


-(void)loadNotifications
{
    [NotificationsAPIHandler getAllNotificationsWithInstagramID:[InstagramUserObject getStoredUserObject].userID withDelegate:self];
    
    NSLog(@"notifications view controller load notifications");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Utils conformViewControllerToMaxSize:self];
    
    
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"NOTIFICATIONS"]];

    [self.theTableView reloadData];
    
    self.theTableView.backgroundColor = [UIColor clearColor];
    
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
    
}


-(NSDictionary *)getDictionaryFromCacheWithID:(NSString *)theID
{
    return [self.referenceCache objectForKey:theID];
}



-(void)setDictionaryIntoCacheWithID:(NSString *)theID withDictionary:(NSDictionary *)theDictionary
{
    NSLog(@"setDictionaryIntoCacheWithID: %@", theID);
    [self.referenceCache setObject:theDictionary forKey:theID];
}



-(void)notificationsDidFinishWithArray:(NSArray *)theNotificationsArray
{
    NSLog(@"notificationsDidFinishWithArray: %@", theNotificationsArray);
    
    [self.contentArray removeAllObjects];
    [self.contentArray addObjectsFromArray:theNotificationsArray];
    
    [self.theTableView reloadData];
    
    for (int i = 0; i < [theNotificationsArray count]; i++)
    {
        NotificationsObject *notificationsObject = [theNotificationsArray objectAtIndex:i];
        
        NSString *creatorID = [notificationsObject.dataDictionary objectForKey:@"creator_id"];

        BOOL proceed = NO;
        
        if ([self getDictionaryFromCacheWithID:creatorID] == nil)
            proceed = YES;
        
        if ([self getDictionaryFromCacheWithID:creatorID] == nil && ![self.requestedCacheIDs containsObject:creatorID])
        {
            NSLog(@"proceedWith: %@", creatorID);
            NSLog(@"self.referenceCache: %@", self.referenceCache);
/*            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", creatorID], @"method", nil];
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate.instagram requestWithParams:params delegate:self];
            [self.requestedCacheIDs addObject:creatorID];            
  */      }
        
    }
}


- (void)request:(IGRequest *)request didLoad:(id)result
{
    
    if (result != nil)
    {
        NSDictionary *dataDictionary = [result objectForKey:@"data"];
        //      NSLog(@"dataDictionary: %@", dataDictionary);
        NSLog(@"[dataDictionary objectForKey:@\"id\"]: %@", [dataDictionary objectForKey:@"id"]);
        
        if ([dataDictionary objectForKey:@"id"] != nil)
            [self setDictionaryIntoCacheWithID:[dataDictionary objectForKey:@"id"] withDictionary:[NSDictionary dictionaryWithDictionary:dataDictionary]];
        
        
    }
    
    
    
}



-(void)notificationClearDidFinish
{
    NSLog(@"notificationClearDidFinish");
    [[AppRootViewController sharedRootViewController].homeViewController makeGetNotificationsCountCall];
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
        cell = [[NotificationsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.parentController = self;
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
    NSLog(@"backButtonHit");
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.appRootViewController popupViewControllerShouldExit:self.navigationController];
    
}



@end
