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

@synthesize imageViewOne;
@synthesize imageViewTwo;
@synthesize imageViewThree;
@synthesize coverLabel;
@synthesize coverButton;

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
    
    
    for (int i = startValue; i < startValue + 3 && i < [feedItemsArray count]; i++)
    {
        self.backgroundColor = [UIColor redColor];
        UIImageView *theImageView = nil;
        if (iter == 0)
        {
            if (self.imageViewOne == nil)
                self.imageViewOne = [[UIImageView alloc] initWithFrame:CGRectMake(iter * spacer + spacer +  iter * imageWidth, spacer, imageWidth, imageWidth)];
            
            [self addSubview:self.imageViewOne];
            theImageView = self.imageViewOne;
        }
        if (iter == 1)
        {
            if (self.imageViewTwo == nil)
                self.imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(iter * spacer + spacer +  iter * imageWidth, spacer, imageWidth, imageWidth)];

            [self addSubview:self.imageViewTwo];
            theImageView = self.imageViewTwo;
        }
        if (iter == 2)
        {
            if (self.imageViewThree == nil)
                self.imageViewThree = [[UIImageView alloc] initWithFrame:CGRectMake(iter * spacer + spacer +  iter * imageWidth, spacer, imageWidth, imageWidth)];
            
            [self addSubview:self.imageViewThree];
            theImageView = self.imageViewThree;
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
        
        
/*        UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(theImageView.frame.origin.x, (imageWidth + 2) / 2 - fontHeight / 2, theImageView.frame.size.width, fontHeight + 1)];
        theLabel.backgroundColor = [UIColor clearColor];
        theLabel.textColor = [UIColor whiteColor];
        theLabel.textAlignment = NSTextAlignmentCenter;
        theLabel.font = [UIFont systemFontOfSize:fontHeight];
        [self addSubview:theLabel];
        [theLabel release];
        
  */      
        
        
        if (self.coverButton == nil)
        {
            self.coverButton = [[ImagesTableCellButton alloc] initWithFrame:theImageView.frame];
            [self.coverButton addTarget:self action:@selector(coverButtonHit:) forControlEvents:UIControlEventTouchUpInside];
            self.coverButton.backgroundColor = [UIColor clearColor];
            [self addSubview:self.coverButton];
        }
        
        self.coverButton.objectDictionary = productObjectDictionary;
        
        iter++;
    }
    
}

-(void)coverButtonHit:(ImagesTableCellButton *)theButton
{
    //    NSLog(@"selection: %@", theButton.objectDictionary);
    [self.delegate cellSelectionOccured:theButton.objectDictionary];
}




@end
