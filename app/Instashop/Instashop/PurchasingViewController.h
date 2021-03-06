//
//  PurchasingViewController.h
//  Instashop
//
//  Created by Josh Klobe on 6/10/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InstagramUserObject.h"
#import "SizePickerViewViewController.h"
#import "IGRequest.h"
#import "ISAsynchImageView.h"
#import "FeedRequestFinishedProtocol.h"
#import "EditProductCompleteProtocol.h"
#import "FlagManagerAPIHandler.h"
#import "CIALBrowserViewController.h"
#import "CommentsTableViewController.h"
#import "BitlyResponseHandler.h"
#import "JKProgressView.h"
#import "SearchViewController.h"
#import "AnalyticsReportCompleteProtocol.h"
@class FeedViewController;

@interface PurchasingViewController : UIViewController <IGRequestDelegate, UIActionSheetDelegate, FeedRequestFinishedProtocol, EditProductCompleteProtocol, BitlyResponseHandler, FlagManagerProtocol, AnalyticsReportCompleteProtocol>
{
    SizePickerViewViewController *sizePickerViewViewController;
    CommentsTableViewController *commentsTableViewController;
    NSString *requestingProductID;
    NSDictionary *requestedPostmasterDictionary;
    
    UIImageView *heartImageView;
    UIScrollView *contentScrollView;
    UIImageView *imageView;
    UIView *categoryContainerView;    
    UIImageView *categoryContainerImageView;
    UIImageView *categoryContainerBottomSeparatorImageView;
    UIView *doubleTapView;
    UILabel *sellerLabel;
    UILabel *likesLabel;
    UILabel *listPriceLabel;
    UILabel *retailPriceLabel;
    UIView *descriptionContainerView;
    UITextView *descriptionTextView;
    UILabel *numberAvailableLabel;
    ISAsynchImageView *sellerProfileImageView;
    UIButton *sizeButton;
    UIButton *quantityButton;
    UIButton *purchaseButton;
    UIButton *saveButton;
    int sizeSelectedIndex;
    
    NSArray *likesArray;
        
    UIActionSheet *actionSheet;
    
    UIButton *facebookButton;
    UIButton *twitterButton;
    
    NSString *viglinkString;
    
    UITextField *commentTextField;
    UIButton *commentExitButton;
    
    CIALBrowserViewController *cialBrowserViewController;
    
    BOOL isEditable;
    
    UIViewController *actionSheetHandlingViewController;
    
    BOOL isBuying;
    
    JKProgressView *JKProgressView;
    
    SearchViewController *searchViewControllerDelegate;
    NSArray *searchCategoriesArray;
    
    BOOL descriptionContentSizeSet;
    CGSize descriptionContentSize;
 
    UIView *profileContainerView;
    
    UILabel *buyAnalyticsLabel;
    UILabel *saveAnalyticsLabel;
    NSDictionary *reportDictionary;
    
    
    
    UIView *ownedProfileContainerView;
    
    UILabel *viewsTitleLabel;
    UIImageView *viewsImageView;
    UILabel *viewsValueLabel;
    
    UILabel *shopsyTitleLabel;
    UIImageView *shopsyImageView;
    UILabel *shopsyValueLabel;
    
    UILabel *instagramTitleLabel;
    UIImageView *instagramImageView;
    UILabel *instagramValueLabel;
    
    
}

- (IBAction) likeButtonHit;

- (IBAction) profileButtonHit;
- (IBAction) backButtonHit;
- (IBAction) buyButtonHit;
- (IBAction) sizeButtonHit;
- (IBAction) quantityButtonHit;
- (IBAction) saveButtonHit;
- (void) loadContentViews;
-(void)imageRequestFinished:(UIImageView *)referenceImageView;
-(void)savedItemsCompleted;
-(void)openActionSheetFromCallerController:(UIViewController *)callerController;
- (void)webControllerBackButtonHit;

-(void)commentAddTextShouldBeginEditingWithTextField:(UITextField *)theTextField;
-(void)commentAddTextShouldEndEditing;
-(void)amberSupportedSiteCallFinishedWithIsSupported:(BOOL)isSupported withExpandedURLString:(NSString *)expandedURLString;

@property (nonatomic, strong) SizePickerViewViewController *sizePickerViewViewController;
@property (nonatomic, strong) IBOutlet CommentsTableViewController *commentsTableViewController;
@property (nonatomic, strong) NSString *requestingProductID;
@property (nonatomic, strong) NSDictionary *requestedPostmasterDictionary;

@property (nonatomic, strong) IBOutlet UIImageView *heartImageView;
@property (nonatomic, strong) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) IBOutlet UIView *categoryContainerView;
@property (nonatomic, strong) IBOutlet UIImageView *categoryContainerBottomSeparatorImageView;
@property (nonatomic, strong) IBOutlet UIImageView *categoryContainerImageView;
@property (nonatomic, strong) IBOutlet UIView *doubleTapView;
@property (nonatomic, strong) IBOutlet UILabel *sellerLabel;
@property (nonatomic, strong) IBOutlet UILabel *likesLabel;
@property (nonatomic, strong) IBOutlet UIView *descriptionContainerView;
@property (nonatomic, strong) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, strong) IBOutlet UILabel *listPriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *retailPriceLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberAvailableLabel;
@property (nonatomic, strong) IBOutlet ISAsynchImageView *sellerProfileImageView;
@property (nonatomic, strong) IBOutlet UIButton *sizeButton;
@property (nonatomic, strong) IBOutlet UIButton *quantityButton;
@property (nonatomic, strong) IBOutlet UIButton *saveButton;
@property (nonatomic, strong) IBOutlet UIButton *purchaseButton;
@property (nonatomic, strong) IBOutlet UIView *bottomView;

@property (nonatomic, assign) int sizeSelectedIndex;

@property (nonatomic, strong) NSArray *likesArray;

@property (nonatomic, strong) UIActionSheet *actionSheet;

@property (nonatomic, strong) IBOutlet UIButton *facebookButton;
@property (nonatomic, strong) IBOutlet UIButton *twitterButton;

@property (nonatomic, strong) NSString *viglinkString;

@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) UIButton *commentExitButton;

@property (nonatomic, strong) CIALBrowserViewController *cialBrowserViewController;

@property (nonatomic, assign) BOOL isEditable;

@property (nonatomic, strong) UIViewController *actionSheetHandlingViewController;

@property (nonatomic, assign) BOOL isBuying;

@property (nonatomic, strong) JKProgressView *JKProgressView;

@property (nonatomic, strong) SearchViewController *searchViewControllerDelegate;
@property (nonatomic, strong) NSArray *searchCategoriesArray;


@property (nonatomic, assign) BOOL descriptionContentSizeSet;
@property (nonatomic, assign) CGSize descriptionContentSize;

@property (nonatomic, strong) IBOutlet UIView *profileContainerView;


@property (nonatomic, strong) IBOutlet UILabel *buyAnalyticsLabel;
@property (nonatomic, strong) IBOutlet UILabel *saveAnalyticsLabel;
@property (nonatomic, strong) NSDictionary *reportDictionary;


@property (nonatomic, strong) IBOutlet UIView *ownedProfileContainerView;

@property (nonatomic, strong) IBOutlet UILabel *viewsTitleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *viewsImageView;
@property (nonatomic, strong) IBOutlet UILabel *viewsValueLabel;

@property (nonatomic, strong) IBOutlet UILabel *shopsyTitleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *shopsyImageView;
@property (nonatomic, strong) IBOutlet UILabel *shopsyValueLabel;

@property (nonatomic, strong) IBOutlet UILabel *instagramTitleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *instagramImageView;
@property (nonatomic, strong) IBOutlet UILabel *instagramValueLabel;

@end
