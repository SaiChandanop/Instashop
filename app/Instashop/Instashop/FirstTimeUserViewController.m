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

@interface FirstTimeUserViewController ()

@end

#define kHowToPageNumber 3

@implementation FirstTimeUserViewController

@synthesize tutorialScrollView;
@synthesize pageControl;
@synthesize loginTutorialDone;

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

    // Scroll View
    
    self.tutorialScrollView = [[UIScrollView alloc] initWithFrame:screenBound];
    self.tutorialScrollView.pagingEnabled = YES;
    self.tutorialScrollView.showsHorizontalScrollIndicator = NO;
    self.tutorialScrollView.backgroundColor = [UIColor blackColor];
    self.tutorialScrollView.contentSize = CGSizeMake(screenWidth * kHowToPageNumber, screenHeight);
    
    UIView *welcomeView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth, screenHeight)];
    welcomeView.backgroundColor = [UIColor blackColor];
    UIImage *welcomeImage = [UIImage imageNamed:@"login_tutorial1.jpg"];
    UIImageView *welcomeImageView = [[UIImageView alloc] initWithFrame:welcomeView.frame];
    [welcomeImageView setImage:welcomeImage];
    welcomeImageView.contentMode = UIViewContentModeScaleAspectFill;
    [welcomeView addSubview:welcomeImageView];
    [self.tutorialScrollView addSubview:welcomeView];
    
    // Have trouble testing DiscoverViewController on Simulator but works fine on device.
    DiscoverViewController *discoverView = [[DiscoverViewController alloc] initWithNibName:@"DiscoverViewController" bundle:nil];
    discoverView.view.frame = CGRectMake(screenWidth, 0.0, screenWidth, discoverView.view.bounds.size.height);
    [self.tutorialScrollView addSubview:discoverView.view];
    
    SuggestedStoresViewController *suggestedStoreView = [[SuggestedStoresViewController alloc] initWithNibName:@"SuggestedStoresViewController" bundle:nil];
    suggestedStoreView.view.frame = CGRectMake(screenWidth * 2, 0.0, screenWidth, screenHeight);
    suggestedStoreView.firstTimeUserViewController = self;
    [self.tutorialScrollView addSubview:suggestedStoreView.view];
    
    self.loginTutorialDone = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth * 2.0, screenHeight, 320.0, 480.0)];
    self.loginTutorialDone.backgroundColor = [UIColor redColor];
    [self.loginTutorialDone addTarget:self action:@selector(closeTutorial) forControlEvents:UIControlEventTouchUpInside];
    [self.tutorialScrollView addSubview:self.loginTutorialDone];
    
    for (int p = 0; p <= kHowToPageNumber; p++) {
        
        if (p == kHowToPageNumber) {
            UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(p * screenWidth, 0.0, screenWidth, screenHeight)];
            UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightMenuBG.png"]];
            [rightView addSubview:backgroundImage];
            [self.tutorialScrollView addSubview:rightView];
            break;
        }
        UIView *tutorialView = [[UIView alloc] initWithFrame:CGRectMake(p * screenWidth, 0.0, screenWidth, screenHeight)];
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightMenuBG.png"]];
        [tutorialView addSubview:backgroundImage];
        if (p == (kHowToPageNumber - 1)) {
            UIButton *signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(100.0, 350.0, 50.0, 50.0)];
            signUpButton.backgroundColor = [UIColor redColor];
            [signUpButton addTarget:self action:@selector(closeTutorial) forControlEvents:UIControlEventTouchUpInside];
            [tutorialView addSubview:signUpButton];
        }
    }
    
    
    self.tutorialScrollView.delegate = self;
    [self.view addSubview:self.tutorialScrollView];
    
    // Page Control
    self.pageControl = [[UIPageControl alloc] init];
    float pageControlHeight = 50.0;
    self.pageControl.frame = CGRectMake(0.0, screenHeight - pageControlHeight, screenWidth, pageControlHeight);
    self.pageControl.numberOfPages = kHowToPageNumber;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor redColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    self.pageControl.defersCurrentPageDisplay = YES;
    [self.view addSubview:pageControl];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = self.tutorialScrollView.frame.size.width;
    float fractionalPage = self.tutorialScrollView.contentOffset.x/pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

- (void) showCloseTutorialButton {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.loginTutorialDone.frame = CGRectMake(screenWidth * 2, 200.0, self.loginTutorialDone.frame.size.width, self.loginTutorialDone.frame.size.height);
    [UIView commitAnimations];
}

- (void) hideCloseTutorialButton {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.loginTutorialDone.frame = CGRectMake(screenWidth * 2, 480.0, self.loginTutorialDone.frame.size.width, self.loginTutorialDone.frame.size.height);
    [UIView commitAnimations];
}

- (void) closeTutorial {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
