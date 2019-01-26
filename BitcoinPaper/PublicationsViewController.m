//
//  DirectiveViewController.m
//  BitcoinPaper
//
//  Created by Joachim Neumann on 04/11/13.
//  Copyright (c) 2013 Joachim Neumann. All rights reserved.
//

#import "PublicationsViewController.h"
#import "ContentViewController.h"

@interface PublicationsViewController()
@end

@implementation PublicationsViewController
@synthesize directiveSearchBar;
@synthesize publicationsTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle: @"Bitcoin - The Paper"];
    [directiveSearchBar setText: [[Model instance] searchTerm]];
    [directiveSearchBar setDelegate: self];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont systemFontOfSize:14]];
    publicationsTableView.separatorColor = [UIColor clearColor];

}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[Model instance] publications] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cell_id = [NSString stringWithFormat:@"cell_%li_%li", (long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: cell_id];
    Publication* p = [[[Model instance] publications] objectAtIndex:[indexPath row]];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: cell_id];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;

        cell.textLabel.numberOfLines = 0;
        
        [cell.textLabel setText: [p title]];
        [cell.textLabel setTextColor: [UIColor blackColor]];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
        [cell.detailTextLabel setFont:[UIFont fontWithName:@"Helvetica" size:16]];
        [cell.detailTextLabel setLineBreakMode: NSLineBreakByCharWrapping];
        [cell.detailTextLabel setNumberOfLines:0];
        [cell.detailTextLabel setTextColor: [UIColor darkGrayColor]];
        
    }
    [cell.detailTextLabel setAttributedText: [p attributedSubTitle]];
    [cell setNeedsLayout];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.row) % 2) {
        cell.backgroundColor = [[UIColor alloc]initWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1];
    } else {
        // bright orange
        cell.backgroundColor = [[UIColor alloc]initWithRed:255.0/255.0 green:244.0/255.0 blue:225.0/255.0 alpha:1];
    }
    if (indexPath.row == 0) {
        // orange
        cell.backgroundColor = [[UIColor alloc]initWithRed:247.0/255.0 green:147.0/255.0 blue:26.0/255.0 alpha:1];
        [cell.textLabel setTextColor: [UIColor whiteColor]];
        [cell.detailTextLabel setTextColor: [UIColor whiteColor]];

    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [directiveSearchBar resignFirstResponder];
    [[Model instance] search: directiveSearchBar.text];
    [publicationsTableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	self.directiveSearchBar.text = nil;
	[self.directiveSearchBar resignFirstResponder];
    [self cancelSearch];
    [publicationsTableView reloadData];
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [directiveSearchBar setShowsCancelButton:YES animated:YES];
    [directiveSearchBar setText:@""];
    [self cancelSearch];
    [publicationsTableView reloadData];
    return YES;
}

- (void) cancelSearch {
    [[Model instance] setSearchResultText: @""];
    [[Model instance] cancelSearch];
    [publicationsTableView reloadData];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ContentViewController *contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    contentViewController.title = @"";
    contentViewController.publication = [[[Model instance] publications] objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:contentViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    if (screenWidth > 400) {
        return 70;
    } else {
        return 120;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSString *string = [[Model instance] searchResultText];
    if (string == nil) {
        return 0;
    } else {
        if (string.length == 0) return 0;
        return 20;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    NSString *string = [[Model instance] searchResultText];
    view = [[UIView alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width, 18)];

    UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithName:@"Helvetica Neue" size:16.0];
    UIFontDescriptor *symbolicFontDescriptor = [fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic];
    UIFont *fontWithDescriptor = [UIFont fontWithDescriptor:symbolicFontDescriptor size:16.0];
    
    [label setFont: fontWithDescriptor];
    [label setTextColor: [UIColor whiteColor]];
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor: [[UIColor alloc]initWithRed:247.0/255.0 green:147.0/255.0 blue:26.0/255.0 alpha:1]];
    return view;
}

//
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [[Model instance] searchResultText];
//}

@end
