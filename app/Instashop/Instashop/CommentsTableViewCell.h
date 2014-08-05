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

@property (nonatomic, strong) IBOutlet UIImageView *profilePictureImageView;
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UILabel *commentTextLabel;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) IBOutlet UITextField *commentTextField;
@property (nonatomic, strong) IBOutlet UIButton *commentGoButton;

@property (nonatomic, strong) CommentsTableViewController *parentController;
@end
