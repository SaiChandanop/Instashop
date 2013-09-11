//
//  CreateSellerViewController.h
//  Instashop
//
//  Created by Josh Klobe on 7/17/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPKeyboardAvoidingScrollView.h"
#import "BSKeyboardControls.h"
#import "IGRequest.h"
#import "CreateSellerOccuredProtocol.h"
#import "CreateSellerTutorialScrollView.h"

@class HomeViewController;
@interface CreateSellerViewController : UIViewController <UITextFieldDelegate, BSKeyboardControlsDelegate, IGRequestDelegate, CreateSellerOccuredProtocol, UIScrollViewDelegate, CreateSellerTutorialDelegate>
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
    
    UILabel *instagramUsernameLabel;
    UIButton *submitButton;

    UIButton *followInstashopButton;
    UILabel *titleTextLabel;
    
    BSKeyboardControls *keyboardControls;
    
    UIImageView *thanksSellerImageView;
}

- (void) signUp;
-(IBAction)categoryButtonHit;
-(IBAction)cancelButtonHit;
-(IBAction)doneButtonHit;
-(IBAction)followInstashopButtonHit;

@property (nonatomic, retain) HomeViewController *delegate;

@property (nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *containerScrollView;
@property (nonatomic, retain) CreateSellerTutorialScrollView *createSellerHowToScrollView;
@property (nonatomic, retain) UIPageControl *pageControl;

@property (nonatomic, retain) IBOutlet UITextField *nameTextField;
@property (nonatomic, retain) IBOutlet UITextField *addressTextField;
@property (nonatomic, retain) IBOutlet UITextField *cityTextField;
@property (nonatomic, retain) IBOutlet UITextField *stateTextField;
@property (nonatomic, retain) IBOutlet UITextField *zipTextField;
@property (nonatomic, retain) IBOutlet UITextField *phoneTextField;

@property (nonatomic, retain) IBOutlet UITextField *emailTextField;
@property (nonatomic, retain) IBOutlet UITextField *categoryTextField;
@property (nonatomic, retain) IBOutlet UITextField *websiteTextField;

@property (nonatomic, retain) IBOutlet UILabel *instagramUsernameLabel;
@property (nonatomic, retain) IBOutlet UIButton *submitButton;

@property (nonatomic, retain) IBOutlet UIButton *followInstashopButton;
@property (nonatomic, retain) IBOutlet UILabel *titleTextLabel;

@property (nonatomic, retain) IBOutlet BSKeyboardControls *keyboardControls;

@property (nonatomic, retain) UIImageView *thanksSellerImageView;
@property (nonatomic, assign) BOOL firstRun;

@end
