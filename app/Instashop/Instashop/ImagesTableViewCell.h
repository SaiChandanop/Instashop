//
//  ImagesTableViewCell.h
//  Instashop
//
//  Created by Josh Klobe on 5/24/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesTableViewCell : UITableViewCell
{
    UIImageView *theImageView;
    UILabel *titleLabel;
    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(float)cellHeight;

@property (nonatomic, retain) UIImageView *theImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@end
