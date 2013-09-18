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
    self.tutorialScrollView.showsVerticalScrollIndicator = YES;
    self.tutorialScrollView.backgroundColor = [UIColor blackColor];
    self.tutorialScrollView.contentSize = CGSizeMake(screenWidth * kHowToPageNumber, screenHeight);
    
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth, screenHeight + 33.0)];
    firstView.backgroundColor = [UIColor blackColor];
    [self.tutorialScrollView addSubview:firstView];
    
    DiscoverViewController *discoverView = [[DiscoverViewController alloc] initWithNibName:@"DiscoverViewController" bundle:nil];
    discoverView.view.frame = CGRectMake(screenWidth, 0.0, screenWidth, discoverView.view.bounds.size.height);
    UIView *clearView = [[UIView alloc] init];
    clearView.backgroundColor = [UIColor clearColor];
    clearView.frame = CGRectMake(screenWidth, 0.0, screenWidth, discoverView.view.bounds.size.height);
    [self.tutorialScrollView addSubview:discoverView.view];
    [self.tutorialScrollView addSubview:clearView];
    
    SuggestedStoresViewController *suggestedStoreView = [[SuggestedStoresViewController alloc] initWithNibName:@"SuggestedStoresViewController" bundle:nil];
    suggestedStoreView.view.frame = CGRectMake(screenWidth * 2, 0.0, screenWidth, screenHeight);
    [self.tutorialScrollView addSubview:suggestedStoreView.view];
    
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
    if (fractionalPage == 1.0) {
        self.tutorialScrollView.pagingEnabled = NO;
    }
    else {
        self.tutorialScrollView.pagingEnabled = YES;
    }
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
    NSLog(@"This is the current page: %i", (int) page);
  
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
