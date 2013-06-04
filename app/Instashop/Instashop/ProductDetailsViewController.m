//
//  ProductDetailsViewController.m
//  Instashop
//
//  Created by Josh Klobe on 6/4/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "ImageAPIHandler.h"
#import "ProductCreateViewController.h"

@interface ProductDetailsViewController ()

@end

@implementation ProductDetailsViewController

@synthesize parentController, containerScrollView, productImageView;


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
    // Do any additional setup after loading the view from its nib.
}


-(IBAction)backButtonHit
{
    [parentController productDetailsViewControllerBackButtonHit];
}

- (void) loadViewsWithInstagramInfoDictionary:(NSDictionary *)theDictionary
{    
    NSDictionary *imagesDictionary = [theDictionary objectForKey:@"images"];
    NSDictionary *startResultionDictionary = [imagesDictionary objectForKey:@"standard_resolution"];
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[startResultionDictionary objectForKey:@"url"] withImageView:self.productImageView];
    
    
    NSLog(@"self.containerScrollView.contentSize: %@", NSStringFromCGSize(self.containerScrollView.contentSize));
    NSLog(@"scrollingEnabled?: %d", self.containerScrollView.scrollEnabled);
    NSLog(@"subviews: %@", [self.containerScrollView subviews]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
