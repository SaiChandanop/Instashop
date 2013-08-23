//
//  ProfileViewController.m
//  Instashop
//
//  Created by Josh Klobe on 8/23/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "ImageAPIHandler.h"
#import "ImagesTableViewCell.h"
#import "ProductAPIHandler.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize profileInstagramID;

@synthesize backgroundImageView;
@synthesize profileImageView;
@synthesize usernameLabel;
@synthesize followersLabel;
@synthesize followingLabel;
@synthesize theTableView;
@synthesize feedItemsArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.feedItemsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", self.profileInstagramID], @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@/media/recent", self.profileInstagramID], @"method", @"-1", @"count", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    
    [ProductAPIHandler getProductsWithInstagramID:self.profileInstagramID withDelegate:self];
    
    
}


- (void)request:(IGRequest *)request didLoad:(id)result
{
    
    
    NSDictionary *metaDictionary = [result objectForKey:@"meta"];
    if ([[metaDictionary objectForKey:@"code"] intValue] == 200)
    {
        if ([request.url rangeOfString:@"media"].length > 0)
        {
            NSDictionary *dataDictionary = [[result objectForKey:@"data"] objectAtIndex:0];
            NSDictionary *imagesDictionary = [dataDictionary objectForKey:@"images"];
            NSDictionary *standardDictionary = [imagesDictionary objectForKey:@"standard_resolution"];
            [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[standardDictionary objectForKey:@"url"] withImageView:self.backgroundImageView];
        }        
        else if ([request.url rangeOfString:@"users"].length > 0)
        {
            NSDictionary *dataDictionary = [result objectForKey:@"data"];
            self.usernameLabel.text = [dataDictionary objectForKey:@"username"];
            [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[dataDictionary objectForKey:@"profile_picture"] withImageView:self.profileImageView];
            
            NSDictionary *countsDictionary = [dataDictionary objectForKey:@"counts"];
            self.followersLabel.text = [NSString stringWithFormat:@"%d", [[countsDictionary objectForKey:@"followed_by"] integerValue]];
            self.followingLabel.text = [NSString stringWithFormat:@"%d", [[countsDictionary objectForKey:@"follows"] integerValue]];
        }
        
    }
}



-(void)feedRequestFinishedWithArrray:(NSArray *)theArray
{
//    NSLog(@"feedRequestFinishedWithArrray: %@", feedRequestFinishedWithArrray);
    [self.feedItemsArray removeAllObjects];
    
    NSArray *sorted = [theArray sortedArrayUsingFunction:dateSort2 context:nil];
    [self.feedItemsArray addObjectsFromArray:sorted];
    [self.theTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  104;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [tableView setSeparatorColor:[UIColor clearColor]];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([self.feedItemsArray count] / 3 % 3 == 0)
        return ([self.feedItemsArray count] / 3);
    else
        return ([self.feedItemsArray count] / 3) + 1;
}

- (ImagesTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ImagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[ImagesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withCellHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath]] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.delegate = self;
    [cell loadWithIndexPath:indexPath withFeedItemsArray:self.feedItemsArray];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

NSComparisonResult dateSort2(NSDictionary *s1, NSDictionary *s2, void *context) {
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *string1 = [s1 objectForKey:@"products_date_added"];
    NSDate *date1 = [dateFormatter dateFromString:string1];
    
    NSString *string2 = [s2 objectForKey:@"products_date_added"];
    NSDate *date2 = [dateFormatter dateFromString:string2];
    
    int ret = [date2 compare:date1];
    
    [dateFormatter release];
    
    return ret;
    
}




- (void)viewDidLoad
{
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
