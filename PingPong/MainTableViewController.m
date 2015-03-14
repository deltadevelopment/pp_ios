//
//  MainTableViewController.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "MainTableViewController.h"
#import "MainTableViewCell.h"
#import "ColorHelper.h"
#import "SettingsViewController.h"
#import "MessageViewController.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController
NSMutableArray *friends;
ColorHelper* colorHelper;

- (void)viewDidLoad {
    [super viewDidLoad];
      NSLog(@"start");
    friends = [[NSMutableArray alloc] initWithObjects:@"Roger",@"Simen", @"Chris", @"Frode", @"Christian", nil];
    self.tableView.allowsSelection = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    colorHelper = [[ColorHelper alloc] init];
    [colorHelper initColors];
    self.tableView.separatorColor = [UIColor clearColor];
    
    UIImage* image3 = [UIImage imageNamed:@"settings.png"];
    CGRect frameimg = CGRectMake(0, 0, 20, 20);
    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:image3 forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(showSettings)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem=mailbutton;
    
    
    
   // self.navigationItem.leftBarButtonItem
    
}

-(void)showSettings{
    SettingsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"friendCell";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[MainTableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.nameLabel.text = [friends objectAtIndex:indexPath.row];
    cell.backgroundColor = [colorHelper getColor];
    [cell iconImage].userInteractionEnabled =YES;
    UITapGestureRecognizer *tapGr;
    tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMessage:)];
    tapGr.numberOfTapsRequired = 1;
    [tapGr setCancelsTouchesInView: YES];
    //[tapGr setDelegate: self];
    [[cell iconImage] addGestureRecognizer:tapGr];

    return cell;
}


-(void)showMessage:(UITapGestureRecognizer *) sender{
    NSLog(@"show");
    MessageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"friend"];
    [self.navigationController pushViewController:vc animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
