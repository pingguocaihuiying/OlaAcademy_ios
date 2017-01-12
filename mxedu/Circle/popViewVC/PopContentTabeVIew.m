//
//  PopContentTabeVIew.m
//  NTreat
//
//  Created by 周冉 on 16/6/7.
//  Copyright © 2016年 田晓鹏. All rights reserved.
//

#import "PopContentTabeVIew.h"
@interface PopContentTabeVIew ()

@end

@implementation PopContentTabeVIew
@synthesize delegate=_delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Popover Title";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return  [self.delegate.modalDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"  %@",[[self.delegate.modalDataArray objectAtIndex:indexPath.row] objectForKey:@"titleName"]];
    
    return cell;
}


#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if([self.delegate respondsToSelector:@selector(selectedTableRow:)])
    {
        [self.delegate selectedTableRow:indexPath];
    }
}




@end
