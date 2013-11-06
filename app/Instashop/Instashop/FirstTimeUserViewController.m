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
    
    //    CGFloat whiteSpace = 11.0f;
    //CGFloat topSpace = 64.0f;
    
    // Scroll View
    self.tutorialScrollView = [[UIScrollView alloc] initWithFrame:screenBound];
    self.tutorialScrollView.pagingEnabled = YES;
    self.tutorialScrollView.showsHorizontalScrollIndicator = NO;
    self.tutorialScrollView.backgroundColor = [UIColor blackColor];\
    self.tutorialScrollView.bounces = NO;  // Empty side view
    
    // Needs to be less than bound height to disable vertical scrolling.
    self.tutorialScrollView.contentSize = CGSizeMake(screenWidth * kHowToPageNumber, 33.3);
    float howToViewBoundsHeight = self.tutorialScrollView.bounds.size.height;
    
    NSString * firstString = [NSString stringWithFormat:@"Upload products from Instagram and make it easy for your followers \n to shop"];
    NSString * secondString = [NSString stringWithFormat:@"Receive Notifications after you like \n a product on Instagram and Shopsy \n will tell you where to buy!"];
    
    NSArray *arrayOfStringLabels = [[NSArray alloc] initWithObjects:firstString, secondString, nil];
    
    float buttonPosition = 515.0; // Change this number to change the button position.
    
    NSArray *arrayOfImages = [[NSArray alloc] initWithObjects:@"Tutorial-Post-Products-Phone.png", @"Tutorial-Notifications-Phone.png", nil];
    
    UIColor *textColor = [UIColor colorWithRed:70.0 green:70.0 blue:70.0 alpha:1.0];
    
    for (int p = 0; p < arrayOfImages.count; p++) {
        
        UIButton *greenButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, buttonPosition, screenWidth, screenHeight - buttonPosition)];
        [greenButton setTitle:@"NEXT" forState:UIControlStateNormal];
        greenButton.titleLabel.textColor = textColor;
        greenButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        greenButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:13.0];
        [greenButton setBackgroundColor:[ISConstants getISGreenColor]];
        [greenButton addTarget:self action:@selector(moveScrollView) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth, 150.0)];
        label.text = [arrayOfStringLabels objectAtIndex:p];
        label.font = [UIFont fontWithName:@"Helvetica Neue Light" size:1.0];
        label.textColor = textColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 3;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(p * screenWidth, 0.0, screenWidth, screenHeight)];
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightMenuBG.png"]];
        [view addSubview:backgroundImage];
        UIImage *image = [UIImage imageNamed:[arrayOfImages objectAtIndex:p]];
        int yPosition = 120.0; // change yPosition to position the iPhone image.
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, yPosition, screenWidth, screenHeight)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        
        [imageView setImage:image];
        [view addSubview:imageView];
        [view addSubview:greenButton];
        [view addSubview:label];
        [self.tutorialScrollView addSubview:view];
    }

    /*
    DiscoverViewController *discoverView = [[DiscoverViewController alloc] initWithNibName:@"DiscoverViewController" bundle:nil];
    discoverView.view.frame = CGRectMake(screenWidth, 0.0, screenWidth, screenHeight);
    [self.tutorialScrollView addSubview:discoverView.view];*/
    
    SuggestedStoresViewController *suggestedStoreView = [[SuggestedStoresViewController alloc] initWithNibName:@"SuggestedStoresViewController" bundle:nil];
    suggestedStoreView.view.frame = CGRectMake(screenWidth * 2, 0.0, screenWidth, screenHeight);
    [self.tutorialScrollView addSubview:suggestedStoreView.view];
    
    /*
    for (int p = arrayOfImages.count; p <= kHowToPageNumber; p++) {
        if (p == kHowToPageNumber) {
            UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(p * screenWidth, 0.0, screenWidth, screenHeight)];
            UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightMenuBG.png"]];
            [rightView addSubview:backgroundImage];
            [self.tutorialScrollView addSubview:rightView];
        
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
        
    }*/
    
    
    self.tutorialScrollView.delegate = self;
    [self.view addSubview:self.tutorialScrollView];
    
    // Page Control
    
    /*
    self.pageControl = [[UIPageControl alloc] init];
    float pageControlHeight = 50.0;
    self.pageControl.frame = CGRectMake(0.0, screenHeight - pageControlHeight, screenWidth, pageControlHeight);
    self.pageControl.numberOfPages = kHowToPageNumber;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor redColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    [self.view addSubview:pageControl];*/
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.tutorialScrollView.frame.size.width;
    float fractionalPage = self.tutorialScrollView.contentOffset.x/pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
}

- (void) moveScrollView {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    NSLog(@"Hey you're supposed to move to the next slide!");
    [self.tutorialScrollView setContentOffset:CGPointMake(self.tutorialScrollView.contentOffset.x + screenWidth, 0) animated:YES];
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
