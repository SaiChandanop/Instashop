//
//  AuthenticationViewController.h
//  Instashop
//
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Instagram.h"

@interface AuthenticationViewController : UIViewController <IGSessionDelegate, IGRequestDelegate>
{
    UIWebView *loginWebView;
}


-(IBAction) loginButtonHit;
-(IBAction) downloadButtonHit;

-(void)makeLoginRequestWithURL:(NSURL *)theURL;

@property (nonatomic, retain) UIWebView *loginWebView;
@end
