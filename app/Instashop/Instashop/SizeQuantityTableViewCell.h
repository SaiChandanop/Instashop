//
//  SizeQuantityTableViewCell.h
//  Instashop
//
//  Created by Josh Klobe on 7/16/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SizeQuantityTableViewCell : UITableViewCell
{
    UILabel *rowNumberLabel;
    UIButton *sizeButton;
    UIButton *quantityButton;
}

-(void) loadWithIndexPath:(NSIndexPath *)indexPath withSizeTitle:(NSString *)sizeTitle;

@property (nonatomic, retain) UILabel *rowNumberLabel;
@property (nonatomic, retain) UIButton *sizeButton;
@property (nonatomic, retain) UIButton *quantityButton;


@end
