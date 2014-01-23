//
//  NotificationsTableViewCell.m
//  Instashop
//
//  Created by Josh Klobe on 11/15/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "NotificationsTableViewCell.h"
#import "NotificationsObject.h"
#import "TTTTimeIntervalFormatter.h"
#import "AppDelegate.h"
#import "ImageAPIHandler.h"
@implementation NotificationsTableViewCell

@synthesize notificationsObject;
@synthesize usernameLabel;
@synthesize messageLabel;
@synthesize timeLabel;
@synthesize profileImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
    }
    return self;
}

-(void)loadWithNotificationsObject:(NotificationsObject *)theObject
{
    self.notificationsObject = theObject;
    
    self.usernameLabel = (UILabel *)[self viewWithTag:2];
    self.messageLabel = (UILabel *)[self viewWithTag:3];
    self.timeLabel = (UILabel *)[self viewWithTag:4];
    self.profileImageView = (UIImageView *)[self viewWithTag:5];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", [self.notificationsObject.dataDictionary objectForKey:@"creator_id"]], @"method", nil];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.alpha = 1;
    
    NSLog(@"load with message: %@", theObject.message);
    NSLog(@"load with dataDictionary: %@", theObject.dataDictionary);
    NSLog(@" ");
    NSLog(@" ");
    
    TTTTimeIntervalFormatter *intervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    intervalFormatter.usesAbbreviatedCalendarUnits = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [dateFormatter dateFromString:[self.notificationsObject.dataDictionary objectForKey:@"notification_date"]];
    self.timeLabel.text = [intervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:startDate];
    
    
}

-(IBAction)profileButtonHit
{
    NSLog(@"profileButtonHit");
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AppRootViewController *rootViewController = delegate.appRootViewController;
    [rootViewController notificationSelectedWithProfile:[self.notificationsObject.dataDictionary objectForKey:@"creator_id"]];
}

-(IBAction)notificationsButtonHit
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AppRootViewController *rootViewController = delegate.appRootViewController;
    [rootViewController notificationSelectedWithObject:self.notificationsObject];
}


- (void)request:(IGRequest *)request didLoad:(id)result
{
    NSLog(@"result: %@", result);
 
    [ImageAPIHandler makeSynchImageRequestWithDelegate:nil withInstagramMediaURLString:[[result objectForKey:@"data"] objectForKey:@"profile_picture"] withImageView:self.profileImageView];

    self.usernameLabel.text = [[result objectForKey:@"data"] objectForKey:@"username"];
    self.messageLabel.text = [self.notificationsObject.message stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@ ",self.usernameLabel.text] withString:@""];
    
    
    
    
}

-(void)clearSubviews
{
    self.usernameLabel.text = @"";
    self.messageLabel.text = @"";
    self.timeLabel.text = @"";
    self.profileImageView.image = nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
