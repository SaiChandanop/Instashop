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
        
        self.theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,cellHeight, cellHeight)];
        [self addSubview:self.theImageView];

        

    }
    return self;
}



@end
