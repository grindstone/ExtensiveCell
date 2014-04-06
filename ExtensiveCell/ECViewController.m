//
//  ECViewController.m
//  ExtensiveCell
//
//  Created by Tanguy Hélesbeux on 02/11/2013.
//  Copyright (c) 2013 Tanguy Hélesbeux. All rights reserved.
//

#import "ECViewController.h"
#import "ExtensiveCellContainer.h"

@interface ECViewController () <UITableViewDataSource>

@property (strong, nonatomic) NSIndexPath *selectedRowIndexPath;

@end

@implementation ECViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [ExtensiveCellContainer registerNibToTableView:self.tableView];
    
}

-(void)reset{
    self.selectedRowIndexPath = nil;
}

#pragma mark Selection mecanism

- (void)setSelectedRowIndexPath:(NSIndexPath *)selectedRowIndexPath
{
    _selectedRowIndexPath = selectedRowIndexPath;
}

- (BOOL)isSelectedIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath && self.selectedRowIndexPath)
    {
        if (indexPath.row == self.selectedRowIndexPath.row && indexPath.section == self.selectedRowIndexPath.section)
        {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isExtendedCellIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath && self.selectedRowIndexPath)
    {
        if (indexPath.row == self.selectedRowIndexPath.row+1 && indexPath.section == self.selectedRowIndexPath.section)
        {
            return YES;
        }
    }
    return NO;
}

- (void)extendCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath) {
        [self.tableView beginUpdates];
        
        if (self.selectedRowIndexPath)
        {
            if ([self isSelectedIndexPath:indexPath])
            {
                NSIndexPath *tempIndexPath = self.selectedRowIndexPath;
                self.selectedRowIndexPath = nil;
                [self removeCellBelowIndexPath:tempIndexPath];
            }
            else if ([self isExtendedCellIndexPath:indexPath]);
            else
            {
                NSIndexPath *tempIndexPath = self.selectedRowIndexPath;
                if (indexPath.row > self.selectedRowIndexPath.row && indexPath.section == self.selectedRowIndexPath.section) {
                    indexPath = [NSIndexPath indexPathForRow:(indexPath.row-1) inSection:indexPath.section];
                }
                self.selectedRowIndexPath = indexPath;
                [self removeCellBelowIndexPath:tempIndexPath];
                [self insertCellBelowIndexPath:indexPath];
            }
        } else {
            self.selectedRowIndexPath = indexPath;
            [self insertCellBelowIndexPath:indexPath];
        }
        
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (void)insertCellBelowIndexPath:(NSIndexPath *)indexPath
{
    indexPath = [NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
    NSArray *pathsArray = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationTop];
}

- (void)removeCellBelowIndexPath:(NSIndexPath *)indexPath
{
    indexPath = [NSIndexPath indexPathForRow:(indexPath.row+1) inSection:indexPath.section];
    NSArray *pathsArray = @[indexPath];
    [self.tableView deleteRowsAtIndexPaths:pathsArray withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectedRowIndexPath && self.selectedRowIndexPath.section == section)
    {
        return [self numberOfRowsInSection:section] + 1;
    }
    return [self numberOfRowsInSection:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self numberOfSections];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self isExtendedCellIndexPath:indexPath]) {
        UIView *contentView = [self viewForContainerAtIndexPath:indexPath];
        if(contentView)
        {
            return 2*contentView.frame.origin.y + contentView.frame.size.height;
        }
        else{
            return [self heightForExtensiveCellAtIndexPath:indexPath];
        }

    } else {
        return [self heightForExtensiveCellAtIndexPath:indexPath];
    }
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
	if ([self isExtendedCellIndexPath:indexPath])
	{
		NSString				*identifier = [ExtensiveCellContainer reusableIdentifier];
		ExtensiveCellContainer	*cell		= [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        NSIndexPath *tmpPath = [NSIndexPath indexPathForItem:indexPath.row -1 inSection:indexPath.section];
        
		//[cell addContentView:[self viewForContainerAtIndexPath:indexPath]];
        [cell addContentView:[self viewForContainerAtIndexPath:tmpPath]];
		return cell;
	}
	else
	{
        UITableViewCell *cell = nil;
        
        if (self.selectedRowIndexPath&&self.selectedRowIndexPath.row < indexPath.row)
        {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:(indexPath.row - 1) inSection:indexPath.section];
            cell = [self extensiveCellForRowIndexPath:tmpIndexPath];
        }
        else
        {
            cell = [self extensiveCellForRowIndexPath:indexPath];
        }
		
		return cell;
	}
}

#pragma mark ECTableViewDataSource default

- (UITableViewCell *)extensiveCellForRowIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)heightForExtensiveCellAtIndexPath:(NSIndexPath *)indexPath
{
    return MAIN_CELLS_HEIGHT;
}

- (NSInteger)numberOfSections
{
    return 0;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UIView *)viewForContainerAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}



@end
