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
    
    for (int i = 0; i < [self.tableCellsArray count]; i++)
    {
        NotificationsTableViewCell *theCell = [self.tableCellsArray objectAtIndex:i];
        if ([[theCell.notificationsObject.dataDictionary objectForKey:@"creator_id"] compare:theID] == NSOrderedSame)
        {
            NSLog(@"loading into visible cell");
            [theCell loadContentWithDataDictionary:theDictionary];
        }
    }

}



-(void)notificationsDidFinishWithArray:(NSArray *)theNotificationsArray
{
    NSLog(@"notificationsDidFinishWithArray did complete");
    
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
        NSLog(@"processCacheQueue: %@", creatorID);
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
        //      NSLog(@"dataDictionary: %@", dataDictionary);
        NSLog(@"[dataDictionary objectForKey:@\"id\"]: %@", [dataDictionary objectForKey:@"id"]);
        
        if ([dataDictionary objectForKey:@"id"] != nil)
            [self setDictionaryIntoCacheWithID:[dataDictionary objectForKey:@"id"] withDictionary:[NSDictionary dictionaryWithDictionary:dataDictionary]];
        
        
    }
    
    [self processCacheQueue];
    
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"request did fail with error: %@, request.url: %@", error, request.url);
    
    NSArray *urlComponentsArray = [request.url componentsSeparatedByString:@"/"];
    NSString *requestedID = [urlComponentsArray objectAtIndex:[urlComponentsArray count] - 1];
    NSLog(@"requestedID: %@", requestedID);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:@"1" forKey:@"private"];
    [dict setObject:requestedID forKey:@"id"];
    [self setDictionaryIntoCacheWithID:requestedID withDictionary:dict];
    
    [self processCacheQueue];
    
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
        [self.tableCellsArray addObject:cell];
    }
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
