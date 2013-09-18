//
//  NavControllerAccessor.m
//  Instashop
//
//  Created by Josh Klobe on 9/18/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "NavControllerAccessor.h"
#import "ISConstants.h"
@implementation NavControllerAccessor

+(void)setIOS7NavigationBarStyleWithNavigationController:(UINavigationController *)theNavigationController
{
    if ([[UIDevice currentDevice].systemVersion floatValue] > 7.0f)
    {
        [theNavigationController.navigationController.navigationBar setBarTintColor:[ISConstants getISGreenColor]];
        [theNavigationController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        theNavigationController.navigationController.navigationBar.translucent = NO;
    }
}
@end
