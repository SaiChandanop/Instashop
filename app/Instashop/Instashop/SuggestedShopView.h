//
//  SuggestedShopView.h
//  Instashop
//
//  Created by Josh Klobe on 9/1/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SuggestedStoresViewController;

@interface SuggestedShopView : UIView
{
    
    SuggestedStoresViewController *parentController;
    NSString *shopViewInstagramID;
    
    UILabel *titleLabel;
    UILabel *bioLabel;
    UIImageView *theBackgroundImageView;
    UIImageView *profileImageView;
    UIButton *followButton;
}

-(IBAction)followButtonHit;
-(IBAction)viewButtonHit;

@property (nonatomic, retain) SuggestedStoresViewController *parentController;
@property (nonatomic, retain) NSString *shopViewInstagramID;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *bioLabel;
@property (nonatomic, retain) IBOutlet UIImageView *theBackgroundImageView;
@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UIButton *followButton;


@end
