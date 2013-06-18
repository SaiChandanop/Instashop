//
//  HomeViewController.m
//  Instashop
//
//  Created by Josh Klobe on 6/3/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "HomeViewController.h"
#import "AppRootViewController.h"
#import "UserAPIHandler.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize parentController;
@synthesize theScrollView;

@synthesize sellerLabel;
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

    
    self.theScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.theScrollView];
        
    self.theScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 568);
    
    
    [self loadStates];
}


-(void)loadStates
{
 
    if ([InstagramUserObject getStoredUserObject].zencartID == nil)
        self.sellerLabel.text = @"Become a seller";
    else
        self.sellerLabel.text = @"Sell a product";
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  36;
}


-(IBAction) sellerButtonHit
{
    if ([InstagramUserObject getStoredUserObject].zencartID == nil)
        [UserAPIHandler makeUserCreateSellerRequestWithDelegate:self withInstagramUserObject:[InstagramUserObject getStoredUserObject]];
    else
        [self.parentController createProductButtonHit];
}

-(void)userDidCreateSellerWithResponseDictionary:(NSDictionary *)dictionary
{
    NSLog(@"userDidCreateSellerWithResponseDictionary!!: %@", dictionary);
    
    InstagramUserObject *theUserObject =[InstagramUserObject getStoredUserObject];
    theUserObject.zencartID = [dictionary objectForKey:@"zencart_id"];
    
    [[InstagramUserObject getStoredUserObject] setAsStoredUser:theUserObject];

    
    [self loadStates];
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Great"
                                                        message:@"And now you're a seller"
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    
    [alertView show];

    

    
}


@end
