//
//  AuthenticationViewController.h
//  Instashop
//
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Instagram.h"
#import "SellerExistsResponderProtocol.h"
@interface AuthenticationViewController : UIViewController <IGSessionDelegate, IGRequestDelegate, UIWebViewDelegate, SellerExistsResponderProtocol>
{
    UIWebView *loginWebView;
    
    UIViewController *instagramLoginWebViewController;
    UILabel *backLabel;
    UIButton *backButton;
    
    UIView *iphoneShortView;
}


-(IBAction) loginButtonHit;
-(IBAction) downloadButtonHit;

-(void)makeLoginRequestWithURL:(NSURL *)theURL;

@property (nonatomic, retain) UIWebView *loginWebView;

@property (nonatomic, retain) UIViewController *instagramLoginWebViewController;
@property (nonatomic, retain) UILabel *backLabel;
@property (nonatomic, retain) UIButton *backButton;

@property (nonatomic, retain) IBOutlet UIView *iphoneShortView;

@end
