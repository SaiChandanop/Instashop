//
//  InstagramShareViewController.m
//  Instashop
//
//  Created by Joel Barron on 1/8/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import "InstagramShareViewController.h"
#import "AppDelegate.h"
@interface InstagramShareViewController ()

@end

@implementation InstagramShareViewController

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
    
    float xOffset = 10;

    for (int i = 1; i < 6; i++)
    {
        UIImage *theImage = [UIImage imageNamed:[NSString stringWithFormat:@"Instagram-Promo-%d", i]];
        
        UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, 0, self.theScrollView.frame.size.height, self.theScrollView.frame.size.height)];
        theImageView.image = theImage;
        [self.theScrollView addSubview:theImageView];
        
        xOffset = theImageView.frame.origin.x + theImageView.frame.size.width + 10;
    }
    
    self.theScrollView.contentSize = CGSizeMake(xOffset, self.theScrollView.frame.size.height);

    
    
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
