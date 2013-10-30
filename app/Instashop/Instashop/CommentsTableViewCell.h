//
//  CommentsTableViewCell.h
//  Instashop
//
//  Created by Josh Klobe on 10/29/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentsTableViewController;
@interface CommentsTableViewCell : UITableViewCell <UITextFieldDelegate>
{
    UIImageView *profilePictureImageView;
    UILabel *usernameLabel;
    UILabel *commentTextLabel;
    UILabel *timeLabel;
    
    UITextField *commentTextField;
    UIButton *commentGoButton;
    
    CommentsTableViewController *parentController;

}

-(void)loadWithCommentObject:(NSDictionary *)commentDictionary withIndexPath:(NSIndexPath *)theIndexpath;

@property (nonatomic, retain) IBOutlet UIImageView *profilePictureImageView;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *commentTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;

@property (nonatomic, retain) IBOutlet UITextField *commentTextField;
@property (nonatomic, retain) IBOutlet UIButton *commentGoButton;

@property (nonatomic, retain) CommentsTableViewController *parentController;
@end
