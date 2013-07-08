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
#import "AppDelegate.h"
#import "STPCard.h"
#import "StripeAuthenticationHandler.h"
#import "ProductAPIHandler.h"

@interface PurchasingViewController ()

@property (nonatomic, retain) NSDictionary *requestedProductObject;

@end

@implementation PurchasingViewController

@synthesize requestingProductID;
@synthesize parentController;
@synthesize contentScrollView;
@synthesize requestedProductObject;
@synthesize imageView, titleLabel, sellerLabel, descriptionTextView, priceLabel, numberAvailableLabel, sellerProfileImageView;
@synthesize bottomView;

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

    self.contentScrollView.contentSize = CGSizeMake(0, self.view.frame.size.height * 2);
    self.contentScrollView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.bottomView];
    [self.view bringSubviewToFront:self.bottomView];
    
    
    [ProductAPIHandler getProductWithID:requestingProductID withDelegate:self];
    
}

- (void) loadContentViews
{
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[self.requestedProductObject objectForKey:@"products_url"] withImageView:self.imageView];
    
    self.titleLabel.text = [self.requestedProductObject objectForKey:@"products_name"];
    self.descriptionTextView.text = [self.requestedProductObject objectForKey:@"products_description"];
    
    
    
    NSLog(@"requestedProductObject: %@", self.requestedProductObject);
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", [self.requestedProductObject objectForKey:@"owner_instagram_id"]], @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    self.numberAvailableLabel.text = [NSString stringWithFormat:@"%d left", [[self.requestedProductObject objectForKey:@"products_quantity"] intValue]];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setAlwaysShowsDecimalSeparator:YES];
    [numberFormatter setMaximumFractionDigits:2];
    
    self.priceLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[[self.requestedProductObject objectForKey:@"products_price"] floatValue]]];
 
    

}

- (void)request:(IGRequest *)request didLoad:(id)result {
    
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
    NSLog(@"requestedProductObject: %@", requestedProductObject);
/*    STPCard *stripeCard = [[STPCard alloc] init];
    stripeCard.number = @"4242424242424242";
    stripeCard.expMonth = 05;
    stripeCard.expYear = 15;
    stripeCard.cvc = @"123";
    stripeCard.name = @"alchemy50";
    stripeCard.addressLine1 = @"20 Jay Street #934";
    stripeCard.addressZip = @"11201";
    stripeCard.addressCity = @"Brooklyn";
    stripeCard.addressState = @"NY";
    stripeCard.addressCountry = @"KINGS";
    
    [StripeAuthenticationHandler createTokenWithCard:stripeCard withDelegate:self];
    
  */  
    
}

-(void)doBuy
{
    NSString *stripeToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"StripeToken"];
    
    float val = [[self.requestedProductObject objectForKey:@"products_price"] floatValue];
    
    val = val * 100;
    int intVal = [[NSNumber numberWithFloat:val] integerValue];
    NSString *priceString = [NSString stringWithFormat:@"%d", intVal];
    
    NSString *zencartProductID = [NSString stringWithFormat:@"product_id: %@", [requestedProductObject objectForKey:@"product_id"]];
    [StripeAuthenticationHandler buyItemWithToken:stripeToken withPurchaseAmount:priceString withDescription:zencartProductID withDelegate:self];
    
}

-(void)buySuccessfulWithDictionary:(id)theDict
{
    NSLog(@"theDict: %@", theDict);
    [ProductAPIHandler productPurchasedWithDelegate:self withStripeDictionary:theDict withProductObject:self.requestedProductObject];
    
}

-(void)feedRequestFinishedWithArrray:(NSArray *)theArray
{
    if ([theArray count] > 0)
        self.requestedProductObject = [theArray objectAtIndex:0];
    
    [self loadContentViews];
}

@end
