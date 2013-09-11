//
//  FirstTimeUserViewController.m
//  Instashop
//
//  Created by Susan Yee on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "FirstTimeUserViewController.h"
#import "AppDelegate.h"

@interface FirstTimeUserViewController ()

@end

#define kHowToPageNumber 4

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
    self.tutorialScrollView.backgroundColor = [UIColor blackColor];
    int arbitraryNumberSmallerThanBoundHeight = 33.0;
    // Needs to be less than bound height to disable vertical scrolling.
    self.tutorialScrollView.contentSize = CGSizeMake(screenWidth * 4, arbitraryNumberSmallerThanBoundHeight);
    float howToViewBoundsHeight = self.tutorialScrollView.bounds.size.height;
    
    // Maybe you want a left view so that the previous menu can't be seen.
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(-320.0, 0.0, screenWidth, howToViewBoundsHeight)];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightMenuBG.png"]];
    [leftView addSubview:backgroundImage];
    [self.tutorialScrollView addSubview:leftView];
    
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
            [self.tutorialScrollView addSubview:rightView];
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
            [signUpButton addTarget:self action:@selector(closeTutorial) forControlEvents:UIControlEventTouchUpInside];
            [tutorialView addSubview:signUpButton];
        }
    }
    
    
    self.tutorialScrollView.delegate = self;
    [self.view addSubview:self.tutorialScrollView];
    
    // Page Control
    self.pageControl = [[UIPageControl alloc] init];
    float pageControlHeight = 50.0;
    self.pageControl.frame = CGRectMake(0.0, screenHeight - 66 - pageControlHeight, screenWidth, pageControlHeight);
    self.pageControl.numberOfPages = kHowToPageNumber;
    self.pageControl.currentPage = 0;
    self.pageControl.pageIndicatorTintColor = [UIColor redColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    [self.view addSubview:pageControl];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.tutorialScrollView.frame.size.width;
    float fractionalPage = self.tutorialScrollView.contentOffset.x/pageWidth;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
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
