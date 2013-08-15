//
//  SizeQuantityTableViewController.m
//  Instashop
//
//  Created by Josh Klobe on 7/16/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "SizeQuantityTableViewController.h"
#import "SizeQuantityTableViewCell.h"
@interface SizeQuantityTableViewController ()

@end

@implementation SizeQuantityTableViewController

@synthesize cellSizeQuantityValueDictionary;
@synthesize availableSizesArray;
@synthesize rowShowCount;
@synthesize isButtonsDisabled;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cellSizeQuantityValueDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Menu_BG"]];
}

-(void)ownerAddRowButtonHitWithTableView:(UITableView *)theTableView
{
    if (self.rowShowCount > 0 && [[self getRemainingAvailableSizesArray] count] == 0)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                            message:@"No more sizes available"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
        else
        {
    self.rowShowCount++;
            [theTableView reloadData];
            //[theTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.rowShowCount -1  inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    
}


-(NSArray *)getRemainingAvailableSizesArray
{
    NSMutableArray *remainingSizesArray = [NSMutableArray arrayWithArray:self.availableSizesArray];
    
    for (id key in self.cellSizeQuantityValueDictionary)
    {
        NSDictionary *itemDictionary = [self.cellSizeQuantityValueDictionary objectForKey:key];
        NSString *usedSize = [itemDictionary objectForKey:SIZE_DICTIONARY_KEY];
        if (usedSize != nil)
            [remainingSizesArray removeObject:usedSize];
        
    }
    
    return remainingSizesArray;
    
            
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [tableView setSeparatorColor:[UIColor clearColor]];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.rowShowCount;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    SizeQuantityTableViewCell *cell = (SizeQuantityTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
    	NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SizeQuantityTableViewCell" owner:self options:nil];
    	cell = (SizeQuantityTableViewCell *)[nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    cell.parentController = self;
    [cell loadWithIndexPath:indexPath withContentDictionary:self.cellSizeQuantityValueDictionary];
    cell.avaliableSizesArray = [[NSArray alloc] initWithArray:[self getRemainingAvailableSizesArray]];
    
    if ([self.availableSizesArray count] == 0)
    {
        cell.sizeLabel.alpha = 0;
        cell.sizeButton.alpha = 0;
        
    }
    
    if (self.isButtonsDisabled)
    {
        cell.sizeButton.alpha = 0;
        cell.quantityButton.alpha = 0;
    }
    
    self.tableView.contentSize = CGSizeMake(0,0);
    return cell;
}

-(void)rowValueSelectedWithIndexPath:(NSIndexPath *)theIndexPath withKey:(NSString *)key withValue:(NSString *)value
{
    if (self.cellSizeQuantityValueDictionary == nil)
        self.cellSizeQuantityValueDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
                                                
                                                
        NSMutableDictionary *itemForRowDictionary = [self.cellSizeQuantityValueDictionary objectForKey:[NSString stringWithFormat:@"%d", theIndexPath.row]];
    if (itemForRowDictionary == nil)
        itemForRowDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [itemForRowDictionary setObject:value forKey:key];
    [self.cellSizeQuantityValueDictionary setObject:itemForRowDictionary forKey:[NSString stringWithFormat:@"%d", theIndexPath.row]];
    
    
    [self.tableView reloadData];
}

-(void)cellSelectedValue:(NSString *)value withIndexPath:(NSIndexPath *)indexPath
{
 
}

@end
