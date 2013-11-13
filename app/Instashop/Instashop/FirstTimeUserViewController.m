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
#define kButtonHeight 100.0

@implementation FirstTimeUserViewController

@synthesize tutorialScrollView;
@synthesize pageControl;
@synthesize loginTutorialDone;
@synthesize parentViewController;
@synthesize suggestedStoresViewController;
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
    
    // Scroll View
    self.tutorialScrollView = [[UIScrollView alloc] initWithFrame:screenBound];
    self.tutorialScrollView.pagingEnabled = YES;
    self.tutorialScrollView.showsHorizontalScrollIndicator = NO;
    self.tutorialScrollView.backgroundColor = [UIColor blackColor];\
    self.tutorialScrollView.bounces = NO;  // Empty side view

    // Next Button
    float buttonPosition = 515.0; // Change this number to change the button position.
    UIColor *textColor = [UIColor colorWithRed:70.0 green:70.0 blue:70.0 alpha:1.0];
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, buttonPosition, screenWidth, screenHeight - buttonPosition)];
    [self.nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    self.nextButton.titleLabel.textColor = textColor;
    self.nextButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.nextButton.titleLabel.font = [UIFont fontWithName:@"Helvetica Neue Light" size:3.0];
    [self.nextButton setBackgroundColor:[ISConstants getISGreenColor]];
    [self.nextButton addTarget:self action:@selector(moveScrollView) forControlEvents:UIControlEventTouchUpInside];
    
    // Needs to be less than bound height to disable vertical scrolling.
    self.tutorialScrollView.contentSize = CGSizeMake(screenWidth * kHowToPageNumber, 33.3);
    float howToViewBoundsHeight = self.tutorialScrollView.bounds.size.height;
    
    NSString * firstString = [NSString stringWithFormat:@"Upload products from Instagram and make it easy for your followers to shop"];
    NSString * secondString = [NSString stringWithFormat:@"Receive Notifications after you like a product on Instagram and Shopsy will \n tell you where to buy!"];
    
    NSArray *arrayOfStringLabels = [[NSArray alloc] initWithObjects:firstString, secondString, nil];\
    
    NSArray *arrayOfImages = [[NSArray alloc] initWithObjects:@"Tutorial-Post-Products-Phone.png", @"Tutorial-Notifications-Phone.png", nil];
    
    for (int p = 0; p < arrayOfImages.count; p++) {
        
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
        [view addSubview:label];
        [self.tutorialScrollView addSubview:view];
    }
    
    // SuggestedStoresViewController doesn't load because instagramuserobject is null.
    self.suggestedStoresViewController = [[SuggestedStoresViewController alloc] initWithNibName:@"SuggestedStoresViewController" bundle:nil];
    self.suggestedStoresViewController.view.frame = CGRectMake(screenWidth * 2, 0.0, screenWidth, screenHeight);
    self.suggestedStoresViewController.firstTimeUserViewController = self;
    [self.tutorialScrollView addSubview:self.suggestedStoresViewController.view];
    
    self.tutorialScrollView.delegate = self;
    [self.view addSubview:self.tutorialScrollView];
    [self.view addSubview:self.nextButton];
    
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = self.tutorialScrollView.frame.size.width;
    float fractionalPage = self.tutorialScrollView.contentOffset.x/pageWidth;
    NSInteger page = lround(fractionalPage);
    
    if (page != 2) {
        [self.nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
        self.nextButton.enabled = YES;
        [self.nextButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        [self.nextButton addTarget:self action:@selector(moveScrollView) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.suggestedStoresViewController updateButton];
}

/*
- (void) showCloseTutorialButton {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.loginTutorialDone.frame = CGRectMake(screenWidth * 2, (screenHeight - self.loginTutorialDone.frame.size.height), screenWidth, kButtonHeight);
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
    self.loginTutorialDone.frame = CGRectMake(screenWidth * 2, screenHeight, self.loginTutorialDone.frame.size.width, self.loginTutorialDone.frame.size.height);
    [UIView commitAnimations];
}*/

- (void) moveScrollView {
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    if (self.tutorialScrollView.contentOffset.x < screenWidth * 2) {
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
