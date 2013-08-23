//
//  ProfileViewController.m
//  Instashop
//
//  Created by Josh Klobe on 8/23/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ProfileViewController.h"
#import "AppDelegate.h"
#import "ImageAPIHandler.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

@synthesize profileInstagramID;

@synthesize backgroundImageView;
@synthesize profileImageView;
@synthesize usernameLabel;
@synthesize followersLabel;
@synthesize followingLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", self.profileInstagramID], @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    
    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@/media/recent", self.profileInstagramID], @"method", @"-1", @"count", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    
}


- (void)request:(IGRequest *)request didLoad:(id)result {
    
    
    NSDictionary *metaDictionary = [result objectForKey:@"meta"];
    if ([[metaDictionary objectForKey:@"code"] intValue] == 200)
    {
        if ([request.url rangeOfString:@"media"].length > 0)
        {
            NSDictionary *dataDictionary = [[result objectForKey:@"data"] objectAtIndex:0];
            NSDictionary *imagesDictionary = [dataDictionary objectForKey:@"images"];
            NSDictionary *standardDictionary = [imagesDictionary objectForKey:@"standard_resolution"];
            [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[standardDictionary objectForKey:@"url"] withImageView:self.backgroundImageView];
        }        
        else if ([request.url rangeOfString:@"users"].length > 0)
        {
            NSDictionary *dataDictionary = [result objectForKey:@"data"];
            self.usernameLabel.text = [dataDictionary objectForKey:@"username"];
            [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[dataDictionary objectForKey:@"profile_picture"] withImageView:self.profileImageView];
            
            NSDictionary *countsDictionary = [dataDictionary objectForKey:@"counts"];
            self.followersLabel.text = [NSString stringWithFormat:@"%d", [[countsDictionary objectForKey:@"followed_by"] integerValue]];
            self.followingLabel.text = [NSString stringWithFormat:@"%d", [[countsDictionary objectForKey:@"follows"] integerValue]];
        }
        
    }
    
    
    
    
}
- (void)viewDidLoad
{
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
