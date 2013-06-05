//
//  ProductCreateViewController.m
//  Instashop
//
//  Created by Josh Klobe on 5/28/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ProductCreateViewController.h"
#import "ProductAPIHandler.h"
#import "AppRootViewController.h"


@interface ProductCreateViewController ()

@end

@implementation ProductCreateViewController

@synthesize productSelectTableViewController, productDetailsViewController;
@synthesize productDictionary;


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
    
    self.productSelectTableViewController.parentController = self;
}

-(void)tableViewProductSelectedWithDataDictionary:(NSDictionary *)theInstagramInfoDictionary
{
    if ([self.productDetailsViewController.view superview] == nil)
    {
        self.productDetailsViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.productDetailsViewController.view.frame.size.width, self.productDetailsViewController.view.frame.size.height);
        [self.view addSubview:self.productDetailsViewController.view];
    }

    self.productDetailsViewController.containerScrollView.contentSize = CGSizeMake(0, 1400);
    self.productDetailsViewController.parentController = self;
    [self.productDetailsViewController loadViewsWithInstagramInfoDictionary:theInstagramInfoDictionary];

    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.456];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.productDetailsViewController.view.frame = CGRectMake(0, 0, self.productDetailsViewController.view.frame.size.width, self.productDetailsViewController.view.frame.size.height);
    [UIView commitAnimations];

}

-(void)vcDidHitBackWithController:(UIViewController *)requestingViewController
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.456];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    requestingViewController.view.frame = CGRectMake(requestingViewController.view.frame.size.width, 0, requestingViewController.view.frame.size.width, requestingViewController.view.frame.size.height);
    [UIView commitAnimations];
}


-(void)previewButtonHitWithProductCreateObject:(ProductCreateObject *)productCreateObject
{
    self.productPreviewViewController = [[ProductPreviewViewController alloc] initWithNibName:@"ProductPreviewViewController" bundle:nil];
    self.productPreviewViewController.parentController = self;
    self.productPreviewViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.productDetailsViewController.view.frame.size.width, self.productDetailsViewController.view.frame.size.height);
    [self.view addSubview:self.productPreviewViewController.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.456];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(ceaseTransition)];
    self.productPreviewViewController.view.frame = CGRectMake(0, 0, self.productDetailsViewController.view.frame.size.width, self.productDetailsViewController.view.frame.size.height);
    [UIView commitAnimations];

    [self.productPreviewViewController loadWithProductCreateObject:productCreateObject];
    
    
}


-(IBAction)exitButtonHit
{
    [[AppRootViewController sharedRootViewController] exitButtonHitWithViewController:self];
}


@end
