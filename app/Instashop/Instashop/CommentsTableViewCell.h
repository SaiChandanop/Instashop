//
//  CommentsTableViewCell.h
//  Instashop
//
//  Created by Josh Klobe on 10/29/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsTableViewCell : UITableViewCell
{
    UIImageView *profilePictureImageView;
    UILabel *usernameLabel;
    UILabel *commentTextLabel;
    UILabel *timeLabel;
}

-(void)loadWithCommentObject:(NSDictionary *)commentDictionary;

@property (nonatomic, retain) IBOutlet UIImageView *profilePictureImageView;
@property (nonatomic, retain) IBOutlet UILabel *usernameLabel;
@property (nonatomic, retain) IBOutlet UILabel *commentTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;

@end
