//
//  PurchasingCompleteViewController.m
//  Instashop
//
//  Created by Josh Klobe on 7/17/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "PurchasingCompleteViewController.h"
#import "AppDelegate.h"
@interface PurchasingCompleteViewController ()

@end

@implementation PurchasingCompleteViewController

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


+(void)presentWithProductObject:(NSDictionary *)productObject
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    AppRootViewController *rootVC = delegate.appRootViewController;
    
    PurchasingCompleteViewController *vc = [[PurchasingCompleteViewController alloc] initWithNibName:@"PurchasingCompleteViewController" bundle:nil];

    
    UIView *shaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0, vc.view.frame.size.width, vc.view.frame.size.height)];
    shaderView.backgroundColor = [UIColor blackColor];
    shaderView.alpha = .45;
    
    [vc.view insertSubview:shaderView atIndex:0];
    [rootVC.view addSubview:vc.view];
}

@end
