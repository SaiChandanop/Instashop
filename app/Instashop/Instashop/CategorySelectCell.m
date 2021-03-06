//
//  CategorySelectCell.m
//  Instashop
//
//  Created by Josh Klobe on 8/7/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CategorySelectCell.h"

@implementation CategorySelectCell

@synthesize bgView;
@synthesize theLabel;
@synthesize disclosureImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        float inset = 0;
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, inset, self.frame.size.width, self.frame.size.height - inset)];
//        self.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cell_background.png"]];
        [self addSubview:self.bgView];
        
        self.theLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width, self.frame.size.height)];
        self.theLabel.backgroundColor = [UIColor clearColor];
        self.theLabel.font = [UIFont systemFontOfSize:14];
        self.theLabel.textAlignment = NSTextAlignmentLeft;
        self.theLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.theLabel];
        
        
        float theWidth = 44;
        float theHeight = 44;
        UIImage *disclosureImage = [UIImage imageNamed:@"cell_disclosure_new"];
        self.disclosureImageView = [[UIImageView alloc] initWithImage:disclosureImage];
        self.disclosureImageView.frame = CGRectMake(self.frame.size.width - 0 - theWidth, self.frame.size.height / 2 - theHeight /2, theWidth, theHeight);
        [self addSubview:self.disclosureImageView];
        
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
