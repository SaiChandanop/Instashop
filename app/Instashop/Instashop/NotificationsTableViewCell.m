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
@implementation NotificationsTableViewCell

@synthesize messageLabel;
@synthesize timeLabel;


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
    self.messageLabel = (UILabel *)[self viewWithTag:3];
    self.timeLabel = (UILabel *)[self viewWithTag:4];
    
    self.messageLabel.text = theObject.message;
    
    
    TTTTimeIntervalFormatter *intervalFormatter = [[TTTTimeIntervalFormatter alloc] init];
    intervalFormatter.usesAbbreviatedCalendarUnits = YES;
    
    NSLog(@"theObject.dataDictionary: %@", theObject.dataDictionary);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [dateFormatter dateFromString:[theObject.dataDictionary objectForKey:@"notification_date"]];
    self.timeLabel.text = [intervalFormatter stringForTimeIntervalFromDate:[NSDate date] toDate:startDate];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
