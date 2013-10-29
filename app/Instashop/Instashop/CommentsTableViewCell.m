//
//  CommentsTableViewCell.m
//  Instashop
//
//  Created by Josh Klobe on 10/29/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CommentsTableViewCell.h"
#import "ImageAPIHandler.h"
#import "TTTTimeIntervalFormatter.h"


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


-(void)loadWithCommentObject:(NSDictionary *)commentDictionary withIndexPath:(NSIndexPath *)theIndexpath
{
    
    NSLog(@"commentDictionary: %@", commentDictionary);
    if (theIndexpath.row % 2 == 0)
        self.backgroundColor = [UIColor colorWithRed:196.0f/255.0f green:189.0f/255.0f blue:196.0f/255.0f alpha:1];
    else
        self.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:210.0f/255.0f blue:211.0f/255.0f alpha:1];
    
    self.profilePictureImageView = (UIImageView *)[self viewWithTag:1];
    self.usernameLabel = (UILabel *)[self viewWithTag:2];
    self.commentTextLabel = (UILabel *)[self viewWithTag:3];
    self.timeLabel = (UILabel *)[self viewWithTag:4];


    self.profilePictureImageView.image = nil;
    self.usernameLabel.text = @"";
    self.commentTextLabel.text = @"";
    self.timeLabel.text = @"";
    
    
    NSDictionary *fromDictionary = [commentDictionary objectForKey:@"from"];
    
    self.usernameLabel.text = [fromDictionary objectForKey:@"username"];
    self.commentTextLabel.text = [commentDictionary objectForKey:@"text"];
    
    
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[fromDictionary objectForKey:@"profile_picture"] withImageView:self.profilePictureImageView];
    
    
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[[commentDictionary objectForKey:@"created_time"] doubleValue]];
                                                                
    TTTTimeIntervalFormatter *intervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    intervalFormatter.usesAbbreviatedCalendarUnits = YES;
    self.timeLabel.text = [intervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:startDate];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
