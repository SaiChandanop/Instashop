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

- (void)webControllerBackButtonHit;

-(void)commentAddTextShouldBeginEditingWithTextField:(UITextField *)theTextField;
-(void)commentAddTextShouldEndEditing;

@property (nonatomic, retain) SizePickerViewViewController *sizePickerViewViewController;
@property (nonatomic, retain) IBOutlet CommentsTableViewController *commentsTableViewController;
@property (nonatomic, retain) NSString *requestingProductID;
@property (nonatomic, retain) NSDictionary *requestedPostmasterDictionary;

@property (nonatomic, retain) IBOutlet UIImageView *heartImageView;
@property (nonatomic, retain) IBOutlet UIScrollView *contentScrollView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;

@property (nonatomic, retain) IBOutlet UIView *categoryContainerView;
@property (nonatomic, retain) IBOutlet UIImageView *categoryContainerBottomSeparatorImageView;
@property (nonatomic, retain) IBOutlet UIImageView *categoryContainerImageView;
@property (nonatomic, retain) IBOutlet UIView *doubleTapView;
@property (nonatomic, retain) IBOutlet UILabel *sellerLabel;
@property (nonatomic, retain) IBOutlet UILabel *likesLabel;
@property (nonatomic, retain) IBOutlet UIView *descriptionContainerView;
@property (nonatomic, retain) IBOutlet UITextView *descriptionTextView;
@property (nonatomic, retain) IBOutlet UILabel *listPriceLabel;
@property (nonatomic, retain) IBOutlet UILabel *retailPriceLabel;
@property (nonatomic, retain) IBOutlet UILabel *numberAvailableLabel;
@property (nonatomic, retain) IBOutlet ISAsynchImageView *sellerProfileImageView;
@property (nonatomic, retain) IBOutlet UIButton *sizeButton;
@property (nonatomic, retain) IBOutlet UIButton *quantityButton;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) IBOutlet UIButton *purchaseButton;
@property (nonatomic, retain) IBOutlet UIView *bottomView;

@property (nonatomic, assign) int sizeSelectedIndex;

@property (nonatomic, retain) NSArray *likesArray;

@property (nonatomic, retain) UIActionSheet *actionSheet;

@property (nonatomic, retain) IBOutlet UIButton *facebookButton;
@property (nonatomic, retain) IBOutlet UIButton *twitterButton;

@property (nonatomic, retain) NSString *viglinkString;

@property (nonatomic, retain) UITextField *commentTextField;
@property (nonatomic, retain) UIButton *commentExitButton;

@property (nonatomic, retain) CIALBrowserViewController *cialBrowserViewController;

@property (nonatomic, assign) BOOL isEditable;

@property (nonatomic, retain) UIViewController *actionSheetHandlingViewController;

@property (nonatomic, assign) BOOL isBuying;


@end
