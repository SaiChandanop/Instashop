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
#import "BuyViewController.h"
#import "AppDelegate.h"

@interface PurchasingViewController ()

@end

@implementation PurchasingViewController

@synthesize parentController;
@synthesize contentScrollView;
@synthesize purchasingObject;
@synthesize imageView, titleLabel, sellerLabel, descriptionTextView, priceLabel, numberAvailableLabel, sellerProfileImageView;

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
    
    self.contentScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height * 2);
    self.contentScrollView.backgroundColor = [UIColor clearColor];

    
    NSLog(@"purchasing object: %@", purchasingObject);
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", [self.purchasingObject objectForKey:@"owner_instagram_id"]], @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    self.numberAvailableLabel.text = [NSString stringWithFormat:@"%d left", [[self.purchasingObject objectForKey:@"products_quantity"] intValue]];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setAlwaysShowsDecimalSeparator:YES];
    [numberFormatter setMaximumFractionDigits:2];
    
    self.priceLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[self.purchasingObject objectForKey:@"products_price"] floatValue]]];
   
}

- (void)request:(IGRequest *)request didLoad:(id)result {
    
    NSLog(@"Instagram did load: %@", result);
    
    NSDictionary *metaDictionary = [result objectForKey:@"meta"];
    if ([[metaDictionary objectForKey:@"code"] intValue] == 200)
    {
        NSDictionary *dataDictionary = [result objectForKey:@"data"];
        self.sellerLabel.text = [dataDictionary objectForKey:@"username"];
        [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[dataDictionary objectForKey:@"profile_picture"] withImageView:self.sellerProfileImageView];
    }
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
    
    BuyViewController *buyViewController = [[BuyViewController alloc] initWithNibName:@"BuyViewController" bundle:nil];
    buyViewController.view.frame = CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:buyViewController.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.456];
    buyViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    buyViewController.contentScrollView.contentSize = CGSizeMake(0, buyViewController.view.frame.size.height * 2);
}
@end
