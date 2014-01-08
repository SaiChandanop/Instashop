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
@class FeedViewController;

@interface PurchasingViewController : UIViewController <IGRequestDelegate, UIActionSheetDelegate, FeedRequestFinishedProtocol, EditProductCompleteProtocol, BitlyResponseHandler, FlagManagerProtocol>
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


@end
