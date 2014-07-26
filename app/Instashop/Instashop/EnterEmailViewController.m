//
//  EnterEmailViewController.m
//  Instashop
//  Last page of the first time user setup, used to contain email, categories, TOS, buyer / seller VCS.
//  Created by Susan Yee on 12/27/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "EnterEmailViewController.h"
#import "ISConstants.h"
#import "CategoriesViewController.h"
#import "AttributesManager.h"
#import "FirstTimeUserViewController.h"
#import "AppRootViewController.h"
#import "NavBarTitleView.h"
#import "InstagramUserObject.h"
#import "MailchimpAPIHandler.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface EnterEmailViewController ()


@end

#define ALPHA                   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define NUMERIC                 @"1234567890"
#define ALPHA_NUMERIC           ALPHA NUMERIC

@implementation EnterEmailViewController

@synthesize enterEmailView;
@synthesize firstTimeUserViewController;
@synthesize enterEmailTextField;
@synthesize categoriesLabel;
@synthesize tosButton;
@synthesize interestsViewController;
@synthesize theSegmentedControl;
@synthesize tosContainerView;
@synthesize enterNameTextField;
@synthesize nextCoverButton;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        /* Testing - For now can just test by putting in a valid email.
         self.correctEmail = 1;
         self.categoryChosen = 3;
         self.agreement = 5; */
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSLog(@"!!!!!!!! FRAME: %@", NSStringFromCGRect([[UIScreen mainScreen] applicationFrame]));
    
    float screenHeight = [[UIScreen mainScreen] applicationFrame].size.height;
    
	// Do any additional setup after loading the view.
    
    self.enterEmailTextField.delegate = self;
    self.enterNameTextField.delegate = self;
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    
    [self.tosButton setTitle:@"off" forState:UIControlStateNormal];
    self.tosButton.selected = NO;
    
    NSLog(@"videw did load, id: %@", [InstagramUserObject getStoredUserObject].userID);
    
    
    [self.theSegmentedControl setTitle:@"Publisher/Blogger" forSegmentAtIndex:1];
    [self.theSegmentedControl setTitle:@"Shopper" forSegmentAtIndex:2];
    
    
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:83.0f/255.0f green:161.0f/255.0f blue:135.0f/255.0f alpha:1]];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10], NSFontAttributeName,
                                                             [UIColor colorWithRed:83.0f/255.0f green:161.0f/255.0f blue:135.0f/255.0f alpha:1], NSForegroundColorAttributeName,
                                                             [UIColor redColor], NSForegroundColorAttributeName,
                                                             nil] forState:UIControlStateNormal];
    
    
    UIView *segmentedBackgroundView = [[UIView alloc] initWithFrame:self.theSegmentedControl.frame];
    segmentedBackgroundView.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:.25];
    segmentedBackgroundView.layer.cornerRadius = 5;
    segmentedBackgroundView.layer.masksToBounds = YES;
    [self.view insertSubview:segmentedBackgroundView belowSubview:self.theSegmentedControl];
    if (screenHeight < 568)
        segmentedBackgroundView.frame = CGRectMake(segmentedBackgroundView.frame.origin.x - .5, segmentedBackgroundView.frame.origin.y, segmentedBackgroundView.frame.size.width-1, segmentedBackgroundView.frame.size.height);
                                                   
    
    self.theSegmentedControl.backgroundColor = [UIColor clearColor];
    
    float height = 50;
    
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, screenHeight - height, self.view.frame.size.width, height)];
    self.nextButton.enabled = NO;    
    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"Menu-BG.png"] forState:UIControlStateDisabled];
    [self.nextButton setTitle:@"Next" forState:UIControlStateDisabled];
    self.nextButton.titleLabel.textColor = [UIColor whiteColor];
    self.nextButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.nextButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:3.0];
    [self.nextButton setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.75]];
    [self.nextButton addTarget:self action:@selector(nextButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
    
    self.tosContainerView.frame = CGRectMake(0, self.nextButton.frame.origin.y - self.tosContainerView.frame.size.height, self.tosContainerView.frame.size.width, self.tosContainerView.frame.size.height);
    
    self.nextCoverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextCoverButton.frame = self.nextButton.frame;
    self.nextCoverButton.backgroundColor = [UIColor clearColor];
    [self.nextCoverButton addTarget:self action:@selector(nextCoverButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextCoverButton];
    
    
    
    [self.theSegmentedControl addTarget:self action:@selector(segmentedControlChanged) forControlEvents:UIControlEventValueChanged];
    
}

-(void)segmentedControlChanged
{
    NSLog(@"segmentedControlChanged");
    [self.enterEmailTextField resignFirstResponder];
    [self.enterNameTextField resignFirstResponder];
}




-(IBAction)tosLinkButtonHit
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    webView.scalesPageToFit = YES;
    webView.contentMode = UIViewContentModeScaleToFill;
    webView.multipleTouchEnabled = YES;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://instashop.com/terms"]]];
    
    UIViewController *webViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    webViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [webViewController.view addSubview:webView];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];
    
    [navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    navigationController.navigationBar.translucent = NO;
    
    [webViewController.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"Terms of Service"]];
    
    
    
    webViewController.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(dismissVC)];
    
    
    
    
    [[AppRootViewController sharedRootViewController] presentViewController:navigationController animated:YES completion:nil];
}

-(void)dismissVC
{
    [[AppRootViewController sharedRootViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)tosButtonHit
{
    [self.enterEmailTextField resignFirstResponder];
    
    self.tosButton.selected = !self.tosButton.selected;
    
    if (self.tosButton.selected)
        [self.tosButton setTitle:@"on" forState:UIControlStateNormal];
    else
        [self.tosButton setTitle:@"off" forState:UIControlStateNormal];
    
    [self validateContent];
}

/*
 -(void)categoriesViewControllerShouldRemove
 {
 [self.categoriesViewController.view removeFromSuperview];
 self.categoriesViewController = nil;
 }
 
 -(void)categorySelectionCompleteWithArray:(NSArray *)theArray
 {
 self.categoriesLabel.text = [theArray objectAtIndex:0];
 [UIView beginAnimations:nil context:nil];
 [UIView setAnimationDuration:.30];
 [UIView setAnimationDelegate:self];
 [UIView setAnimationDidStopSelector:@selector(categoriesViewControllerShouldRemove)];
 self.categoriesViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.categoriesViewController.view.frame.size.width, self.categoriesViewController.view.frame.size.height);
 [UIView commitAnimations];
 
 [self validateContent];
 
 
 }
 */

-(void)interestsViewControllerShouldRemove
{
    [self.interestsViewController.view removeFromSuperview];
    self.interestsViewController = nil;
}


-(void)categorySelectionCompleteWithString:(NSString *)theCategory
{
    self.categoriesLabel.text = theCategory;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.30];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(interestsViewControllerShouldRemove)];
    self.interestsViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.interestsViewController.view.frame.size.width, self.interestsViewController.view.frame.size.height);
    [UIView commitAnimations];
    
    [self validateContent];
}

-(IBAction)categoriesButtonHit
{
    [self.enterEmailTextField resignFirstResponder];
    
    self.interestsViewController = [[InterestsViewController alloc] initWithNibName:nil bundle:nil];
    self.interestsViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.interestsViewController.theParentController = self;
    [self.view addSubview:self.interestsViewController.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.30];
    self.interestsViewController.view.frame = CGRectMake(0, 0, self.interestsViewController.view.frame.size.width, self.interestsViewController.view.frame.size.height);
    [UIView commitAnimations];
    
    
    //    [self.navigationController pushViewController:categoriesViewController animated:YES];
}

-(NSString *)validateContent
{
    NSString *errorString = nil;
    
    if ([self.enterNameTextField.text length] == 0)
        errorString = @"Please enter an name";
    else if ([self.enterEmailTextField.text length] == 0)
        errorString = @"Please enter an email";
    //    else if (![self validateEmail:self.enterNameTextField.text])
    //      errorString = @"Please enter a valid email address";
    else if ([self.categoriesLabel.text compare:@"Categories"] == NSOrderedSame)
        errorString = @"Please enter a category";
    else if (self.tosButton.selected == NO)
        errorString = @"Please validate the terms of service";
    
    
    
    if (errorString == nil)
    {
        [self emailPageComplete];
        
    }
    return errorString;
}
- (void)nextCoverButtonHit
{
    [self.enterEmailTextField resignFirstResponder];
    NSString *errorString =[self validateContent];
    
    if (errorString != nil)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:errorString
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else
        [self completeView];
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.enterEmailTextField resignFirstResponder];
    [self.enterNameTextField resignFirstResponder];
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [self validateContent];
    return YES;
}


- (void) textFieldDidBeginEditing:(UITextField *)textField {
    textField.placeholder = nil;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.enterEmailTextField)
    {
    if ([textField.text length] == 0) {
        [textField setPlaceholder:@"Email"];
    }
    }
    else if (textField == self.enterNameTextField)
    {
        if ([textField.text length] == 0) {
            [textField setPlaceholder:@"Name"];
        }

    }
    [textField endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if (textField == self.enterNameTextField)
        return YES;
    else
    {
        NSCharacterSet *unacceptedInput = nil;
        if ([[textField.text componentsSeparatedByString:@"@"] count] > 1) {
            unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[ALPHA_NUMERIC stringByAppendingString:@".-"]] invertedSet];
            // Method that checks whether or not button should be green now.
            
            
        } else {
            unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[ALPHA_NUMERIC stringByAppendingString:@".!#$%&'*+-/=?^_`{|}~@"]] invertedSet];
        }
        return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
    }
}





- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    NSLog(@"validateEmail: %d", [emailTest evaluateWithObject:candidate]);
    return [emailTest evaluateWithObject:candidate];
}

-(void)emailPageComplete
{
    self.firstTimeUserViewController.emailComplete = YES;
    self.nextButton.enabled = YES;
    self.nextButton.backgroundColor = [ISConstants getISGreenColor];
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
}




-(void)completeView
{
    [self.firstTimeUserViewController closeTutorial];
    [MailchimpAPIHandler makeMailchimpCallWithEmail:self.enterEmailTextField.text withCategory:[self.theSegmentedControl titleForSegmentAtIndex:self.theSegmentedControl.selectedSegmentIndex]  withName:self.enterNameTextField.text];
    
}







@end
