//
//  InterestsViewController.m
//  Instashop
//
//  Created by Josh Klobe on 3/25/14.
//  Copyright (c) 2014 Josh Klobe. All rights reserved.
//

#import "InterestsViewController.h"
#import "CategorySelectCell.h"
#import "EnterEmailViewController.h"
@interface InterestsViewController ()

@end

@implementation InterestsViewController

@synthesize theTableView;
@synthesize selectionsArray;
@synthesize theParentController;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
 
    self.selectionsArray = [[NSMutableArray alloc] initWithCapacity:0];
    [self.selectionsArray addObject:@"Retailer/Brand"];
    [self.selectionsArray addObject:@"Publisher/Blogger"];
    [self.selectionsArray addObject:@"Shopper"];
    
    
    self.theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    self.theTableView.backgroundColor = [UIColor clearColor];
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    [self.view addSubview:self.theTableView];
    
    self.theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    

}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.selectionsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"Cell";
    
    CategorySelectCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CategorySelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    

    cell.disclosureImageView.alpha = 0;

    cell.theLabel.text = [self.selectionsArray objectAtIndex:indexPath.row];
    
    
    if (indexPath.row %2 == 0)
        cell.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menuDarkBG.png"]];
    else
        cell.bgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menuLightBG.png"]];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.theParentController categorySelectionCompleteWithString:[self.selectionsArray objectAtIndex:indexPath.row]];
}




@end
