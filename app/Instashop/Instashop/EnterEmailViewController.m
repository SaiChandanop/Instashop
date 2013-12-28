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

@end

#define ALPHA                   @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define NUMERIC                 @"1234567890"
#define ALPHA_NUMERIC           ALPHA NUMERIC

@implementation EnterEmailViewController

@synthesize firstTimeUserViewController;
@synthesize enterEmailTextField;
@synthesize nextButton;

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
	// Do any additional setup after loading the view.
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    self.enterEmailTextField.delegate = self;
    
    UIColor *textColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0];
    
    // Next Button for EnterEmailViewController
    
    float buttonSize = 50.0; // Change this number to change the button position.
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, screenHeight - buttonSize, screenWidth, buttonSize)];
    [self.nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    self.nextButton.titleLabel.textColor = textColor;
    self.nextButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.nextButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:3.0];
    self.nextButton.enabled = NO;
    [self.nextButton setBackgroundColor:[ISConstants getISGreenColor]];
    [self.nextButton addTarget:self.firstTimeUserViewController action:@selector(moveScrollView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextButton];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.enterEmailTextField resignFirstResponder];
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    self.enterEmailTextField.placeholder = nil;
}

- (void) textFieldDidEndEditing:(UITextField *)textField {
    [self.enterEmailTextField endEditing:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *unacceptedInput = nil;
    if ([[textField.text componentsSeparatedByString:@"@"] count] > 1) {
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[ALPHA_NUMERIC stringByAppendingString:@".-"]] invertedSet];
    } else {
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[ALPHA_NUMERIC stringByAppendingString:@".!#$%&'*+-/=?^_`{|}~@"]] invertedSet];
    }
    return ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    // Some method for handling the text input.
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
