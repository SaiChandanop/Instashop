//
//  FirstViewController.m
//  Instashop
//
//  Created by Josh Klobe on 5/22/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "FirstViewController.h"
#import "AppDelegate.h"
#import "ImagesTableViewCell.h"
#import "ImageAPIHandler.h"
#import "ProductCreateViewController.h"


@interface FirstViewController ()
@end

@implementation FirstViewController

@synthesize userMediaArray, theTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        self.userMediaArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void)makeDummyRequest
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    //    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self/followed-by", @"method", nil];
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"users/self/media/recent", @"method", nil];
    
    [appDelegate.instagram requestWithParams:params
                                    delegate:self];

    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.userMediaArray count];
}

- (ImagesTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ImagesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[ImagesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier withCellHeight:[self tableView:tableView heightForRowAtIndexPath:indexPath]] autorelease];
    }
    
    cell.theImageView.image = nil;

    NSDictionary *imagesDictionary = [[self.userMediaArray objectAtIndex:indexPath.row] objectForKey:@"images"];
    NSDictionary *startResultionDictionary = [imagesDictionary objectForKey:@"standard_resolution"];
    [ImageAPIHandler makeImageRequestWithDelegate:self withInstagramMediaURLString:[startResultionDictionary objectForKey:@"url"] withImageView:cell.theImageView];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  306;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[self.userMediaArray objectAtIndex:indexPath.row]: %@", [self.userMediaArray objectAtIndex:indexPath.row]);
    

    ProductCreateViewController *productCreateViewController =  [[ProductCreateViewController alloc] initWithNibName:@"ProductCreateViewController" bundle:nil];
    productCreateViewController.productDictionary = [self.userMediaArray objectAtIndex:indexPath.row];
    [self presentViewController:productCreateViewController animated:YES completion:nil];
}





- (void)request:(IGRequest *)request didLoad:(id)result {
    
//    NSLog(@"Instagram did load: %@", result);
    NSArray *dataArray = [result objectForKey:@"data"];
    [self.userMediaArray addObjectsFromArray:dataArray];
    [self.theTableView reloadData];
    /*
    for (int i = 0; i < [dataArray count]; i++)
    {
        NSLog(@"dataArray[%d]: %@", i, [dataArray objectAtIndex:i]);
        NSLog(@" ");
        NSLog(@" ");        
    }
     */
}


- (void)request:(IGRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Instagram did fail: %@", error);
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}



@end
