//
//  SellersTableViewCell.h
//  Instashop
//
//  Created by Josh Klobe on 9/12/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellersTableViewCell : UITableViewCell
{
    UIImageView *sellerImageView;
    UILabel *sellerTextLabel;
}

@property (nonatomic, retain) UIImageView *sellerImageView;
@property (nonatomic, retain) UILabel *sellerTextLabel;

@end
