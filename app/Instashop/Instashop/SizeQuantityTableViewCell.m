//
//  SizeQuantityTableViewCell.m
//  Instashop
//
//  Created by Josh Klobe on 7/16/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SizeQuantityTableViewCell.h"

@implementation SizeQuantityTableViewCell

@synthesize rowNumberLabel;
@synthesize sizeButton;
@synthesize quantityButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.rowNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, self.frame.size.height)];
        self.rowNumberLabel.backgroundColor = [UIColor clearColor];
        self.rowNumberLabel.textAlignment = NSTextAlignmentCenter;
        self.rowNumberLabel.textColor = [UIColor whiteColor];
        self.rowNumberLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:self.rowNumberLabel];
        
        float buttonWidth = 80;
        float buttonHeight = 30;
        
        self.sizeButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        self.sizeButton.frame = CGRectMake(self.frame.size.width / 4 - buttonWidth / 2, self.frame.size.height / 2 - buttonHeight / 2, buttonWidth, buttonHeight);
        [self addSubview:self.sizeButton];
        
        self.quantityButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
        self.quantityButton.frame = CGRectMake(self.frame.size.width / 2 + self.frame.size.width / 4 - buttonWidth / 2, self.frame.size.height / 2 - buttonHeight / 2, buttonWidth, buttonHeight);
        [self.quantityButton addTarget:self action:@selector(quantityButtonHit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.quantityButton];
        
        

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) loadWithIndexPath:(NSIndexPath *)indexPath withSizeTitle:(NSString *)sizeTitle
{

    self.rowNumberLabel.text = [NSString stringWithFormat:@"%d", indexPath.row + 1];
    
    [self.sizeButton setTitle:@"size" forState:UIControlStateNormal];
    [self.quantityButton setTitle:@"quant" forState:UIControlStateNormal];
    
 
    if (sizeTitle == nil)
        [self.sizeButton setTitle:@"NIL" forState:UIControlStateNormal];
    else
        [self.sizeButton setTitle:sizeTitle forState:UIControlStateNormal];
    
    [self.quantityButton setTitle:@"0" forState:UIControlStateNormal];
    
}

@end
