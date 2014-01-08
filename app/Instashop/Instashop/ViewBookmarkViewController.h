//
//  ViewBookmarkViewController.h
//  CIALBrowser
//
//  Created by Sylver Bruneau on 01/09/10.
//  Copyright 2011 CodeIsALie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkObject.h"

@interface ViewBookmarkViewController : UITableViewController<UITextFieldDelegate> {
@private
    id _delegate;
    UIBarButtonItem *_doneButtonItem;
    NSMutableArray *_bookmarksArray;
    BookmarkObject *_bookmark;
}

@property (strong,nonatomic) id delegate;
@property (strong,nonatomic) UIBarButtonItem *doneButtonItem;
@property (strong,nonatomic) BookmarkObject *bookmark;

- (void)setBookmark:(NSString *)aName url:(NSURL *)aURL;
- (void)doneButtonAction;
- (void)saveBookmarks;
@end

@protocol ViewBookmarkDelegate <NSObject>
- (void)openThisURL:(NSURL *)url;
- (void)dismissViewBookmMarkViewController:(ViewBookmarkViewController *)viewController;
@end
