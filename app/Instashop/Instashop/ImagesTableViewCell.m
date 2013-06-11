//
//  ImagesTableViewCell.m
//  Instashop
//
//  Created by Josh Klobe on 5/24/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ImagesTableViewCell.h"

@implementation ImagesTableViewCell


@synthesize theImageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(float)cellHeight
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7, 0,cellHeight, cellHeight)];
        [self addSubview:self.theImageView];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.theImageView.frame.size.height/2 - 12, self.frame.size.width, 24)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:24];
        self.titleLabel.shadowColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
        self.titleLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        [self addSubview:self.titleLabel];
        

    }
    return self;
}



@end
