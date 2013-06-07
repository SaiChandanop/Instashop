//
//  FeedViewController.m
//  Instashop
//
//  Created by Josh Klobe on 5/31/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "FeedViewController.h"
#import "AppRootViewController.h"


@interface FeedViewController ()

@end

@implementation FeedViewController

@synthesize parentController;
@synthesize headerView;

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


-(IBAction)homeButtonHit
{
        NSLog(@"homeButtonHit");
    [self.parentController homeButtonHit];

}

-(IBAction)notificationsButtonHit
{
    NSLog(@"notificationsButtonHit");
    [self.parentController notificationsButtonHit];
}

-(IBAction)discoverButtonHit
{
      NSLog(@"discoverButtonHit");
    [self.parentController discoverButtonHit];    
}


@end
