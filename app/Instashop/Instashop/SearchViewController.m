//
//  SearchViewController.m
//  Instashop
//
//  Created by Josh Klobe on 9/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchAPIHandler.h"
#import "ISConstants.h"
#import "NavBarTitleView.h"
#import "AppRootViewController.h"
#import "PurchasingViewController.h"
#import "ProfileViewController.h"
#import "AttributesManager.h"
#import "SearchButtonContainer.h"

@interface SearchViewController ()


@end

@implementation SearchViewController

@synthesize appRootViewController;
@synthesize shopsButton;
@synthesize productsButton;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.translucent = NO;

    UIView *cancelCustomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 44, 44)];
    
    UIImageView *cancelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"closebutton_white.png"]];
    cancelImageView.frame = CGRectMake(0,0,44,44);
    [cancelCustomView addSubview:cancelImageView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0,0,cancelCustomView.frame.size.width, cancelCustomView.frame.size.height);
    cancelButton.backgroundColor = [UIColor clearColor];
    [cancelButton addTarget:self action:@selector(backButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [cancelCustomView addSubview:cancelButton];
    
    UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelCustomView];
    self.navigationItem.leftBarButtonItem = cancelBarButtonItem;
    
    [self.navigationItem setTitleView:[NavBarTitleView getTitleViewWithTitleString:@"SEARCH"]];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    self.highlightView.backgroundColor = [ISConstants getISGreenColor];
    
    
    self.productSearchViewController = [[SearchSiloViewController alloc] initWithNibName:@"SearchSiloViewController" bundle:nil];
    self.productSearchViewController.view.frame = CGRectMake(0, self.highlightView.frame.origin.y + self.highlightView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - (self.highlightView.frame.origin.y + self. self.highlightView.frame.size.height));
    [self.view addSubview:self.productSearchViewController.view];
    
    
                                                             
}

-(void)backButtonHit
{
//    [self.theSearchBar resignFirstResponder];
    [self.appRootViewController searchExitButtonHit:self.navigationController];
}

-(void)moveHighlightToButton:(UIButton *)theButton
{
    float transitionTime = .15;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:transitionTime];
    [UIView setAnimationDelegate:self];
    self.highlightView.frame = CGRectMake(theButton.frame.origin.x, self.highlightView.frame.origin.y, theButton.frame.size.width, self.highlightView.frame.size.height);
    [UIView commitAnimations];

    self.shopsButton.selected = NO;
    self.productsButton.selected = NO;
    
    theButton.selected = YES;
}

-(IBAction)shopsButtonHit:(UIButton *)theButton
{
    [self moveHighlightToButton:theButton];
//    [self.productContainerView removeFromSuperview];
}

-(IBAction)productsButtonHit:(UIButton *)theButton
{
//    if ([self.productContainerView superview] == nil)
//        [self.view addSubview:self.productContainerView];
    [self moveHighlightToButton:theButton];
         
}





-(int)getCurrentlySelectedTab
{
    int retVal = -1;
    if (self.shopsButton.selected)
        retVal = 0;
    else if (self.productsButton.selected)
        retVal = 1;

    
    return retVal;
}



@end
