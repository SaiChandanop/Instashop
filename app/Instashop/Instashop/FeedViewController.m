//
//  FeedViewController.m
//  Instashop
//
//  Created by Josh Klobe on 5/31/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "FeedViewController.h"
#import "AppRootViewController.h"
#import "ImagesTableViewCell.h"
#import "ProductAPIHandler.h"
#import "ImageAPIHandler.h"
#import "PurchasingViewController.h"


@interface FeedViewController ()

@end

@implementation FeedViewController

@synthesize parentController;
@synthesize headerView, theTableView;

@synthesize feedItemsArray, selectedObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.feedItemsArray = [[NSMutableArray alloc] initWithCapacity:0];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ProductAPIHandler getAllProductsWithDelegate:self];
    // Do any additional setup after loading the view from its nib.
}

-(void)feedRequestFinishedWithArrray:(NSArray *)theArray
{
    NSLog(@"feedRequestFinishedWithArrray: %@", theArray);
    
    [self.feedItemsArray removeAllObjects];
    [self.feedItemsArray addObjectsFromArray:theArray];
    
    [self.theTableView reloadData];
    
}

-(IBAction)homeButtonHit
{
        NSLog(@"homeButtonHit");
    [self.parentController homeButtonHit];

}

-(IBAction)notificationsButtonHit
{
    NSLog(@"notificationsButtonHit");
    [self.parentController notificationsButtonHit];
}

-(IBAction)discoverButtonHit
{
      NSLog(@"discoverButtonHit");
    [self.parentController discoverButtonHit];    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.feedItemsArray count];
}

- (ImagesTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ImagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[ImagesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withCellHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath]] autorelease];
    }
    
    cell.theImageView.image = nil;
    
    NSDictionary *productObjectDictionary = [self.feedItemsArray objectAtIndex:indexPath.row];

    NSString *productURL = [productObjectDictionary objectForKey:@"products_url"];
    
    if (productURL != nil)    
        [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:productURL withImageView:cell.theImageView];

    cell.titleLabel.text = [productObjectDictionary objectForKey:@"products_name"];
    

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  306;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedObject = [self.feedItemsArray objectAtIndex:indexPath.row];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Buy?"
                                                        message:@"Wanna buy?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes", nil];
    [alertView show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == YES)
    {
        
        PurchasingViewController *purchasingViewController = [[PurchasingViewController alloc] initWithNibName:@"PurchasingViewController" bundle:nil];
        purchasingViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.view addSubview:purchasingViewController.view];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.456];
//        [UIView setAnimationDelegate:self];
//        [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
        purchasingViewController.view.frame = CGRectMake(0,0,purchasingViewController.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];

        
        NSLog(@"do buy: %@", self.selectedObject);
    }

}


@end
