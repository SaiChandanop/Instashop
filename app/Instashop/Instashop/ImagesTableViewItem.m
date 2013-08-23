//
//  ImagesTableViewItem.m
//  Instashop
//
//  Created by Josh Klobe on 8/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "ImagesTableViewItem.h"
#import "ImageAPIHandler.h"
#import "CellSelectionOccuredProtocol.h"

@implementation ImagesTableViewItem

@synthesize backgroundImageView;
@synthesize contentImageView;
@synthesize coverButton;

@synthesize objectDictionary;

- (id)initWithFrame:(CGRect)frame withButtonDelegate:(id)theDelegate
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = theDelegate;
        
        float contentInset = 6;
        
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.backgroundImageView.image = [UIImage imageNamed:@"feedImageShadow.png"];
        [self addSubview:self.backgroundImageView];
        
        self.contentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(contentInset, contentInset, self.frame.size.width - 2 * contentInset, self.frame.size.height - 2 * contentInset)];
        [self addSubview:self.contentImageView];
        
        self.coverButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        self.coverButton.backgroundColor = [UIColor clearColor];
        self.coverButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.coverButton addTarget:self action:@selector(coverButtonHit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.coverButton];
    }
    return self;
}

- (void) loadContentWithDictionary:(NSDictionary *)theDictionary
{
    if (self.objectDictionary != nil)
        [self.objectDictionary release];
    
    self.objectDictionary = [[NSDictionary alloc] initWithDictionary:theDictionary];
    
        
    NSString *productURL = [self.objectDictionary objectForKey:@"products_url"];
    if (productURL == nil)
    {
        NSDictionary *imagesDictionary = [self.objectDictionary objectForKey:@"images"];
        if (imagesDictionary != nil)
        {
            NSDictionary *standardResolutionDictionary = [imagesDictionary objectForKey:@"standard_resolution"];
            productURL = [standardResolutionDictionary objectForKey:@"url"];
        }
    }
    
    if (productURL != nil)
        [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:productURL withImageView:self.contentImageView];
}

- (void) coverButtonHit
{
    if ([self.delegate conformsToProtocol:@protocol(CellSelectionOccuredProtocol)])
        [(id<CellSelectionOccuredProtocol>)self.delegate cellSelectionOccured:self.objectDictionary];

}

-(void)dealloc
{
    NSLog(@"%@ dealloc", self);
    [super dealloc];
}
@end
