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
#import "CIALBrowserViewController.h"

@interface ProfileViewController : UIViewController <UIActionSheetDelegate, IGRequestDelegate, CellSelectionOccuredProtocol, UINavigationControllerDelegate, UIImagePickerControllerDelegate, GKImagePickerDelegate, SellerDetailResponseProtocol>
{
    ProductSelectTableViewController *theTableViewController;
    
    UIScrollView *enclosingScrollView;
    NSString *profileInstagramID;
    UIButton *addBackgroundImageButton;
    UIImageView *backgroundImageView;
    UIImageView *profileImageView;
    UILabel *usernameLabel;
    UIButton *followButton;
    UIButton *productsButton;
    UIButton *infoButton;
    UIButton *favoritesButton;
    UIView *buttonHighlightView;
    UIButton *profileBackgroundPhotoButton;
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
    GKImagePicker *imagePicker;
    UIView *infoWebContainerView;
    UILabel *webLabel;
    NSString *siteString;
    UIView *followContainerView;
    UIView *sellerContentButtonsView;
    UILabel *followersTextLabel;
    UILabel *followersValueLabel;
    UILabel *followingTextLabel;
    UILabel *followingValueLabel;
    NSMutableDictionary *tableDataDictionary;
    CIALBrowserViewController *cialBrowserViewController;
}

-(void)loadNavigationControlls;
-(IBAction) imagePickButtonHit;
-(IBAction) editButtonHit;
-(IBAction) productsButtonHit;
-(IBAction) infoButtonHit;
-(IBAction) reviewsButtonHit;

-(IBAction)followOnInstagramButtonHit;

- (void)tableViewControllerDidLoadWithController:(ProductSelectTableViewController *)theProductSelectTableViewController;


@property (nonatomic, strong) ProductSelectTableViewController *theTableViewController;
@property (nonatomic, strong) IBOutlet UIScrollView *enclosingScrollView;
@property (nonatomic, strong) NSString *profileInstagramID;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UIButton *addBackgroundImageButton;
@property (nonatomic, strong) IBOutlet UIImageView *profileImageView;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UIButton *followButton;
@property (nonatomic, strong) IBOutlet UIButton *productsButton;
@property (nonatomic, strong) IBOutlet UIButton *infoButton;
@property (nonatomic, strong) IBOutlet UIButton *favoritesButton;
@property (nonatomic, strong) IBOutlet UIView *buttonHighlightView;
@property (nonatomic, strong) IBOutlet UIButton *profileBackgroundPhotoButton;
@property (nonatomic, strong) UILabel *titleViewLabel;
@property (nonatomic, assign) BOOL isSelfProfile;
@property (nonatomic, strong) NSDictionary *requestedInstagramProfileObject;
@property (nonatomic, strong) IBOutlet UIScrollView *infoContainerScrollView;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) IBOutlet UILabel *emailLabel;
@property (nonatomic, strong) IBOutlet UILabel *categoryLabel;
@property (nonatomic, strong) IBOutlet UIImageView *bioContainerImageView;
@property (nonatomic, strong) IBOutlet UILabel *bioLabel;
@property (nonatomic, strong) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, strong) IBOutlet UIButton *editButton;
@property (nonatomic, strong) IBOutlet UIButton *imagePickButton;
@property (nonatomic, assign) BOOL hasAppeared;
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) IBOutlet UIView *infoWebContainerView;
@property (nonatomic, strong) UILabel *webLabel;
@property (nonatomic, strong) NSString *siteString;
@property (nonatomic, strong) IBOutlet UIView *followContainerView;
@property (nonatomic, strong) IBOutlet UIView *sellerContentButtonsView;
@property (nonatomic, strong) IBOutlet UILabel *followersTextLabel;
@property (nonatomic, strong) IBOutlet UILabel *followersValueLabel;
@property (nonatomic, strong) IBOutlet UILabel *followingTextLabel;
@property (nonatomic, strong) IBOutlet UILabel *followingValueLabel;
@property (nonatomic, strong) NSMutableDictionary *tableDataDictionary;
@property (nonatomic, strong) CIALBrowserViewController *cialBrowserViewController;



@end
