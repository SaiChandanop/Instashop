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
#import "MBProgressHUD.h"
#import "NavBarTitleView.h"

@interface CreateSellerViewController ()

@end

#define kHowToPageNumber 4

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
@synthesize followInstashopButton;
@synthesize thanksSellerImageView;
@synthesize createSellerHowToScrollView;
@synthesize pageControl;

// use lightmenubg. 

//*** The words on the navigation bar of the Create Seller View Controller shifts towards the right when the view is closed.

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

    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
//    CGFloat whiteSpace = 11.0f;
    //CGFloat topSpace = 64.0f;
    
    // Scroll View
    self.createSellerHowToScrollView = [[UIScrollView alloc] initWithFrame:screenBound];
    self.createSellerHowToScrollView.pagingEnabled = YES;
    self.createSellerHowToScrollView.showsHorizontalScrollIndicator = NO;
    int arbitraryNumberSmallerThanBoundHeight = 33.0;
    // Needs to be less than bound height to disable vertical scrolling.
    self.createSellerHowToScrollView.contentSize = CGSizeMake(screenWidth * 4, arbitraryNumberSmallerThanBoundHeight);
    float howToViewBoundsHeight = self.createSellerHowToScrollView.bounds.size.height;
    
    // Maybe you want a left view so that the previous menu can't be seen.
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(-320.0, 0.0, screenWidth, howToViewBoundsHeight)];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightMenuBG.png"]];
    [leftView addSubview:backgroundImage];
    [self.createSellerHowToScrollView addSubview:leftView];
    
    NSArray *arrayOfLabels = [[NSArray alloc] initWithObjects:@"target-title.png", @"share-title.png", @"manage-title.png", @"grow-title.png", nil];
    NSArray *arrayOfImages = [[NSArray alloc] initWithObjects:@"target-graphic.png", @"share-graphic.png", @"manage-graphic.png", @"grow-graphic.png", nil];
    
    NSString *stringTextOne = [NSString stringWithFormat:@"Text 1"];
    NSString *stringTextTwo = [NSString stringWithFormat:@"Text 2"];
    NSString *stringTextThree = [NSString stringWithFormat:@"Text 3"];
    NSString *stringTextFour = [NSString stringWithFormat:@"Text 4"];
    
    NSArray *arrayOfTexts = [[NSArray alloc] initWithObjects:stringTextOne, stringTextTwo, stringTextThree, stringTextFour, nil];
    
    for (int p = 0; p <= kHowToPageNumber; p++) {
        
        if (p == kHowToPageNumber) {
            UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(p * screenWidth, 0.0, screenWidth, screenHeight)];
            UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightMenuBG.png"]];
            [rightView addSubview:backgroundImage];
            [self.createSellerHowToScrollView addSubview:rightView];
            break;
        }
        UIView *tutorialView = [[UIView alloc] initWithFrame:CGRectMake(p * screenWidth, 0.0, screenWidth, screenHeight)];
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightMenuBG.png"]];
        [tutorialView addSubview:backgroundImage];
        UIImageView *label = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[arrayOfLabels objectAtIndex:p]]];
        UIImageView *graphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[arrayOfImages objectAtIndex:p]]];
        graphic.frame = CGRectMake((320 - graphic.bounds.size.width)/2, (screenHeight - graphic.bounds.size.height)/2 + 10, graphic.bounds.size.width, graphic.bounds.size.width);
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 400.0, 220.0, 60.0)];
        textLabel.text = [arrayOfTexts objectAtIndex:p];
        textLabel.textColor = [UIColor blackColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        [tutorialView addSubview:textLabel];
        [tutorialView addSubview:label];
        [tutorialView addSubview:graphic];
        if (p == (kHowToPageNumber - 1)) {
            UIButton *signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(100.0, 350.0, 50.0, 50.0)];
            signUpButton.backgroundColor = [UIColor redColor];
            [signUpButton addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
            [tutorialView addSubview:signUpButton];
        }
        [self.createSellerHowToScrollView addSubview:tutorialView];
    }
    
    self.createSellerHowToScrollView.delegate = self;
    [self.view addSubview:self.createSellerHowToScrollView];
    
    // Page Control
    self.pageControl = [[UIPageControl alloc] init];
    float pageControlHeight = 50.0;
    self.pageControl.frame = CGRectMake(0.0, screenHeight - 66 - pageControlHeight, screenWidth, pageControlHeight);
    self.pageControl.numberOfPages = kHowToPageNumber;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor redColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    [self.view addSubview:pageControl];
    
    // This is individual set up of each view.
    /*
    // Target View
    UIImageView *targetLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"target-title.png"]];
    UIImageView *targetGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"target-graphic.png"]];
    UIView *targetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, howToViewBoundsHeight)];
    [targetView addSubview:backgroundImage];
    [targetView addSubview:targetGraphic];
    [targetView addSubview:targetLabel];
    
    // Share View
    UIImageView *shareLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share-title.png"]];
    UIImageView *shareGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share-graphic.png"]];
    shareGraphic.frame = CGRectMake((320 - shareGraphic.bounds.size.width)/2, (screenHeight - shareGraphic.bounds.size.height)/2, shareGraphic.bounds.size.width, shareGraphic.bounds.size.width);
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(320.0, 0, screenWidth, howToViewBoundsHeight)];
    [shareView addSubview:backgroundImage];
    [shareView addSubview:shareGraphic];
    [shareView addSubview:shareLabel];
    
    // Manage View
    UIImageView *manageLabel
    = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"manage-title.png"]];
    UIImageView *manageGraphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"manage-graphic.png"]];
    manageGraphic.frame = CGRectMake((320 - manageGraphic.bounds.size.width)/2, (screenHeight - manageGraphic.bounds.size.height)/2, manageGraphic.bounds.size.width, manageGraphic.bounds.size.width);
    UIView *manageView = [[UIView alloc] initWithFrame:CGRectMake(640.0, 0, screenWidth, howToViewBoundsHeight)];
    [manageView addSubview:backgroundImage];
    [manageView addSubview:manageGraphic];
    [manageView addSubview:manageLabel];
    
    [self.createSellerHowToScrollView addSubview:leftView];
    [self.createSellerHowToScrollView addSubview:targetView];
    [self.createSellerHowToScrollView addSubview:shareView];
    [self.createSellerHowToScrollView addSubview:manageView];
    self.view = self.createSellerHowToScrollView;*/
    
    self.instagramUsernameLabel.text = [InstagramUserObject getStoredUserObject].username;
    
    /*
     self.nameTextField.text = @"Josh Klobe";
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
    
    UIImageView *homeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"closebutton_white.png"]];
    homeImageView.frame = CGRectMake(0,0,44,44);
    [homeCustomView addSubview:homeImageView];
    
    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(0,0,homeCustomView.frame.size.width, homeCustomView.frame.size.height);
    homeButton.backgroundColor = [UIColor clearColor];
    [homeButton addTarget:self action:@selector(backButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [homeCustomView addSubview:homeButton];
    
    UIBarButtonItem *homBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:homeCustomView];
    self.navigationItem.leftBarButtonItem = homBarButtonItem;
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"BECOME A SELLER"]];
    
    
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    bgImageView.image = [UIImage imageNamed:@"Menu_BG"];
    [self.view insertSubview:bgImageView atIndex:0];
    

    
    //self.addressTextField, self.cityTextField, self.stateTextField, self.zipTextField,
    NSArray *fields = [NSArray arrayWithObjects:self.nameTextField,self.emailTextField, self.addressTextField, self.cityTextField, self.stateTextField, self.zipTextField, self.phoneTextField, self.websiteTextField, nil];
    
    for (int i = 0; i < [fields count]; i++)
        ((UITextField *)[fields objectAtIndex:i]).delegate = self;

    
    
    
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


    if ([InstagramUserObject getStoredUserObject].fullName != nil)
        self.nameTextField.text = [InstagramUserObject getStoredUserObject].fullName;

    if ([InstagramUserObject getStoredUserObject].website != nil)
        self.websiteTextField.text = [InstagramUserObject getStoredUserObject].website;
    
}

- (void) signUp {
    
    [self.pageControl removeFromSuperview];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    int arbitraryNumberSmallerThanBoundHeight = 33.0;
    // Needs to be less than bound height to disable vertical scrolling.
    self.createSellerHowToScrollView.contentSize = CGSizeMake(screenWidth * 5, arbitraryNumberSmallerThanBoundHeight);
    self.containerScrollView.frame = CGRectMake(4 * screenWidth, 0.0, screenWidth, screenHeight - 66);
    self.containerScrollView.contentSize = CGSizeMake(0, self.submitButton.frame.origin.y + self.submitButton.frame.size.height);
    [self.createSellerHowToScrollView addSubview:self.containerScrollView];
    [self.createSellerHowToScrollView bringSubviewToFront:self.containerScrollView];
    [self.createSellerHowToScrollView scrollRectToVisible:CGRectMake(1280.0, 0.0, screenWidth, screenHeight) animated:YES];
    self.createSellerHowToScrollView.scrollEnabled = NO;
}

-(void)backButtonHit
{
    [self.delegate createSellerCancelButtonHit:self.navigationController];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.createSellerHowToScrollView.frame.size.width;
    float fractionalPage = self.createSellerHowToScrollView.contentOffset.x/pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
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
//            if ([self.websiteTextField.text length] > 0)
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
//        [addressDictionary setObject:self.addressTextField.text forKey:@"seller_address"];
//        [addressDictionary setObject:self.cityTextField.text forKey:@"seller_city"];
//        [addressDictionary setObject:self.stateTextField.text forKey:@"seller_state"];
//        [addressDictionary setObject:self.zipTextField.text forKey:@"seller_zip"];
        [addressDictionary setObject:self.phoneTextField.text forKey:@"seller_phone"];
        [addressDictionary setObject:self.emailTextField.text forKey:@"seller_email"];
        [addressDictionary setObject:self.websiteTextField.text forKey:@"seller_website"];
        [addressDictionary setObject:self.categoryTextField.text forKey:@"seller_category"];
        
        NSLog(@"addressDictionay: %@", addressDictionary);
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES].detailsLabelText = @"Submitting Application";
        
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
    
    self.followInstashopButton.selected = YES;
}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"request failed with error: %@", error);
}

-(IBAction)cancelButtonHit
{
    [self.delegate createSellerCancelButtonHit:self.navigationController];
}


-(void)sellerDone
{
    [self.delegate createSellerDone:self.navigationController];
}

-(void)userDidCreateSellerWithResponseDictionary:(NSDictionary *)dictionary
{
    
    self.thanksSellerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, self.view.frame.size.height)];
    self.thanksSellerImageView.image = [UIImage imageNamed:@"thanksseller.png"];
    [self.view addSubview:self.thanksSellerImageView];
    
    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.backgroundColor = [UIColor clearColor];
    exitButton.frame = CGRectMake(0, 0, self.thanksSellerImageView.frame.size.width, self.thanksSellerImageView.frame.size.height);
    [exitButton addTarget:self action:@selector(sellerDone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitButton];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    
    NSLog(@"userDidCreateSellerWithResponseDictionary!!: %@", dictionary);
    
    InstagramUserObject *theUserObject =[InstagramUserObject getStoredUserObject];
    theUserObject.zencartID = [dictionary objectForKey:@"zencart_id"];
    
    [[InstagramUserObject getStoredUserObject] setAsStoredUser:theUserObject];
    
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
