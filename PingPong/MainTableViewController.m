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
#import "FriendsController.h"
#import "FriendModel.h"
@interface MainTableViewController ()

@end

@implementation MainTableViewController
NSMutableArray *friends;
NSMutableArray *friendRequests;
ColorHelper* colorHelper;
UIView *top;
UIBarButtonItem *exitButton;
UIBarButtonItem *currentLeft;
UITextField *searchText;
UIView *currentTitleView;
SEL selectorTest;
SEL successSelector;
FriendsController *friendsController;
int sections = 1;
UIBarButtonItem *currentRight;

- (void)viewDidLoad {
    selectorTest = @selector(userDoesNotExist);
    successSelector = @selector(getRequestIsDone);
    friendsController =[[FriendsController alloc] init];
    [friendsController initFriends];
    [friendsController initFriendRequests];
    [super viewDidLoad];
      NSLog(@"start");
   // friends = [[NSMutableArray alloc] initWithObjects:@"Roger",@"Simen", @"Chris", @"Frode", @"Christian", nil];
    friends = [friendsController getFriends];
    friendRequests = [friendsController getFriendRequests];
    if([friendRequests count] != 0){
        sections = 2;
    }
    //self.tableView.allowsSelection = NO;

    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
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

-(void)testSelector{
    NSLog(@"testSELector");
}



-(void)showSettings{
    SettingsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
    
    
    
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
        //return @"Section 1";
    }
    
    if(section == 1){
       // return @"Friend requests";
    }
    return nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        // Return the number of rows in the section.
        return [friends count];
    }
    else{
        return [friendRequests count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"friendCell";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil){
        cell = [[MainTableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.section == 0){
        FriendModel *friend =[friends objectAtIndex:indexPath.row];
        cell.nameLabel.text = [friend username];
        cell.backgroundColor = [colorHelper getColor];
        [cell iconImage].userInteractionEnabled =YES;
        UITapGestureRecognizer *tapGr;
        tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMessage:)];
        tapGr.numberOfTapsRequired = 1;
        [tapGr setCancelsTouchesInView: YES];
        //[tapGr setDelegate: self];
        [[cell iconImage] addGestureRecognizer:tapGr];
        if(indexPath.row == [friends count] - 1){
            self.tableView.backgroundColor = cell.backgroundColor;
        }
    }else{
        FriendModel *friendRequest =[friendRequests objectAtIndex:indexPath.row];
        cell.nameLabel.text = [friendRequest username];
        cell.backgroundColor = [colorHelper getColor];
        [cell iconImage].userInteractionEnabled =YES;
        [cell.iconImage setImage:[UIImage imageNamed:@"tick.png"]];
        UITapGestureRecognizer *tapGr;
        tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMessage:)];
        tapGr.numberOfTapsRequired = 1;
        [tapGr setCancelsTouchesInView: YES];
        //[tapGr setDelegate: self];
        [[cell iconImage] addGestureRecognizer:tapGr];
        if(indexPath.row == [friends count] - 1){
            self.tableView.backgroundColor = cell.backgroundColor;
        }
    
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)path
{
    
    MessageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"friend"];
    
    if(path.section == 0){
        FriendModel *friendModel = [friends objectAtIndex:path.row];
        [vc setFriend:friendModel];
    }else{
        FriendModel *friendModel = [friendRequests objectAtIndex:path.row];
        [vc setFriend:friendModel];
    }
    [self.navigationController pushViewController:vc animated:YES];

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
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:1 green:0.596 blue:0 alpha:1];
    self.navigationItem.titleView = currentTitleView;
}

-(void)addFriend{
    NSLog(@"adding friend");
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [friendsController addFriend:searchText.text withSelector:selectorTest withSuccess:successSelector withObject:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
         
        });
        
    });

    [searchText resignFirstResponder];
    UIActivityIndicatorView * activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [activityView startAnimating];
    [activityView setHidden:NO];
    [activityView sizeToFit];
    [activityView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)];
    UIBarButtonItem *loadingView = [[UIBarButtonItem alloc] initWithCustomView:activityView];
    [self.navigationItem setRightBarButtonItem:loadingView];
    /*[NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(userDoesNotExist)
                                   userInfo:nil
                                    repeats:NO];
    */
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
    
    //ADD user to list

}

-(void)userDoesNotExist{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.957 green:0.263 blue:0.212 alpha:1];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.737 blue:0.831 alpha:1];
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
     self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0 green:0.737 blue:0.831 alpha:1];
  
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
    [searchText setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [searchText setAutocorrectionType:UITextAutocorrectionTypeNo];
    [searchText setFrame:CGRectMake(-30, -2, 250, 40)];
    [searchText setPlaceholder:@"Enter your friends username"];
    searchText.delegate = self;
    [searchText becomeFirstResponder];
    
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
    currentTitleView = self.navigationItem.titleView;
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
