//
//  ProductCreateViewController.h
//  Instashop
//
//  Created by Josh Klobe on 5/28/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductSelectTableViewController.h"
#import "ProductDetailsViewController.h"

@interface ProductCreateViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate>
{
    ProductSelectTableViewController *productSelectTableViewController;
    ProductDetailsViewController *productDetailsViewController;
    
    
}

-(void)productDetailsViewControllerBackButtonHit;
-(void)tableViewProductSelectedWithDataDictionary:(NSDictionary *)theInstagramInfoDictionary;


- (IBAction) exitButtonHit;
- (IBAction) goButtonHit;

@property (nonatomic, retain) IBOutlet ProductSelectTableViewController *productSelectTableViewController;
@property (nonatomic, retain) IBOutlet ProductDetailsViewController *productDetailsViewController;

@property (nonatomic, retain) NSDictionary *productDictionary;
@end
