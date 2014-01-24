//
//  EnterEmailViewController.m
//  Instashop
//
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

@interface EnterEmailViewController ()


@end

#define ALPHA                   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define NUMERIC                 @"1234567890"
#define ALPHA_NUMERIC           ALPHA NUMERIC

@implementation EnterEmailViewController

@synthesize enterEmailView;
@synthesize firstTimeUserViewController;
@synthesize enterEmailTextField;
@synthesize categoriesViewController;
@synthesize categoriesLabel;
@synthesize tosButton;


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
	// Do any additional setup after loading the view.
    
    self.enterEmailTextField.delegate = self;
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
    
    [self.tosButton setTitle:@"off" forState:UIControlStateNormal];
    self.tosButton.selected = NO;
    
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

-(IBAction)categoriesButtonHit
{
    [self.enterEmailTextField resignFirstResponder];
    
    self.categoriesViewController = [[CategoriesViewController alloc] initWithNibName:nil bundle:nil];
    self.categoriesViewController.categoriesType = CATEGORIES_TYPE_PRODUCT;
    self.categoriesViewController.potentialCategoriesArray = [[AttributesManager getSharedAttributesManager] getCategoriesWithArray:[NSArray array]];
    self.categoriesViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.categoriesViewController.parentController = self;
    [self.view addSubview:self.categoriesViewController.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.30];
    self.categoriesViewController.view.frame = CGRectMake(0, 0, self.categoriesViewController.view.frame.size.width, self.categoriesViewController.view.frame.size.height);
    [UIView commitAnimations];

    
//    [self.navigationController pushViewController:categoriesViewController animated:YES];
}

-(NSString *)validateContent
{
    NSString *errorString = nil;
    
    if ([self.enterEmailTextField.text length] == 0)
        errorString = @"Please enter an email";
    else if ([self.categoriesLabel.text compare:@"Categories"] == NSOrderedSame)
        errorString = @"Please enter a category";
    else if (self.tosButton.selected == NO)
        errorString = @"Please validate the terms of service";
    
    
    
    if (errorString == nil)
    {
        [self.firstTimeUserViewController emailPageComplete];
        
    }
    return errorString;
}
- (IBAction) nextButtonHit:(id)sender {
    
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
        [self.firstTimeUserViewController moveScrollView];
}




- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    [self validateContent];
    return YES;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.enterEmailTextField resignFirstResponder];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    self.enterEmailTextField.placeholder = nil;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text length] == 0) {
        [self.enterEmailTextField setPlaceholder:@"Email"];
    }
    [self.enterEmailTextField endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *unacceptedInput = nil;
    if ([[textField.text componentsSeparatedByString:@"@"] count] > 1) {
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[ALPHA_NUMERIC stringByAppendingString:@".-"]] invertedSet];
        // Method that checks whether or not button should be green now.
        
        
    } else {
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[ALPHA_NUMERIC stringByAppendingString:@".!#$%&'*+-/=?^_`{|}~@"]] invertedSet];
    }
    return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
}




@end
