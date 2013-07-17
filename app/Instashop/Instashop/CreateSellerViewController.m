//
//  CreateSellerViewController.m
//  Instashop
//
//  Created by Josh Klobe on 7/17/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CreateSellerViewController.h"
#import "SellersAPIHandler.h"
#import "HomeViewController.h"
@interface CreateSellerViewController ()

@end

@implementation CreateSellerViewController

@synthesize delegate;

@synthesize nameTextField;
@synthesize addressTextField;
@synthesize cityTextField;
@synthesize stateTextField;
@synthesize zipTextField;
@synthesize phoneTextField;

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
    // Do any additional setup after loading the view from its nib.
}


-(IBAction)doneButtonHit
{
    NSMutableDictionary *addressDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [addressDictionary setObject:self.nameTextField.text forKey:@"seller_name"];
    [addressDictionary setObject:self.addressTextField.text forKey:@"seller_address"];
    [addressDictionary setObject:self.cityTextField.text forKey:@"seller_city"];
    [addressDictionary setObject:self.stateTextField.text forKey:@"seller_state"];
    [addressDictionary setObject:self.zipTextField.text forKey:@"seller_zip"];
    [addressDictionary setObject:self.phoneTextField.text forKey:@"seller_phone"];
    
    NSLog(@"addressDictionay: %@", addressDictionary);
    [SellersAPIHandler makeCreateSellerRequestWithDelegate:self withInstagramUserObject:[InstagramUserObject getStoredUserObject] withSellerAddressDictionary:addressDictionary];

    
}


-(IBAction)cancelButtonHit
{
    [self.delegate createSellerCancelButtonHit];
}



-(void)userDidCreateSellerWithResponseDictionary:(NSDictionary *)dictionary
{
    NSLog(@"userDidCreateSellerWithResponseDictionary!!: %@", dictionary);
    
    InstagramUserObject *theUserObject =[InstagramUserObject getStoredUserObject];
    theUserObject.zencartID = [dictionary objectForKey:@"zencart_id"];
    
    [[InstagramUserObject getStoredUserObject] setAsStoredUser:theUserObject];
    
    [self.delegate createSellerDone];
}
    
@end
