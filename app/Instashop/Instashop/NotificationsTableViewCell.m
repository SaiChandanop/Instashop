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
#import "AppRootViewController.h"
#import "NotificationsViewController.h"
@implementation NotificationsTableViewCell

@synthesize notificationsObject;
@synthesize usernameLabel;
@synthesize messageLabel;
@synthesize timeLabel;
@synthesize profileImageView;
@synthesize parentController;

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
    
    
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height /2;
    self.profileImageView.layer.masksToBounds = YES;
    self.profileImageView.alpha = 1;
    
    
    if (theObject != nil)
        if (theObject.dataDictionary != nil)
            if ([theObject.dataDictionary objectForKey:@"creator_id"] != nil)
            {
                NSDictionary *dataDictionary = [[AppRootViewController sharedRootViewController].notificationsViewController getDictionaryFromCacheWithID:[theObject.dataDictionary objectForKey:@"creator_id"]];
                if (dataDictionary != nil)
                {
//                    NSLog(@"dataDictionary: %@", dataDictionary);
                    if ([dataDictionary objectForKey:@"private"] != nil)
                        [self loadPrivate];
                    else
                        [self loadContentWithDataDictionary:dataDictionary];
                }
            }
    

    
    TTTTimeIntervalFormatter *intervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    intervalFormatter.usesAbbreviatedCalendarUnits = YES;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [dateFormatter dateFromString:[self.notificationsObject.dataDictionary objectForKey:@"notification_date"]];

    NSDate *now = [NSDate date];
    now = [now dateByAddingTimeInterval:-60*60];
    NSTimeInterval theTimeInterval = [now timeIntervalSinceDate:startDate];
    
    if (theTimeInterval / 60 < 60)
    {
        int numMins = [[NSNumber numberWithDouble:theTimeInterval / 60] integerValue];
        self.timeLabel.text = [NSString stringWithFormat:@"%d mins ago", numMins];
    }
    else
        self.timeLabel.text = [intervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:startDate];
    
    
}

-(void)loadPrivate
{
    self.profileImageView.image = [UIImage imageNamed:@"anonymous.png"];
    self.usernameLabel.text = @"A Shopsy User";
    self.messageLabel.text = [self.notificationsObject.message stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",self.usernameLabel.text] withString:@""];
    self.messageLabel.text = [self.messageLabel.text substringFromIndex:1];
    
    NSLog(@"self.messageLabel.text|%@", self.messageLabel.text);
    NSLog(@"loadPrivate");
}

-(void)loadContentWithDataDictionary:(NSDictionary *)dataDictionary
{
    [ImageAPIHandler makeSynchImageRequestWithDelegate:nil withInstagramMediaURLString:[dataDictionary objectForKey:@"profile_picture"] withImageView:self.profileImageView];
    
    self.usernameLabel.text = [dataDictionary objectForKey:@"username"];
    self.messageLabel.text = [self.notificationsObject.message stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@ ",self.usernameLabel.text] withString:@""];
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

     if (result != nil)
    {
        NSDictionary *dataDictionary = [result objectForKey:@"data"];
        if ([dataDictionary objectForKey:@"id"] != nil)
            [[AppRootViewController sharedRootViewController].notificationsViewController setDictionaryIntoCacheWithID:[dataDictionary objectForKey:@"id"] withDictionary:[NSDictionary dictionaryWithDictionary:dataDictionary]];

        [self loadContentWithDataDictionary:dataDictionary];
    }
    
    
    
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
