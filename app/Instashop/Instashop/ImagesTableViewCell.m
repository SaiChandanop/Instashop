//
//  ImagesTableViewCell.m
//  Instashop
//
//  Created by Josh Klobe on 5/24/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ImagesTableViewCell.h"
#import "ImageAPIHandler.h"
#import "ImagesTableCellButton.h"

@implementation ImagesTableViewCell

@synthesize delegate;

@synthesize backgroundImageViewOne;
@synthesize backgroundImageViewTwo;
@synthesize backgroundImageViewThree;

@synthesize imageViewOne;
@synthesize imageViewTwo;
@synthesize imageViewThree;
@synthesize coverLabel;

@synthesize coverButtonOne;
@synthesize coverButtonTwo;
@synthesize coverButtonThree;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellHeight:(float)cellHeight
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}


- (void) loadWithIndexPath:(NSIndexPath *)theIndexPath withFeedItemsArray:(NSArray *)feedItemsArray
{
    int startValue = theIndexPath.row * 3;
    
    float spacer = 6.5;
    float imageWidth = self.frame.size.width / 3 - 11;
    imageWidth = 98;
    
    
    int iter = 0;
    
    self.imageViewOne.image = nil;
    self.imageViewTwo.image = nil;
    self.imageViewThree.image = nil;
    
    
    float inset = 3;
    
    for (int i = startValue; i < startValue + 3 && i < [feedItemsArray count]; i++)
    {
        
        
        UIImageView *theImageView = nil;
        ImagesTableCellButton *theCoverButton = nil;
        
        
        if (iter == 0)
        {
            if (self.backgroundImageViewOne == nil)
            {
                self.backgroundImageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(iter * spacer + spacer +  iter * imageWidth, spacer, imageWidth, imageWidth)];
                self.backgroundImageViewOne.image = [UIImage imageNamed:@"feedImageShadow.png"];
                [self addSubview:self.backgroundImageViewOne];
            }
            
            
            if (self.imageViewOne == nil)
            {
                self.imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(self.backgroundImageViewOne.frame.origin.x + inset, self.backgroundImageViewOne.frame.origin.y + inset, self.backgroundImageViewOne.frame.size.width - 2 * inset, self.backgroundImageViewOne.frame.size.height - 2 * inset)];
                [self addSubview:self.imageViewOne];
            }
            theImageView = self.imageViewOne;
            
            
            if (self.coverButtonOne == nil)
            {
                self.coverButtonOne = [[ImagesTableCellButton alloc] initWithFrame:theImageView.frame];
                [self.coverButtonOne addTarget:self action:@selector(coverButtonHit:) forControlEvents:UIControlEventTouchUpInside];
                self.coverButtonOne.backgroundColor = [UIColor clearColor];
                [self addSubview:self.coverButtonOne];
            }
            theCoverButton = self.coverButtonOne;
        }
        
        else if (iter == 1)
        {
            if (self.backgroundImageViewTwo == nil)
            {
                self.backgroundImageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(iter * spacer + spacer +  iter * imageWidth, spacer, imageWidth, imageWidth)];
                self.backgroundImageViewTwo.image = [UIImage imageNamed:@"feedImageShadow.png"];
                [self addSubview:self.backgroundImageViewTwo];
            }
            
            if (self.imageViewTwo == nil)
            {
                self.imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(self.backgroundImageViewTwo.frame.origin.x + inset, self.backgroundImageViewTwo.frame.origin.y + inset, self.backgroundImageViewTwo.frame.size.width - 2 * inset, self.backgroundImageViewTwo.frame.size.height - 2 * inset)];
                [self addSubview:self.imageViewTwo];
            }
            theImageView = self.imageViewTwo;
            
            
            if (self.coverButtonTwo == nil)
            {
                self.coverButtonTwo = [[ImagesTableCellButton alloc] initWithFrame:theImageView.frame];
                [self.coverButtonTwo addTarget:self action:@selector(coverButtonHit:) forControlEvents:UIControlEventTouchUpInside];
                self.coverButtonTwo.backgroundColor = [UIColor clearColor];
                [self addSubview:self.coverButtonTwo];
            }                        
            theCoverButton = self.coverButtonTwo;
            
        }
        
        else if (iter == 2)
        {
            if (self.backgroundImageViewThree == nil)
            {
                self.backgroundImageViewThree = [[UIImageView alloc] initWithFrame:CGRectMake(iter * spacer + spacer +  iter * imageWidth, spacer, imageWidth, imageWidth)];
                self.backgroundImageViewThree.image = [UIImage imageNamed:@"feedImageShadow.png"];
                [self addSubview:self.backgroundImageViewThree];
            }
            
            if (self.imageViewThree == nil)
            {
                self.imageViewThree = [[UIImageView alloc] initWithFrame:CGRectMake(self.backgroundImageViewThree.frame.origin.x + inset, self.backgroundImageViewThree.frame.origin.y + inset, self.backgroundImageViewThree.frame.size.width - 2 * inset, self.backgroundImageViewThree.frame.size.height - 2 * inset)];
                [self addSubview:self.imageViewThree];
            }
            theImageView = self.imageViewThree;
            
            if (self.coverButtonThree == nil)
            {
                self.coverButtonThree = [[ImagesTableCellButton alloc] initWithFrame:theImageView.frame];
                [self.coverButtonThree addTarget:self action:@selector(coverButtonHit:) forControlEvents:UIControlEventTouchUpInside];
                self.coverButtonThree.backgroundColor = [UIColor clearColor];
                [self addSubview:self.coverButtonThree];
            }
            theCoverButton = self.coverButtonThree;
        }
        

        NSDictionary *productObjectDictionary = [feedItemsArray objectAtIndex:i];
        NSString *productURL = [productObjectDictionary objectForKey:@"products_url"];
        if (productURL == nil)
        {
            NSDictionary *imagesDictionary = [productObjectDictionary objectForKey:@"images"];
            if (imagesDictionary != nil)
            {
                NSDictionary *standardResolutionDictionary = [imagesDictionary objectForKey:@"standard_resolution"];
                productURL = [standardResolutionDictionary objectForKey:@"url"];
            }
        }
        
        if (productURL != nil)
            [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:productURL withImageView:theImageView];
        
        theCoverButton.objectDictionary = productObjectDictionary;
        
        
        iter++;
        
        [self bringSubviewToFront:self.imageViewOne];
        [self bringSubviewToFront:self.imageViewTwo];
        [self bringSubviewToFront:self.imageViewThree];

        [self bringSubviewToFront:self.coverButtonOne];
        [self bringSubviewToFront:self.coverButtonTwo];
        [self bringSubviewToFront:self.coverButtonThree];


    }
    
}

-(void)coverButtonHit:(ImagesTableCellButton *)theButton
{
    [self.delegate cellSelectionOccured:theButton.objectDictionary];
}


/*        UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(theImageView.frame.origin.x, (imageWidth + 2) / 2 - fontHeight / 2, theImageView.frame.size.width, fontHeight + 1)];
 theLabel.backgroundColor = [UIColor clearColor];
 theLabel.textColor = [UIColor whiteColor];
 theLabel.textAlignment = NSTextAlignmentCenter;
 theLabel.font = [UIFont systemFontOfSize:fontHeight];
 [self addSubview:theLabel];
 [theLabel release];
 */




@end
