//
//  EnterEmailViewController.m
//  Instashop
//
//  Created by Susan Yee on 12/27/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "EnterEmailViewController.h"
#import "ISConstants.h"

@interface EnterEmailViewController ()

@property (nonatomic, assign) int correctEmail;
@property (nonatomic, assign) int categoryChosen;
@property (nonatomic, assign) int agreement;

@end

#define ALPHA                   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define NUMERIC                 @"1234567890"
#define ALPHA_NUMERIC           ALPHA NUMERIC

@implementation EnterEmailViewController

@synthesize enterEmailView;
@synthesize firstTimeUserViewController;
@synthesize enterEmailTextField;
@synthesize nextButton;
@synthesize correctEmail;
@synthesize categoryChosen;
@synthesize agreement;

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
        [self enableNextButton:1];
        
    } else {
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[ALPHA_NUMERIC stringByAppendingString:@".!#$%&'*+-/=?^_`{|}~@"]] invertedSet];
        [self enableNextButton:2];
    }
    return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    // Some method for handling the text input.
    return YES;
}

- (void) enableNextButton: (int) callNumber {
    
    if (callNumber < 3) {
        self.correctEmail = callNumber;
    }
    else if (callNumber > 2 && callNumber < 5) {
        self.categoryChosen = callNumber;
    }
    else if (callNumber > 4 && callNumber < 7) {
        self.agreement = callNumber;
    }
    
    // Only when there is an email, category and agreement to the service put in.  Booleans.  
    if ((self.correctEmail == 1) && (self.categoryChosen == 3) && (self.agreement == 5)) {
        
        UIColor *textColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0];
        self.nextButton.titleLabel.textColor = textColor;
        self.nextButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:3.0];
        [self.nextButton setBackgroundColor:[ISConstants getISGreenColor]];
        [self.nextButton setEnabled:YES];
    }
    else {
        // Set everything back to the grey color.
        [self.nextButton setEnabled:NO];
    }
}

- (IBAction) nextButtonHit:(id)sender {
    [self.firstTimeUserViewController moveScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
