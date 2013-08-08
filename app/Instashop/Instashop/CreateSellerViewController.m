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
#import "CategoriesNavigationViewController.h"
#import "AppRootViewController.h"
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


@synthesize titleTextLabel;

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
    
    
    UIView *homeCustomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 50, 44)];
    
    UIImageView *homeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"closebutton.png"]];
    homeImageView.frame = CGRectMake(0,0,50,44);
    [homeCustomView addSubview:homeImageView];
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(0,0,homeCustomView.frame.size.width, homeCustomView.frame.size.height);
    homeButton.backgroundColor = [UIColor clearColor];
    [homeButton addTarget:self action:@selector(backButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [homeCustomView addSubview:homeButton];
    
    UIBarButtonItem *homBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeCustomView];
    self.navigationItem.leftBarButtonItem = homBarButtonItem;
    
    
    
    UIImage *bagImage = [UIImage imageNamed:@"lmVerifiedRetailerIcon.png"];
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bagImage.size.width, bagImage.size.height)];
    rightImageView.image = bagImage;
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:rightImageView];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    
    self.navigationItem.titleView = self.titleTextLabel;
    self.navigationItem.titleView.frame = CGRectMake(0,0,50,50);
    
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:42.0f/255.0f green:42.0f/255.0f blue:42.0f/255.0f alpha:1];
}

-(void)backButtonHit
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)categorySelectionCompleteWithArray:(NSArray *)selectionArray
{
    NSMutableString *categoriesString = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < [selectionArray count]; i++)
    {
        [categoriesString appendString:[NSString stringWithFormat:@" %@", [selectionArray objectAtIndex:i]]];
        if (i != [selectionArray count] -1)
            [categoriesString appendString:@" >"];
        
    }
    
    self.categoryTextField.text = categoriesString;
    
}


-(IBAction)categoryButtonHit
{
    CategoriesNavigationViewController *categoriesNavigationViewController = [[CategoriesNavigationViewController alloc] initWithNibName:nil bundle:nil];
    categoriesNavigationViewController.parentController = self;
    [self.navigationController pushViewController:categoriesNavigationViewController animated:YES];
    
}


-(BOOL)fieldsValidated
{
    BOOL retval = NO;
    
    if ([self.nameTextField.text length] > 0)
        if ([self.addressTextField.text length] > 0)
            if ([self.cityTextField.text length] > 0)
                if ([self.stateTextField.text length] > 0)
                    if ([self.zipTextField.text length] > 0)
                        if ([self.emailTextField.text length] > 0)
                            if ([self.websiteTextField.text length] > 0)
                                if ([self.categoryTextField.text length] > 0)
                                    retval = YES;
    
    return retval;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self fieldsValidated])
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    else
        [self.submitButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}


-(IBAction)doneButtonHit
{
    if ([self fieldsValidated])
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
    }
    else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"Please fill out all fields"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    
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
