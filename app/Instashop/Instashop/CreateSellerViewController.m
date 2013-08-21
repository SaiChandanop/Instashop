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
#import "CategoriesViewController.h"
#import "AppRootViewController.h"
#import "AppDelegate.h"
#import "ISConstants.h"


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
@synthesize keyboardControls;
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
    
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
//    CGFloat whiteSpace = 11.0f;
    //CGFloat topSpace = 64.0f;
    
    self.containerScrollView.frame = CGRectMake(0, 66, screenWidth, screenHeight - 66);
    self.containerScrollView.contentSize = CGSizeMake(screenWidth, self.containerScrollView.contentSize.height);
//    self.containerScrollView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.containerScrollView];
    
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
    homeImageView.frame = CGRectMake(0,0,44,44);
    [homeCustomView addSubview:homeImageView];
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(0,0,homeCustomView.frame.size.width, homeCustomView.frame.size.height);
    homeButton.backgroundColor = [UIColor clearColor];
    [homeButton addTarget:self action:@selector(backButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [homeCustomView addSubview:homeButton];
    
    UIBarButtonItem *homBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeCustomView];
    self.navigationItem.leftBarButtonItem = homBarButtonItem;
    
    self.navigationItem.titleView = self.titleTextLabel;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    
    NSArray *fields = [NSArray arrayWithObjects:self.nameTextField,self.emailTextField,self.phoneTextField, self.websiteTextField, self.addressTextField, self.cityTextField, self.stateTextField, self.zipTextField, nil];
    
    [self setKeyboardControls:[[BSKeyboardControls alloc] initWithFields:fields]];
    [self.keyboardControls setDelegate:self];
    
    
    [self.nameTextField setValue:[UIColor lightGrayColor]
                                forKeyPath:@"_placeholderLabel.textColor"];
    [self.addressTextField setValue:[UIColor lightGrayColor]
                                forKeyPath:@"_placeholderLabel.textColor"];
    [self.cityTextField setValue:[UIColor lightGrayColor]
                                forKeyPath:@"_placeholderLabel.textColor"];
    [self.stateTextField setValue:[UIColor lightGrayColor]
                                forKeyPath:@"_placeholderLabel.textColor"];
    [self.zipTextField setValue:[UIColor lightGrayColor]
                                forKeyPath:@"_placeholderLabel.textColor"];
    [self.phoneTextField setValue:[UIColor lightGrayColor]
                                forKeyPath:@"_placeholderLabel.textColor"];
    [self.emailTextField setValue:[UIColor lightGrayColor]
                                forKeyPath:@"_placeholderLabel.textColor"];
    [self.categoryTextField setValue:[UIColor lightGrayColor]
                                forKeyPath:@"_placeholderLabel.textColor"];
    [self.websiteTextField setValue:[UIColor lightGrayColor]
                                forKeyPath:@"_placeholderLabel.textColor"];

   
    
    
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
    CategoriesViewController *categoriesViewController = [[CategoriesViewController alloc] initWithNibName:nil bundle:nil];
    categoriesViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    categoriesViewController.parentController = self;
    [self.navigationController pushViewController:categoriesViewController animated:YES];
  
    [self.navigationController.navigationItem.backBarButtonItem setTitle:@"TEST"];
    
    categoriesViewController.initialTableReference.frame = CGRectMake(0,0, categoriesViewController.initialTableReference.frame.size.width, categoriesViewController.initialTableReference.frame.size.height);
}


-(BOOL)fieldsValidated
{
    BOOL retval = NO;
    
    if ([self.nameTextField.text length] > 0)
        if ([self.emailTextField.text length] > 0)
            if ([self.websiteTextField.text length] > 0)
                if ([self.categoryTextField.text length] > 0)
                    retval = YES;
//        if ([self.addressTextField.text length] > 0)
//            if ([self.cityTextField.text length] > 0)
  //              if ([self.stateTextField.text length] > 0)
    //                if ([self.zipTextField.text length] > 0)
        
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

-(IBAction)followInstashopButtonHit
{
    AppDelegate *theAppDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"/users/280421250/relationship", @"method", @"follow", @"action", nil];
    [theAppDelegate.instagram postRequestWithParams:params delegate:self];
    
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    
    NSLog(@"follow result: %@", result);
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"request failed with error: %@", error);
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



#pragma mark -
#pragma mark Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.keyboardControls setActiveField:textField];
}

#pragma mark -
#pragma mark Text View Delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.keyboardControls setActiveField:textView];
}

#pragma mark -
#pragma mark Keyboard Controls Delegate

- (void)keyboardControls:(BSKeyboardControls *)theKeyboardControls selectedField:(UIView *)field inDirection:(BSKeyboardControlsDirection)direction
{
//    UIView *view = theKeyboardControls.activeField.superview.superview;
//    [self.containerScrollView scrollRectToVisible:view.frame animated:YES];
}

- (void)keyboardControlsDonePressed:(BSKeyboardControls *)theKeyboardControls
{
    [theKeyboardControls.activeField resignFirstResponder];
}

@end
