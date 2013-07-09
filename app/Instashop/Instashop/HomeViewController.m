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

-(void)doneButtonHitWithAddressVC:(PurchasingAddressViewController *)theVC
{
    NSMutableDictionary *addressDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [addressDictionary setObject:theVC.nameTextField.text forKey:@"seller_name"];
    
    [addressDictionary setObject:theVC.addressTextField.text forKey:@"seller_address"];
    [addressDictionary setObject:theVC.cityTextField.text forKey:@"seller_city"];
    [addressDictionary setObject:theVC.stateTextField.text forKey:@"seller_state"];
    [addressDictionary setObject:theVC.zipTextField.text forKey:@"seller_zip"];
    [addressDictionary setObject:theVC.phoneTextField.text forKey:@"seller_phone"];
    
    NSLog(@"addressDictionay: %@", addressDictionary);
    [SellersAPIHandler makeCreateSellerRequestWithDelegate:self withInstagramUserObject:[InstagramUserObject getStoredUserObject] withSellerAddressDictionary:addressDictionary];
    
}

-(IBAction) sellerButtonHit
{
    if ([InstagramUserObject getStoredUserObject].zencartID == nil)
    {
        PurchasingAddressViewController *purchasingAddressViewController = [[PurchasingAddressViewController alloc] initWithNibName:@"PurchasingAddressViewController" bundle:nil];
        purchasingAddressViewController.checkRatesButton.alpha = 0;
        purchasingAddressViewController.doneButtonDelegate = self;
        [self.parentController presentViewController:purchasingAddressViewController animated:YES completion:nil];
        
        
        
    }
    else
        [self.parentController createProductButtonHit];
}

-(void)userDidCreateSellerWithResponseDictionary:(NSDictionary *)dictionary
{
    NSLog(@"userDidCreateSellerWithResponseDictionary!!: %@", dictionary);
    
    InstagramUserObject *theUserObject =[InstagramUserObject getStoredUserObject];
    theUserObject.zencartID = [dictionary objectForKey:@"zencart_id"];
    
    [[InstagramUserObject getStoredUserObject] setAsStoredUser:theUserObject];

    
    [self loadStates];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Great"
                                                        message:@"And now you're a seller"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    
    [alertView show];
    
    [self.parentController dismissViewControllerAnimated:YES completion:nil];

    

    
}


@end
