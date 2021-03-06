//
//  NotificationsTableViewController.m
//  Instashop
//  Presentation container for Home -> Notifications
//  Created by Josh Klobe on 4/16/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import "NotificationsTableViewController.h"
#import "ISConstants.h"
#import "NavBarTitleView.h"
#import "NotificationsAPIHandler.h"
#import "InstagramUserObject.h"
#import "NotificationsTableViewCell.h"
#import "NotificationsObject.h"
#import "AppDelegate.h"
#import "AppRootViewController.h"
#import "HomeViewController.h"

@interface NotificationsTableViewController ()

@end

@implementation NotificationsTableViewController

@synthesize theTableView;
@synthesize contentArray;
@synthesize referenceCache;
@synthesize requestedCacheIDs;
@synthesize cacheQueue;
@synthesize cacheQueueBegun;
@synthesize tableCellsArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self loadNotifications];
        self.contentArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.referenceCache = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.requestedCacheIDs = [[NSMutableArray alloc] initWithCapacity:0];
        self.cacheQueue = [[NSMutableArray alloc] initWithCapacity:0];
        self.tableCellsArray = [[NSMutableArray alloc] initWithCapacity:0];
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
    
    UIImageView *theBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    theBackgroundImageView.backgroundColor = [UIColor redColor];
    theBackgroundImageView.image = [UIImage imageNamed:@"Menu_BG.png"];
    [self.view insertSubview:theBackgroundImageView atIndex:0];

    
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
    

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadNotifications)
             forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
}

-(void)refreshContent
{
    NSLog(@"refreshContent refreshContent");
}

-(NSDictionary *)getDictionaryFromCacheWithID:(NSString *)theID
{
    return [self.referenceCache objectForKey:theID];
}



-(void)setDictionaryIntoCacheWithID:(NSString *)theID withDictionary:(NSDictionary *)theDictionary
{
    [self.referenceCache setObject:theDictionary forKey:theID];
    
    
    for (int i = 0; i < [self.tableCellsArray count]; i++)
    {
        NotificationsTableViewCell *theCell = [self.tableCellsArray objectAtIndex:i];
        if ([[theCell.notificationsObject.dataDictionary objectForKey:@"creator_id"] integerValue] == [theID integerValue])
            [theCell loadContentWithDataDictionary:theDictionary];
    }
    
}



-(void)notificationsDidFinishWithArray:(NSArray *)theNotificationsArray
{
    NSLog(@"notificationsDidFinishWithArray!");
    [self.refreshControl endRefreshing];
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
            [self.requestedCacheIDs addObject:creatorID];
            [self.cacheQueue addObject:creatorID];
            
        }
        
    }
    
    if (!self.cacheQueueBegun)
    {
        self.cacheQueueBegun = YES;
        [self processCacheQueue];
    }
}

-(void)processCacheQueue
{
    if ([self.cacheQueue count] > 0)
    {
        
        NSString *creatorID = [self.cacheQueue objectAtIndex:0];
        [self.cacheQueue removeObjectAtIndex:0];
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", creatorID], @"method", nil];
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate.instagram requestWithParams:params delegate:self];
        
    }
    else
        self.cacheQueueBegun = NO;
}

- (void)request:(IGRequest *)request didLoad:(id)result
{
    
    if (result != nil)
    {
        NSDictionary *dataDictionary = [result objectForKey:@"data"];
        if ([dataDictionary objectForKey:@"id"] != nil)
            [self setDictionaryIntoCacheWithID:[dataDictionary objectForKey:@"id"] withDictionary:[NSDictionary dictionaryWithDictionary:dataDictionary]];
        
        
    }
    
    [self processCacheQueue];
    
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error
{
    
    NSArray *urlComponentsArray = [request.url componentsSeparatedByString:@"/"];
    NSString *requestedID = [urlComponentsArray objectAtIndex:[urlComponentsArray count] - 1];
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:@"1" forKey:@"private"];
    [dict setObject:requestedID forKey:@"id"];
    [self setDictionaryIntoCacheWithID:requestedID withDictionary:dict];
    
    [self processCacheQueue];
    
}


-(void)notificationClearDidFinish
{
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
    
    if (![self.tableCellsArray containsObject:cell])
        [self.tableCellsArray addObject:cell];
    
    [cell clearSubviews];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NotificationsObject *notificationsObject = [self.contentArray objectAtIndex:indexPath.row];
    [cell loadWithNotificationsObject:notificationsObject];
    
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  74;
}

-(void)backButtonHit
{
    NSLog(@"backButtonHit");
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.appRootViewController popupViewControllerShouldExit:self.navigationController];
    
}



@end
