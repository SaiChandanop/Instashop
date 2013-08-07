//
//  ImagesTableViewCell.h
//  Instashop
//
//  Created by Josh Klobe on 5/24/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesTableCellButton.h"

@interface ImagesTableViewCell : UITableViewCell
{
    id delegate;
    
    UIImageView *backgroundImageViewOne;
    UIImageView *backgroundImageViewTwo;
    UIImageView *backgroundImageViewThree;
    
    UIImageView *imageViewOne;
    UIImageView *imageViewTwo;
    UIImageView *imageViewThree;
    UILabel *coverLabel;
    
    ImagesTableCellButton *coverButtonOne;
    ImagesTableCellButton *coverButtonTwo;
    ImagesTableCellButton *coverButtonThree;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(float)cellHeight;
- (void) loadWithIndexPath:(NSIndexPath *)theIndexPath withFeedItemsArray:(NSArray *)feedItemsArray;


@property (nonatomic, retain) id delegate;

@property (nonatomic, retain) UIImageView *backgroundImageViewOne;
@property (nonatomic, retain) UIImageView *backgroundImageViewTwo;
@property (nonatomic, retain) UIImageView *backgroundImageViewThree;

@property (nonatomic, retain) UIImageView *imageViewOne;
@property (nonatomic, retain) UIImageView *imageViewTwo;
@property (nonatomic, retain) UIImageView *imageViewThree;
@property (nonatomic, retain) UILabel *coverLabel;

@property (nonatomic, retain) ImagesTableCellButton *coverButtonOne;
@property (nonatomic, retain) ImagesTableCellButton *coverButtonTwo;
@property (nonatomic, retain) ImagesTableCellButton *coverButtonThree;




@end
