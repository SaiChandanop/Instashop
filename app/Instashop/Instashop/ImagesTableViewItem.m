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
#import "TableCellAddClass.h"
#import "AppDelegate.h"
#import "AppRootViewController.h"

@implementation ImagesTableViewItem

@synthesize backgroundImageView;
@synthesize contentImageView;
@synthesize coverButton;
@synthesize imageProductURL;
@synthesize objectDictionary;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        float contentInset = 4;
        
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

- (void) cleanContent;
{
    self.backgroundImageView.alpha = 0;
    self.contentImageView.image = nil;
    self.objectDictionary = nil;
}

- (void) loadContentWithDictionary:(NSDictionary *)theDictionary
{
    if ([theDictionary isKindOfClass:[TableCellAddClass class]])
    {
        self.objectDictionary = theDictionary;
        [self.coverButton setImage:[UIImage imageNamed:@"add_product.png"] forState:UIControlStateNormal];
        self.coverButton.backgroundColor = [UIColor clearColor];
    }
    else
    {
        [self.coverButton setTitle:@"" forState:UIControlStateNormal];
        [self.coverButton setImage:nil forState:UIControlStateNormal];
        
    self.backgroundImageView.alpha = 1;
    
    if (self.objectDictionary != nil)
        [self.objectDictionary release];
    
    self.objectDictionary = [[NSDictionary alloc] initWithDictionary:theDictionary];
    
        
    self.imageProductURL = [self.objectDictionary objectForKey:@"products_url"];
    if (self.imageProductURL == nil)
    {
        NSDictionary *imagesDictionary = [self.objectDictionary objectForKey:@"images"];
        if (imagesDictionary != nil)
        {
            NSDictionary *standardResolutionDictionary = [imagesDictionary objectForKey:@"standard_resolution"];
            self.imageProductURL = [standardResolutionDictionary objectForKey:@"url"];
        }
    }
    
    if (self.imageProductURL != nil)
        [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:self.imageProductURL withImageView:nil];
    }
}

-(void)imageReturnedWithURL:(NSString *)url withImage:(UIImage *)theImage
{
    if ([url compare:self.imageProductURL] == NSOrderedSame)
        self.contentImageView.image = theImage;
}



- (void) coverButtonHit
{
    
    NSLog(@"coverbuttonhit, self.delegate: %@", self.delegate);
    if (self.objectDictionary != nil)    {
        if ([self.objectDictionary isKindOfClass:[TableCellAddClass class]])
        {
            AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [del.appRootViewController createProductButtonHit];

        }
        else if ([self.delegate conformsToProtocol:@protocol(CellSelectionOccuredProtocol)])
            [(id<CellSelectionOccuredProtocol>)self.delegate cellSelectionOccured:self.objectDictionary];
    }

}


- (void) loadContentWithInstagramDictionaryObject:(NSDictionary *)theDictionary
{
    NSLog(@"theDictionary: %@", theDictionary);
    
    [self.coverButton setTitle:@"" forState:UIControlStateNormal];
    [self.coverButton setImage:nil forState:UIControlStateNormal];
    
    self.backgroundImageView.alpha = 1;
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"users/%@", [theDictionary objectForKey:@"instagram_id"]], @"method", nil];
    [appDelegate.instagram requestWithParams:params delegate:self];
    
    
    
    
}


- (void)request:(IGRequest *)request didLoad:(id)result {
    
    if ([request.url rangeOfString:@"users"].length > 0)
    {
        NSDictionary *dataDictionary = [result objectForKey:@"data"];
        NSLog(@"dataDictionary: %@", dataDictionary);
        
        [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[dataDictionary objectForKey:@"profile_picture"] withImageView:self.contentImageView];
        
    }

    
}


-(void)dealloc
{
    NSLog(@"%@ dealloc", self);
    [super dealloc];
}
@end
