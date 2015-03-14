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
UIView *top;
UIBarButtonItem *exitButton;
UIBarButtonItem *currentLeft;
UITextField *searchText;

UIBarButtonItem *currentRight;

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

- (IBAction)search:(id)sender {
    [self setSearchUI];
}

-(void)exitSearch{
    [top removeFromSuperview];
    self.navigationItem.leftBarButtonItem=currentLeft;
    self.navigationItem.rightBarButtonItem=currentRight;
}

-(void)addFriend{
    NSLog(@"adding friend");
    [searchText resignFirstResponder];
    UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [activityView startAnimating];
    [activityView setHidden:NO];
    [activityView sizeToFit];
    [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    [self.navigationItem setRightBarButtonItem:loadingView];
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(userDoesNotExist)
                                   userInfo:nil
                                    repeats:NO];
    
}
-(void)getRequestIsDone{
    NSLog(@"hey");
    CGRect frameimg = CGRectMake(0, 0, 20, 20);
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:frameimg];
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"tick.png"] forState:UIControlStateNormal];
    UIBarButtonItem *btn =[[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    [self.navigationItem setRightBarButtonItem:btn];
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(exitSearch)
                                   userInfo:nil
                                    repeats:NO];

}

-(void)userDoesNotExist{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.957 green:0.263 blue:0.212 alpha:1];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1 green:0.596 blue:0 alpha:1];
    [UIView commitAnimations];
    [self setRightPlusButton];
    //searchText.placeholder = @"User doesnt exists";
    [searchText becomeFirstResponder];
    
    

}

-(void)setRightPlusButton{
    CGRect frameimg = CGRectMake(0, 0, 20, 20);
    UIButton *settingsButton = [[UIButton alloc] initWithFrame:frameimg];
    [settingsButton setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(addFriend)
             forControlEvents:UIControlEventTouchUpInside];
    exitButton =[[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    
    self.navigationItem.rightBarButtonItem=exitButton;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
        return YES;
    
   
    return YES;
}




-(void)setSearchUI{
   top= [[UIView alloc] init];
    [top setFrame:CGRectMake(0, 0, 200, 35)];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat center = (screenWidth/4) - (10);
    
    
    CGRect frameimg = CGRectMake(0, 0, 20, 20);
    currentRight = self.navigationItem.rightBarButtonItem;
    [self setRightPlusButton];
    

    UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
    [someButton setBackgroundImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(exitSearch)
         forControlEvents:UIControlEventTouchUpInside];
    exitButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    currentLeft = self.navigationItem.leftBarButtonItem;
    self.navigationItem.leftBarButtonItem=exitButton;
    
    
    searchText = [[UITextField alloc]init];
    [searchText setTextColor:[UIColor whiteColor]];
    [searchText setFrame:CGRectMake(-30, -2, 250, 40)];
    [searchText setPlaceholder:@"Enter your friends username"];
    searchText.delegate = self;
    
    UIButton *leftButton = [self createButton:@"feed-icon.png" x:center-80];
    UIButton *middleButton = [self createButton:@"events-icon.png" x:center];
    UIButton *rightButton = [self createButton:@"profile-icon.png" x:center + 80];
    //UILabel *label = [[UILabel alloc] init];
    //label.text = @"4";
    //[label setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:16]];
    //label.textColor = [UIColor whiteColor];
    //[label setFrame:CGRectMake(250, 0, 30, 30)];
    [rightButton addTarget:self
                    action:@selector(showProfile)
          forControlEvents:UIControlEventTouchUpInside];
    [leftButton addTarget:self
                   action:@selector(showFeed)
         forControlEvents:UIControlEventTouchUpInside];
    
   // [top addSubview:leftButton];
    //[top addSubview:middleButton];
    [top addSubview:searchText];
    //[top addSubview:label];
    self.navigationItem.titleView = top;
    //self.navigationItem.leftBarButtonItem = nil;
   // self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain
                                                                          //  target:nil action:nil];
}

-(UIButton *)createButton:(NSString *) img x:(int) xPos{
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *buttonImage = [UIImage imageNamed:img];
    //buttonImage = [self resizeImage:buttonImage newSize:CGSizeMake(30,30)];
    [navButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [navButton setTitleColor:[UIColor colorWithRed:0.4 green:0.157 blue:0.396 alpha:1]  forState:UIControlStateNormal];
    [navButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    // [navButton bringSubviewToFront:navButton.imageView];
    
    [navButton setFrame:CGRectMake(xPos, 0, 30, 30)];
    return navButton;
}



@end
