//
//  CreateSellerTutorialScrollView.m
//  Instashop
//
//  Created by Susan Yee on 9/11/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CreateSellerTutorialScrollView.h"

#define kHowToPageNumber 4

@implementation CreateSellerTutorialScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth = screenSize.width;
        CGFloat screenHeight = screenSize.height;
        
        // Scroll View
        self.pagingEnabled = YES;
        self.showsHorizontalScrollIndicator = NO;
        self.contentSize = CGSizeMake(screenWidth * 4, 33.3);
        float howToViewBoundsHeight = self.bounds.size.height;
        
        // Maybe you want a left view so that the previous menu can't be seen.
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(-320.0, 0.0, screenWidth, howToViewBoundsHeight)];
        UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightMenuBG.png"]];
        [leftView addSubview:backgroundImage];
        [self addSubview:leftView];
        
        NSArray *arrayOfLabels = [[NSArray alloc] initWithObjects:@"target-title.png", @"share-title.png", @"manage-title.png", @"grow-title.png", nil];
        NSArray *arrayOfImages = [[NSArray alloc] initWithObjects:@"target-graphic.png", @"share-graphic.png", @"manage-graphic.png", @"grow-graphic.png", nil];
        
        NSString *stringTextOne = [NSString stringWithFormat:@"Text 1"];
        NSString *stringTextTwo = [NSString stringWithFormat:@"Text 2"];
        NSString *stringTextThree = [NSString stringWithFormat:@"Text 3"];
        NSString *stringTextFour = [NSString stringWithFormat:@"Text 4"];
        
        NSArray *arrayOfTexts = [[NSArray alloc] initWithObjects:stringTextOne, stringTextTwo, stringTextThree, stringTextFour, nil];
        
        for (int p = 0; p <= kHowToPageNumber; p++) {
            
            if (p == kHowToPageNumber) {
                UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(p * screenWidth, 0.0, screenWidth, screenHeight)];
                UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightMenuBG.png"]];
                [rightView addSubview:backgroundImage];
                [self addSubview:rightView];
                break;
            }
            UIView *tutorialView = [[UIView alloc] initWithFrame:CGRectMake(p * screenWidth, 0.0, screenWidth, screenHeight)];
            UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightMenuBG.png"]];
            [tutorialView addSubview:backgroundImage];
            UIImageView *label = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[arrayOfLabels objectAtIndex:p]]];
            UIImageView *graphic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[arrayOfImages objectAtIndex:p]]];
            graphic.frame = CGRectMake((320 - graphic.bounds.size.width)/2, (screenHeight - graphic.bounds.size.height)/2 + 10, graphic.bounds.size.width, graphic.bounds.size.width);
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 400.0, 220.0, 60.0)];
            textLabel.text = [arrayOfTexts objectAtIndex:p];
            textLabel.textColor = [UIColor blackColor];
            textLabel.textAlignment = NSTextAlignmentCenter;
            [tutorialView addSubview:textLabel];
            [tutorialView addSubview:label];
            [tutorialView addSubview:graphic];
            if (p == (kHowToPageNumber - 1)) {
                UIButton *signUpButton = [[UIButton alloc] initWithFrame:CGRectMake(100.0, 350.0, 50.0, 50.0)];
                signUpButton.backgroundColor = [UIColor redColor];
                [signUpButton addTarget:self action:@selector(signUp) forControlEvents:UIControlEventTouchUpInside];
                [tutorialView addSubview:signUpButton];
            }
            [self addSubview:tutorialView];
        }
    }
    return self;
}

- (void) signUp {
    [self.delegate signUp];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
