//
//  CategorySelectCell.h
//  Instashop
//
//  Created by Josh Klobe on 8/7/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategorySelectCell : UITableViewCell
{
    UIView *bgView;
    UILabel *theLabel;
    UIImageView *disclosureImageView;
}
@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UILabel *theLabel;
@property (nonatomic, retain) UIImageView *disclosureImageView;

@end
