//
//  CreateSellerViewController.h
//  Instashop
//
//  Created by Josh Klobe on 7/17/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"

@class HomeViewController;
@interface CreateSellerViewController : UIViewController
{
    HomeViewController *delegate;
    
    TPKeyboardAvoidingScrollView *containerScrollView;
    
    UITextField *nameTextField;
    UITextField *addressTextField;
    UITextField *cityTextField;
    UITextField *stateTextField;
    UITextField *zipTextField;
    UITextField *phoneTextField;
    
    UITextField *emailTextField;
    UITextField *categoryTextField;
    UITextField *websiteTextField;
}

-(IBAction)cancelButtonHit;
-(IBAction)doneButtonHit;

@property (nonatomic, retain) HomeViewController *delegate;

@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *containerScrollView;

@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *addressTextField;
@property (nonatomic, retain) IBOutlet UITextField *cityTextField;
@property (nonatomic, retain) IBOutlet UITextField *stateTextField;
@property (nonatomic, retain) IBOutlet UITextField *zipTextField;
@property (nonatomic, retain) IBOutlet UITextField *phoneTextField;

@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *categoryTextField;
@property (nonatomic, retain) IBOutlet UITextField *websiteTextField;



@end
