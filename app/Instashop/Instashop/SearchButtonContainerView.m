//
//  SearchButtonContainerView.m
//  Instashop
//
//  Created by Josh Klobe on 9/12/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SearchButtonContainerView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SearchButtonContainerView

@synthesize searchTerm;
@synthesize searchLabel;
@synthesize exitImageView;
@synthesize coverButton;
@synthesize type;
@synthesize referenceController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) loadWithSearchTerm:(NSString *)theSearchTerm withClickDelegate:(SearchSiloViewController *)searchSiloViewController
{
    self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightMenuBG.png"]
];  //
    self.referenceController = searchSiloViewController;
    self.searchTerm = theSearchTerm;
    
    self.searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    self.searchLabel.backgroundColor = [UIColor clearColor];
    self.searchLabel.textAlignment = NSTextAlignmentLeft;
    self.searchLabel.textColor = [UIColor colorWithRed:(85.0/255.0) green:(85.0/255.0) blue:(85.0/255.0) alpha:1];
    self.searchLabel.font = [UIFont systemFontOfSize:12];
    self.searchLabel.text = self.searchTerm;
    [self addSubview:self.searchLabel];
    
    
    self.exitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.exitImageView.image = [UIImage imageNamed:@"search_cancel.png"];
    [self addSubview:self.exitImageView];
    
    
    self.coverButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [self.coverButton addTarget:self action:@selector(coverButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.coverButton];
}


-(void) sizeViewWithFrame
{
     
    self.searchLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.exitImageView.frame = CGRectMake(self.frame.size.width - self.exitImageView.image.size.width - 4, self.frame.size.height / 2 - self.exitImageView.image.size.height / 2, self.exitImageView.image.size.width, self.exitImageView.image.size.height);
    self.coverButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    
}

-(void)coverButtonHit
{
    [self.referenceController searchButtonContainerHit:self];
    
}

@end
