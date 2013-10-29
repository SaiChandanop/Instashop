//
//  CommentsTableViewCell.m
//  Instashop
//
//  Created by Josh Klobe on 10/29/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CommentsTableViewCell.h"

@implementation CommentsTableViewCell

@synthesize profilePictureImageView;
@synthesize usernameLabel;
@synthesize commentTextLabel;
@synthesize timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)loadWithCommentObject:(NSDictionary *)commentDictionary
{
    
    self.profilePictureImageView = (UIImageView *)[self viewWithTag:1];
    self.usernameLabel = (UILabel *)[self viewWithTag:2];
    self.commentTextLabel = (UILabel *)[self viewWithTag:3];
    self.timeLabel = (UILabel *)[self viewWithTag:4];

    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
