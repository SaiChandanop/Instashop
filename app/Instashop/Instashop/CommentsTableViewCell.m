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
#import "CommentsTableViewController.h"
#import "PurchasingAddressViewController.h"

@implementation CommentsTableViewCell

@synthesize profilePictureImageView;
@synthesize usernameLabel;
@synthesize commentTextLabel;
@synthesize timeLabel;
@synthesize commentTextField;
@synthesize parentController;
@synthesize commentGoButton;

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
    self.profilePictureImageView = (UIImageView *)[self viewWithTag:1];
    self.usernameLabel = (UILabel *)[self viewWithTag:2];
    self.commentTextLabel = (UILabel *)[self viewWithTag:3];
    self.timeLabel = (UILabel *)[self viewWithTag:4];


    self.profilePictureImageView.image = nil;
    self.usernameLabel.text = @"";
    self.commentTextLabel.text = @"";
    self.timeLabel.text = @"";
    
    if ([commentDictionary isKindOfClass:[NSNull class]])
    {
        self.commentTextField = [[UITextField alloc] initWithFrame:CGRectMake(4, self.frame.size.height * .05, self.frame.size.width * .75, self.frame.size.height - 2 * self.frame.size.height * .05)];
        self.commentTextField.delegate = self;
        [self addSubview:self.commentTextField];
        
        self.commentGoButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        [self.commentGoButton setTitle:@"go" forState:UIControlStateNormal];
        self.commentGoButton.frame = CGRectMake(self.frame.size.width - 60, self.commentTextField.frame.origin.y, 45, self.commentTextField.frame.size.height);
        [self addSubview:self.commentGoButton];
        [self.commentGoButton addTarget:self action:@selector(goButtonHit) forControlEvents:UIControlEventTouchUpInside];
        

    }
    else
    {
        [self.commentGoButton removeFromSuperview];
        [self.commentTextField removeFromSuperview];
    
        NSDictionary *fromDictionary = [commentDictionary objectForKey:@"from"];
    
        self.usernameLabel.text = [fromDictionary objectForKey:@"username"];
        self.commentTextLabel.text = [commentDictionary objectForKey:@"text"];
    
        if ([fromDictionary objectForKey:@"profile_picture"] != nil)
            [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[fromDictionary objectForKey:@"profile_picture"] withImageView:self.profilePictureImageView];
    
    
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[[commentDictionary objectForKey:@"created_time"] doubleValue]];
                                                                
        TTTTimeIntervalFormatter *intervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
        intervalFormatter.usesAbbreviatedCalendarUnits = YES;
        if ([commentDictionary objectForKey:@"created_time"] != nil)
            self.timeLabel.text = [intervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:startDate];
    
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    [self.parentController.parentController commentAddTextShouldBeginEditingWithTextField:textField];
    
    return YES;
}


-(void)goButtonHit
{
    NSLog(@"goButtonHit");
    [self.parentController.parentController commentAddTextShouldEndEditing];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
