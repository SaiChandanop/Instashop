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
#import "TPKeyboardAvoidingScrollView.h"

@interface ProfileViewController : UIViewController <UIActionSheetDelegate, IGRequestDelegate, CellSelectionOccuredProtocol, UINavigationControllerDelegate, UIImagePickerControllerDelegate, GKImagePickerDelegate, SellerDetailResponseProtocol>
{
    UIScrollView *enclosingScrollView;
    
    NSString *profileInstagramID;
    
    UIButton *addBackgroundImageButton;
    UIImageView *backgroundImageView;
    UIImageView *profileImageView;
    UILabel *usernameLabel;
    
    UIButton *followersButton;
    UIButton *followingButton;
    
    UIButton *followButton;
    
    
    UIButton *productsButton;
    UIButton *infoButton;
    UIButton *favoritesButton;
    UIView *buttonHighlightView;
    
    UIButton *profileBackgroundPhotoButton;
    
    ProductSelectTableViewController *productSelectTableViewController;
    ProductSelectTableViewController *favoritesSelectTableViewController;
    UITableView *theTableView;
    UILabel *titleViewLabel;
    
    UIScrollView *infoContainerScrollView;
    UILabel *addressLabel;
    UILabel *emailLabel;
    UILabel *categoryLabel;
    UIImageView *bioContainerImageView;
    UILabel *bioLabel;
    UITextView *descriptionTextView;
    
    BOOL isSelfProfile;
    NSDictionary *requestedInstagramProfileObject;
    
    UIButton *imagePickButton;
}

-(void)loadNavigationControlls;
-(IBAction) imagePickButtonHit;
-(IBAction) editButtonHit;
-(IBAction) productsButtonHit;
-(IBAction) infoButtonHit;
-(IBAction) reviewsButtonHit;

-(IBAction)followOnInstagramButtonHit;

@property (nonatomic, retain) IBOutlet UIScrollView *enclosingScrollView;

@property (nonatomic, retain) NSString *profileInstagramID;

@property (nonatomic, retain) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, retain) IBOutlet UIButton *addBackgroundImageButton;

@property (nonatomic, retain) IBOutlet UIImageView *profileImageView;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;

@property (nonatomic, retain) IBOutlet UIButton *followersButton;
@property (nonatomic, retain) IBOutlet UIButton *followingButton;

@property (nonatomic, retain) IBOutlet UIButton *followButton;



@property (nonatomic, retain) IBOutlet UIButton *productsButton;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) IBOutlet UIButton *favoritesButton;
@property (nonatomic, retain) IBOutlet UIView *buttonHighlightView;


@property (nonatomic, retain) IBOutlet UIButton *profileBackgroundPhotoButton;



@property (nonatomic, retain) IBOutlet ProductSelectTableViewController *productSelectTableViewController;
@property (nonatomic, retain) IBOutlet ProductSelectTableViewController *favoritesSelectTableViewController;
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
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, retain) IBOutlet UIButton *editButton;
@property (nonatomic, retain) IBOutlet UIButton *imagePickButton;

@property (nonatomic, assign) BOOL hasAppeared;


@end
