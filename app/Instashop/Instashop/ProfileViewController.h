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
#import "SellerDetailResponseProtocol.h"
#import "ISDarkRowContainerView.h"

@interface ProfileViewController : UIViewController <IGRequestDelegate, CellSelectionOccuredProtocol, UINavigationControllerDelegate, UIImagePickerControllerDelegate, GKImagePickerDelegate, SellerDetailResponseProtocol>
{
    NSString *profileInstagramID;
    
    UIButton *addBackgroundImageButton;
    UIImageView *backgroundImageView;
    UIImageView *profileImageView;
    UILabel *usernameLabel;
    
    UIButton *followersButton;
    UIButton *followingButton;
    
    UIButton *followButton;
    
    UIView *sellerButtonsView;
    UIView *buyerButtonsView;
    
    UIButton *buyerFavoritesButton;
    UIButton *infoButton;
    UIButton *reviewsButton;
    
    UIButton *sellerProductsButton;
    UIButton *sellerInfoButton;
    UIButton *sellerReviewsButton;
    
    UIButton *profileBackgroundPhotoButton;
    UIView *sellerButtonHighlightView;
    UIView *buyerButtonHighlightView;
    
    
    ProductSelectTableViewController *productSelectTableViewController;
    UITableView *theTableView;
    UILabel *titleViewLabel;
    
    UIScrollView *infoContainerScrollView;
    UILabel *addressLabel;
    UILabel *emailLabel;
    UILabel *categoryLabel;
    UIImageView *bioContainerImageView;
    UILabel *bioLabel;
    UILabel *descriptionLabel;
    
    BOOL isSelfProfile;
    NSDictionary *requestedInstagramProfileObject;
    
}

-(void)loadNavigationControlls;
-(IBAction) imagePickButtonHit;

-(IBAction) productsButtonHit;
-(IBAction) infoButtonHit;
-(IBAction) reviewsButtonHit;

-(IBAction)followOnInstagramButtonHit;

@property (nonatomic, retain) NSString *profileInstagramID;

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UIButton *addBackgroundImageButton;

@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;

@property (nonatomic, retain) IBOutlet UIButton *followersButton;
@property (nonatomic, retain) IBOutlet UIButton *followingButton;

@property (nonatomic, retain) IBOutlet UIButton *followButton;

@property (nonatomic, retain) IBOutlet UIView *sellerButtonsView;
@property (nonatomic, retain) IBOutlet UIView *buyerButtonsView;
@property (nonatomic, retain) IBOutlet UIButton *buyerFavoritesButton;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) IBOutlet UIButton *reviewsButton;

@property (nonatomic, retain) IBOutlet UIButton *sellerProductsButton;
@property (nonatomic, retain) IBOutlet UIButton *sellerInfoButton;
@property (nonatomic, retain) IBOutlet UIButton *sellerReviewsButton;
@property (nonatomic, retain) IBOutlet UIButton *profileBackgroundPhotoButton;
@property (nonatomic, retain) IBOutlet UIView *sellerButtonHighlightView;
@property (nonatomic, retain) IBOutlet UIView *buyerButtonHighlightView;


@property (nonatomic, retain) IBOutlet ProductSelectTableViewController *productSelectTableViewController;
@property (nonatomic, retain) IBOutlet UITableView *theTableView;

@property (nonatomic, retain) UILabel *titleViewLabel;

@property (nonatomic, assign) BOOL isSelfProfile;

@property (nonatomic, retain) NSDictionary *requestedInstagramProfileObject;

@property (nonatomic, retain) IBOutlet UIScrollView *infoContainerScrollView;
@property (nonatomic, retain) IBOutlet UILabel *addressLabel;
@property (nonatomic, retain) IBOutlet UILabel *emailLabel;
@property (nonatomic, retain) IBOutlet UILabel *categoryLabel;
@property (nonatomic, retain) IBOutlet UIImageView *bioContainerImageView;
@property (nonatomic, retain) IBOutlet UILabel *bioLabel;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;



@end
