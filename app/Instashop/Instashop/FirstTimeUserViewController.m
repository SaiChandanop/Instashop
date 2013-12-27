//
//  FirstTimeUserViewController.m
//  Instashop
//
//  Created by Susan Yee on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "FirstTimeUserViewController.h"
#import "AppDelegate.h"
#import "DiscoverViewController.h"
#import "SuggestedStoresViewController.h"
#import "ISConstants.h"

@interface FirstTimeUserViewController ()

@end

#define kHowToPageNumber 5
#define kButtonHeight 100.0

@implementation FirstTimeUserViewController

@synthesize tutorialScrollView;
@synthesize pageControl;
@synthesize loginTutorialDone;
@synthesize parentViewController;
@synthesize suggestedStoresViewController;
@synthesize enterEmailViewController;
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
    
    //    CGFloat whiteSpace = 11.0f;
    //CGFloat topSpace = 64.0f;
    
    UIColor *textColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0];
    
    // Next Button
    
    /*
    float buttonSize = 50.0; // Change this number to change the button position.
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, screenHeight - buttonSize, screenWidth, buttonSize)];
    [self.nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    self.nextButton.titleLabel.textColor = textColor;
    self.nextButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.nextButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:3.0];
    [self.nextButton setBackgroundColor:[ISConstants getISGreenColor]];
    [self.nextButton addTarget:self action:@selector(moveScrollView) forControlEvents:UIControlEventTouchUpInside];
     
     */
    
    // Scroll View
    self.tutorialScrollView = [[UIScrollView alloc] initWithFrame:screenBound];
    self.tutorialScrollView.pagingEnabled = YES;
    self.tutorialScrollView.showsHorizontalScrollIndicator = NO;
    self.tutorialScrollView.backgroundColor = [UIColor blackColor];
    self.tutorialScrollView.bounces = NO;  // Empty side view
    
    // Needs to be less than bound height to disable vertical scrolling.
    self.tutorialScrollView.contentSize = CGSizeMake(screenWidth * kHowToPageNumber, 33.3);
    float howToViewBoundsHeight = self.tutorialScrollView.bounds.size.height;
    
    NSString *firstString = [NSString stringWithFormat:@"Tell followers where to buy the products you post on Instagram"];
    NSString *secondString = [NSString stringWithFormat:@"Buy products from your favorite retailers and brands"];
    NSString *thirdString = [NSString stringWithFormat:@"Save products for later purchase or gift ideas"];
    NSString *fourthString = [NSString stringWithFormat:@"Experience a simple and seamless checkout process"];
    
    NSArray *arrayOfStringLabels = [[NSArray alloc] initWithObjects:firstString, secondString, thirdString, fourthString, nil];
    
    NSArray *arrayOfImages = [[NSArray alloc] initWithObjects:@"FirstTTutorialOne.png", @"FirstTTutorialTwo.png", @"FirstTTutorialThree.png", @"FirstTTutorialFour.png", nil];
    
    for (int p = 0; p < [arrayOfImages count]; p++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(p * screenWidth, 0.0, screenWidth, screenHeight)];
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightMenuBG.png"]];
        [backgroundImage setContentMode:UIViewContentModeScaleAspectFill];
        [view addSubview:backgroundImage];
        UIImage *image = [UIImage imageNamed:[arrayOfImages objectAtIndex:p]];
        int yPosition = 120.0; // change yPosition to position the iPhone image.
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, yPosition, screenWidth, screenHeight)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [imageView setImage:image];
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth, 150.0)];
        label.text = [arrayOfStringLabels objectAtIndex:p];
        label.font = [UIFont fontWithName:@"Helvetica Neue Light" size:1.0];
        label.textColor = textColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 3;
        [view addSubview:label];
        
        [self.tutorialScrollView addSubview:view];
    }
    
    // Enter email View Controller
    
    self.enterEmailViewController = [[EnterEmailViewController alloc] initWithNibName:@"EnterEmailViewController" bundle:nil];
    self.enterEmailViewController.view.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight);
    self.enterEmailViewController.firstTimeUserViewController = self;
    // [self.tutorialScrollView addSubview:self.enterEmailViewController.view];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:self.enterEmailViewController];
    
    [navigationController setTitle:@"Enter Email"];
    [navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    navigationController.navigationBar.translucent = NO;
    navigationController.view.frame = CGRectMake(screenWidth * 4, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    [self.tutorialScrollView addSubview:navigationController.view];

    // SuggestViewController
    
    /*
    self.suggestedStoresViewController = [[SuggestedStoresViewController alloc] initWithNibName:@"SuggestedStoresViewController" bundle:nil];
    //  self.suggestedStoresViewController.view.frame = CGRectMake(screenWidth * 5, 0.0, screenWidth, screenHeight - buttonSize);
    self.suggestedStoresViewController.firstTimeUserViewController = self;
   // [self.tutorialScrollView addSubview:self.suggestedStoresViewController.view];
     */
    
    // Page Control
    
    self.pageControl = [[UIPageControl alloc] init];
    float pageControlHeight = 50.0;
    self.pageControl.frame = CGRectMake(0.0, screenHeight - pageControlHeight, screenWidth, pageControlHeight);
    self.pageControl.enabled = YES;
    self.pageControl.numberOfPages = [arrayOfImages count];
    self.pageControl.currentPage = 0;
    
    self.tutorialScrollView.delegate = self;
    [self.view addSubview:self.tutorialScrollView];
    [self.view addSubview:self.pageControl];
    
    /*
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];
     
     Feature of past FirstTimeUserViewController version */

}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = self.tutorialScrollView.frame.size.width;
    float fractionalPage = self.tutorialScrollView.contentOffset.x/pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page;
    
    // this coding is really ugly.  
    if (page != 4) {
        [self.nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
        self.nextButton.enabled = YES;
        [self.nextButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self.nextButton addTarget:self action:@selector(moveScrollView) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (page < 4) {
        self.pageControl.hidden = NO;
    }
    else {
        self.pageControl.hidden = YES;
    }
    
    [self.suggestedStoresViewController updateButton];
}

- (void) moveScrollView {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    if (self.tutorialScrollView.contentOffset.x < screenWidth * 4) {
        [self.tutorialScrollView setContentOffset:CGPointMake(self.tutorialScrollView.contentOffset.x + screenWidth, 0) animated:YES];
    }
}

- (void) closeTutorial {
    [self.parentViewController firstTimeTutorialExit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
