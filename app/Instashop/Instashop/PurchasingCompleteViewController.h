//
//  PurchasingCompleteViewController.h
//  Instashop
//
//  Created by Josh Klobe on 7/17/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PurchasingCompleteViewController : UIViewController
{
    UIView *shaderView;
}

@property (nonatomic, retain) UIView *shaderView;
+(void)presentWithProductObject:(NSDictionary *)productObject;
-(IBAction)xButtonHit;
@end
