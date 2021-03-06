//
//  InstagramShareViewController.m
//  Instashop
//  Used to share a promotional image to Instagram from Shopsy
//  Created by Joel Barron on 1/8/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import "InstagramShareViewController.h"
#import "AppDelegate.h"
@interface InstagramShareViewController ()

@end

@implementation InstagramShareViewController

@synthesize imageViewsArray;
@synthesize currentSelectedIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.imageViewsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.imageViewsArray removeAllObjects];
    
    float xOffset = 10;

    for (int i = 1; i < 5; i++)
    {
        UIImage *theImage = [UIImage imageNamed:[NSString stringWithFormat:@"Instagram-Promo-%d.jpg", i]];
        
        UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, 0, self.theScrollView.frame.size.height, self.theScrollView.frame.size.height)];
        theImageView.image = theImage;
        [self.theScrollView addSubview:theImageView];
        
        xOffset = theImageView.frame.origin.x + theImageView.frame.size.width + 10;
        
        [self.imageViewsArray addObject:theImageView];
    }
    
    self.theScrollView.contentSize = CGSizeMake(xOffset, self.theScrollView.frame.size.height);
    
    // Do any additional setup after loading the view from its nib.
}

-(void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    int index = -1;
    
    float maxVal = 100000;
    for (int i = 0; i < [self.imageViewsArray count]; i++)
    {
        UIImageView *theImageView = [self.imageViewsArray objectAtIndex:i];
        
        float val = fabsf(theImageView.frame.origin.x - self.theScrollView.contentOffset.x);
        if (val < maxVal)
        {
            maxVal = val;
            index = i;
        }

    }
    
    self.currentSelectedIndex = index;
    NSLog(@"self.currentSelectedIndex: %d", self.currentSelectedIndex);
}

-(UIImage *)getSelectedImage
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"Instagram-Promo-%d.jpg", self.currentSelectedIndex+1]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
