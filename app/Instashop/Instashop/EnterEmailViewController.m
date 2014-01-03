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
@interface EnterEmailViewController ()


@end

#define ALPHA                   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define NUMERIC                 @"1234567890"
#define ALPHA_NUMERIC           ALPHA NUMERIC

@implementation EnterEmailViewController

@synthesize enterEmailView;
@synthesize firstTimeUserViewController;
@synthesize enterEmailTextField;
@synthesize nextButton;
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
    
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.backgroundColor = [UIColor clearColor];
    [self.nextButton addTarget:self action:@selector(nextButtonHit:) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    self.nextButton.frame = CGRectMake(0, self.view.frame.size.height - 110, self.view.frame.size.width, 44);
    [self.view addSubview:self.nextButton];
    
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];
    
    [self.tosButton setTitle:@"off" forState:UIControlStateNormal];
    self.tosButton.selected = NO;
    
    
}

-(IBAction)tosButtonHit
{
    self.tosButton.selected = !self.tosButton.selected;
    
    if (self.tosButton.selected)
        [self.tosButton setTitle:@"on" forState:UIControlStateNormal];
    else
        [self.tosButton setTitle:@"off" forState:UIControlStateNormal];
    
}
-(void)categorySelectionCompleteWithArray:(NSArray *)theArray
{
    NSLog(@"categorySelectionCompleteWithArray: %@", theArray);
    
    self.categoriesLabel.text = [theArray objectAtIndex:0];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.30];
    self.categoriesViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.categoriesViewController.view.frame.size.width, self.categoriesViewController.view.frame.size.height);
    [UIView commitAnimations];

    
}

-(IBAction)categoriesButtonHit
{
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

- (IBAction) nextButtonHit:(id)sender {
    
    NSString *errorString = nil;
    
    if ([self.enterEmailTextField.text length] == 0)
        errorString = @"Please enter an email";
    else if ([self.categoriesLabel.text compare:@"Categories"] == NSOrderedSame)
        errorString = @"Please enter a category";
    else if (self.tosButton.selected == NO)
        errorString = @"Please validate the terms of service";
    
    
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
    
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    // Some method for handling the text input.
    return YES;
}

- (void) enableNextButton: (int) callNumber {
    
    /*
     UIColor *textColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0];
     self.nextButton.titleLabel.textColor = textColor;
     self.nextButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:3.0];
     [self.nextButton setBackgroundColor:[ISConstants getISGreenColor]];
     [self.nextButton setEnabled:YES];
     }
     else {
     
     */
    [self.nextButton setEnabled:NO];
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
