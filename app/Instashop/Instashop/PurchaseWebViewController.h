//
//  PurchaseWebViewController.h
//  Instashop
//
//  Created by Josh Klobe on 10/1/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchaseWebViewController : UIViewController
{
    id delegate;
    NSString *theURLString;
    
    UIWebView *theWebView;
    UISearchBar *webSearchBar;
}

-(void)loadWithURLString:(NSString *)theString;
-(IBAction)backButtonHit;

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSString *theURLString;

@property (nonatomic, retain) IBOutlet UIWebView *theWebView;
@property (nonatomic, retain) IBOutlet UISearchBar *webSearchBar;



@end
