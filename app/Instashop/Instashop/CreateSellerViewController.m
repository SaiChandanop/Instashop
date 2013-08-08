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


@synthesize containerScrollView;

@synthesize nameTextField;
@synthesize addressTextField;
@synthesize cityTextField;
@synthesize stateTextField;
@synthesize zipTextField;
@synthesize phoneTextField;
@synthesize emailTextField;
@synthesize categoryTextField;
@synthesize websiteTextField;
@synthesize instagramUsernameLabel;
@synthesize submitButton;


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
    
    self.containerScrollView.contentSize = CGSizeMake(0, self.containerScrollView.frame.size.height);
    
    self.instagramUsernameLabel.text = [InstagramUserObject getStoredUserObject].username;
    
/*    self.nameTextField.text = @"Josh Klobe";

    self.addressTextField.text = @"50 Bridge St Apt 318";
    self.cityTextField.text = @"Brooklyn";
    self.stateTextField.text = @"NY";
    self.zipTextField.text = @"11201";
    self.phoneTextField.text = @"9178374622";
    self.emailTextField.text = @"klobej@gmail.com  ";
    self.websiteTextField.text = @"alchemy50.com";
    self.categoryTextField.text = @"testcat";
  */
    
    [self.submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
}

-(IBAction)categoryButtonHit
{
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{    
    BOOL proceed = NO;
    if ([self.nameTextField.text length] > 0)
        if ([self.addressTextField.text length] > 0)
            if ([self.cityTextField.text length] > 0)
                    if ([self.stateTextField.text length] > 0)
                        if ([self.zipTextField.text length] > 0)
                            if ([self.emailTextField.text length] > 0)
                                if ([self.websiteTextField.text length] > 0)
                                    if ([self.categoryTextField.text length] > 0) 
                                            proceed = YES;
                                         
    
    if (proceed)
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    else
        [self.submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    
    
        
}
//-(void)

-(IBAction)doneButtonHit
{
    NSMutableDictionary *addressDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    [addressDictionary setObject:self.nameTextField.text forKey:@"seller_name"];
    [addressDictionary setObject:self.addressTextField.text forKey:@"seller_address"];
    [addressDictionary setObject:self.cityTextField.text forKey:@"seller_city"];
    [addressDictionary setObject:self.stateTextField.text forKey:@"seller_state"];
    [addressDictionary setObject:self.zipTextField.text forKey:@"seller_zip"];
    [addressDictionary setObject:self.phoneTextField.text forKey:@"seller_phone"];
    [addressDictionary setObject:self.emailTextField.text forKey:@"seller_email"];    
    [addressDictionary setObject:self.websiteTextField.text forKey:@"seller_website"];
    [addressDictionary setObject:self.categoryTextField.text forKey:@"seller_category"];
    
    NSLog(@"addressDictionay: %@", addressDictionary);
    [SellersAPIHandler makeCreateSellerRequestWithDelegate:self withInstagramUserObject:[InstagramUserObject getStoredUserObject] withSellerAddressDictionary:addressDictionary];

    self.containerScrollView.contentSize = CGSizeMake(0, self.containerScrollView.frame.size.height * 2);
    
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
