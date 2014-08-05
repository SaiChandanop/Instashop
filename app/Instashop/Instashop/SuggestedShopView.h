//
//  SuggestedShopView.h
//  Instashop
//
//  Created by Josh Klobe on 9/1/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGRequest.h"

@class SuggestedStoresViewController;

@interface SuggestedShopView : UIView <IGRequestDelegate>
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
-(void) makeIGContentRequest;

@property (nonatomic, strong) SuggestedStoresViewController *parentController;
@property (nonatomic, strong) NSString *shopViewInstagramID;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *bioLabel;
@property (nonatomic, strong) IBOutlet UIImageView *theBackgroundImageView;
@property (nonatomic, strong) IBOutlet UIImageView *profileImageView;
@property (nonatomic, strong) IBOutlet UIButton *followButton;


@end
