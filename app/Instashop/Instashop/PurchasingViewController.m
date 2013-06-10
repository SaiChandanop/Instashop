//
//  PurchasingViewController.m
//  Instashop
//
//  Created by Josh Klobe on 6/10/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "PurchasingViewController.h"
#import "ImageAPIHandler.h"
#import "FeedViewController.h"
@interface PurchasingViewController ()

@end

@implementation PurchasingViewController

@synthesize parentController;
@synthesize contentScrollView;
@synthesize purchasingObject;
@synthesize imageView, titleLabel, sellerLabel, descriptionTextView, priceLabel, numberAvailableLabel;

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
    
    
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[self.purchasingObject objectForKey:@"products_url"] withImageView:self.imageView];
    
    self.titleLabel.text = [self.purchasingObject objectForKey:@"products_name"];
    self.descriptionTextView.text = [self.purchasingObject objectForKey:@"products_description"];
    
//    , sellerLabel, , priceLabel, numberAvailableLabel;
    
    
    self.contentScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height * 2);
    self.contentScrollView.backgroundColor = [UIColor clearColor];

}


-(IBAction)backButtonHit
{
    [self.parentController purchasingViewControllerBackButtonHitWithVC:self];
    NSLog(@"backButtonHit");
}

-(IBAction)buyButtonHit
{
    self.contentScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height * 2);
    NSLog(@"buyButtonHit");
}
@end
