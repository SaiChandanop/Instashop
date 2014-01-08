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
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *theLabel;
@property (nonatomic, strong) UIImageView *disclosureImageView;

@end
