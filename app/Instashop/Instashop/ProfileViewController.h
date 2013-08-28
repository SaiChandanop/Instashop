//
//  ProfileViewController.h
//  Instashop
//
//  Created by Josh Klobe on 8/23/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IGRequest.h"
#import "FeedRequestFinishedProtocol.h"
#import "ProductSelectTableViewController.h"
#import "CellSelectionOccuredProtocol.h"
#import "GKImagePicker.h"

@interface ProfileViewController : UIViewController <IGRequestDelegate, CellSelectionOccuredProtocol, UINavigationControllerDelegate, UIImagePickerControllerDelegate, GKImagePickerDelegate>
{
    NSString *profileInstagramID;
    
    UIButton *addBackgroundImageButton;
    UIImageView *backgroundImageView;
    UIImageView *profileImageView;
    UILabel *usernameLabel;
    
    UIButton *followersButton;
    UIButton *followingButton;
    
    UIView *sellerButtonsView;
    UIView *buyerButtonsView;
    UIButton *buyerFavoritesButton;
    UIButton *sellerProductsButton;
    UIButton *sellerInfoButton;
    UIButton *sellerReviewsButton;
    UIView *sellerButtonHighlightView;
    UIView *buyerButtonHighlightView;
    UIView *infoView;
    UITextView *bioTextView;
    
    ProductSelectTableViewController *productSelectTableViewController;
    UITableView *theTableView;
    
    UILabel *titleViewLabel;
    
    BOOL isSelfProfile;
    
    
    
}

-(void)loadNavigationControlls;
-(IBAction) imagePickButtonHit;

-(IBAction) productsButtonHit;
-(IBAction) infoButtonHit;
-(IBAction) reviewsButtonHit;

@property (nonatomic, retain) NSString *profileInstagramID;

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UIButton *addBackgroundImageButton;

@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;

@property (nonatomic, retain) IBOutlet UIButton *followersButton;
@property (nonatomic, retain) IBOutlet UIButton *followingButton;

@property (nonatomic, retain) IBOutlet UIView *sellerButtonsView;
@property (nonatomic, retain) IBOutlet UIView *buyerButtonsView;
@property (nonatomic, retain) IBOutlet UIButton *buyerFavoritesButton;
@property (nonatomic, retain) IBOutlet UIButton *sellerProductsButton;
@property (nonatomic, retain) IBOutlet UIButton *sellerInfoButton;
@property (nonatomic, retain) IBOutlet UIButton *sellerReviewsButton;
@property (nonatomic, retain) IBOutlet UIView *sellerButtonHighlightView;
@property (nonatomic, retain) IBOutlet UIView *buyerButtonHighlightView;
@property (nonatomic, retain) IBOutlet UIView *infoView;
@property (nonatomic, retain) IBOutlet UITextView *bioTextView;

@property (nonatomic, retain) IBOutlet ProductSelectTableViewController *productSelectTableViewController;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;

@property (nonatomic, retain) UILabel *titleViewLabel;

@property (nonatomic, assign) BOOL isSelfProfile;
@end
