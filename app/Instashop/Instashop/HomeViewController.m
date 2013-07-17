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
#import "PurchasingAddressViewController.h"
#import "SellersAPIHandler.h"
#import "CreateSellerViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize parentController;
@synthesize theScrollView;

@synthesize sellerLabel;
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

    
    self.theScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.theScrollView];
        
    self.theScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 568);
    
    
    [self loadStates];
}


-(void)loadStates
{
 
    if ([InstagramUserObject getStoredUserObject].zencartID == nil)
        self.sellerLabel.text = @"Become a seller";
    else
        self.sellerLabel.text = @"Sell a product";
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  36;
}



-(IBAction) sellerButtonHit
{
    if ([InstagramUserObject getStoredUserObject].zencartID == nil)
    {
        CreateSellerViewController *createSellerViewController = [[CreateSellerViewController alloc] initWithNibName:@"CreateSellerViewController" bundle:nil];
        createSellerViewController.delegate = self;
        [self.parentController presentViewController:createSellerViewController animated:YES completion:nil];
        
    }
    else
        [self.parentController createProductButtonHit];
}


-(void)createSellerDone
{
    [self loadStates];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Great"
                                                        message:@"And now you're a seller"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    
    [alertView show];
    
    [self.parentController dismissViewControllerAnimated:YES completion:nil];
}


-(void)createSellerCancelButtonHit
{
    [self.parentController dismissViewControllerAnimated:YES completion:nil];
}




@end
