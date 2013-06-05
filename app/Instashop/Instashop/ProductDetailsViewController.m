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
    
    NSLog(@"%@!!!!! view did load", self);
    // Do any additional setup after loading the view from its nib.
    
    [self.containerScrollView setContentSize:CGSizeMake(5000,5000)];
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
    
    self.containerScrollView.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50);
    [self.view addSubview:self.containerScrollView];
    self.containerScrollView.contentSize = CGSizeMake(self.view.frame.size.width  * 2, self.view.frame.size.height * 2);
    NSLog(@"self.containerScrollView.contentSize: %@", NSStringFromCGSize(self.containerScrollView.contentSize));
    NSLog(@"scrollingEnabled?: %d", self.containerScrollView.scrollEnabled);
    NSLog(@"scrollview subviews: %@", [self.containerScrollView subviews]);
    NSLog(@"self view subviews: %@", [self.view subviews]);
    
    self.containerScrollView.backgroundColor = [UIColor redColor];
    

//    UIScrollView *aScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.height - 100)];
    self.containerScrollView.backgroundColor = [UIColor blueColor];
    [self.containerScrollView setContentSize:CGSizeMake(5000,5000)];
//    [self.view addSubview:self.containerScrollView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
