//
//  HomeViewController.m
//  Instashop
//
//  Created by Josh Klobe on 6/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "HomeViewController.h"
#import "AppRootViewController.h"
#import "UserAPIHandler.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize parentController;


@synthesize theTableView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Discover!";
            break;

        case 1:
            NSLog(@"[InstagramUserObject getStoredUserObject]: %@", [InstagramUserObject getStoredUserObject]);
            if ([InstagramUserObject getStoredUserObject].zencartID == nil)
                cell.textLabel.text = @"become a seller";
            else
                cell.textLabel.text = @"you are a seller";
            
            break;
            
        case 2:
            cell.textLabel.text = @"Post a new item!";
            break;

        default:
            break;
    }
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  36;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    switch (indexPath.row) {
        case 0:

            
            break;
            
        case 1:
            if ([InstagramUserObject getStoredUserObject].zencartID == nil)
                [UserAPIHandler makeUserCreateSellerRequestWithDelegate:self withInstagramUserObject:[InstagramUserObject getStoredUserObject]];
            break;
        case 2:
            if ([InstagramUserObject getStoredUserObject].zencartID == nil)
            {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                    message:@"Please become a seller first"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
            }
            else
                [self.parentController createProductButtonHit];
  //          cell.textLabel.text = @"Post a new item!";
            break;
            
        default:
            break;
    }
    
}

-(void)userDidCreateSellerWithResponseDictionary:(NSDictionary *)dictionary
{
    NSLog(@"userDidCreateSellerWithResponseDictionary!!: %@", dictionary);
    

    InstagramUserObject *theUserObject =[InstagramUserObject getStoredUserObject];
    theUserObject.zencartID = [dictionary objectForKey:@"zencart_id"];

    
    [[InstagramUserObject getStoredUserObject] setAsStoredUser:theUserObject];
    [self.theTableView reloadData];
}


@end
