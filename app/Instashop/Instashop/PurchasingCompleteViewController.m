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

@synthesize shaderView;

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

    
    vc.shaderView = [[UIView alloc] initWithFrame:CGRectMake(0,0, vc.view.frame.size.width, vc.view.frame.size.height)];
    vc.shaderView.backgroundColor = [UIColor blackColor];
    vc.shaderView.alpha = .45;
    
    [vc.view insertSubview:vc.shaderView atIndex:0];
    [rootVC.view addSubview:vc.view];
    
    UIButton *someButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [someButton addTarget:vc action:@selector(xButtonHit:) forControlEvents:UIControlEventTouchUpInside];
    someButton.frame = CGRectMake(0, 0, rootVC.view.frame.size.width, rootVC.view.frame.size.height);
    [rootVC.view addSubview:someButton];
    
    rootVC.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@""
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];
    
}

-(IBAction)xButtonHit
{
    [self.view removeFromSuperview];
}

-(IBAction)xButtonHit:(UIButton *)sender
{
    [sender removeFromSuperview];
    [self.view removeFromSuperview];
}

@end
