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
#import "ComposeViewController.h"
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
SEL added;
FriendsController *friendsController;
NSIndexPath *currentIndexPath;
NSIndexPath *currentIndexPathFromCompose;
int sections = 1;
UIBarButtonItem *currentRight;
UIImageView *addedIndicator;
NSIndexPath *conversationCellId;
UIActivityIndicatorView *activityIndicator;
NSIndexPath *currentIndexPathAccepting;
bool isAccepting;
bool imageIsDoneUploading = YES;
- (void)viewDidLoad {
    selectorTest = @selector(userDoesNotExist);
    successSelector = @selector(getRequestIsDone);
    added = @selector(imageIsDone);
    friendsController =[[FriendsController alloc] init];
    [friendsController initFriends];
    [friendsController initFriendRequests];
    [friendsController test];
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@""
                                     style:UIBarButtonItemStyleBordered
                                    target:nil
                                    action:nil];
    
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestFriends)
                  forControlEvents:UIControlEventValueChanged];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
      NSLog(@"start");
   // friends = [[NSMutableArray alloc] initWithObjects:@"Roger",@"Simen", @"Chris", @"Frode", @"Christian", nil];
    friends = [friendsController getFriends];
    friendRequests = [friendsController getFriendRequests];
    if([friendRequests count] != 0){
        sections = 2;
        NSLog(@"sectionss");
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

-(void)ImageStartedUploading{
    imageIsDoneUploading = NO;
    MainTableViewCell *cell = [self.tableView cellForRowAtIndexPath:conversationCellId];
    cell.iconImage.image = nil;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = CGPointMake(12.5, 12.5);
    activityIndicator.hidesWhenStopped = NO;
    
    [cell.iconImage addSubview:activityIndicator];
    [activityIndicator startAnimating];
}
-(void)ImageIsUploaded{
    NSLog(@"IMAGE IS uploaded");
    //NSLog(@"%d",  conversationCellId);
    activityIndicator.hidden = YES;
    [activityIndicator stopAnimating];
    MainTableViewCell *cell = [self.tableView cellForRowAtIndexPath:conversationCellId];
    cell.iconImage.image = [UIImage imageNamed:@"tick.png"];
    [UIView animateWithDuration:0.3f
                          delay:0.5f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         cell.iconImage.alpha = 0.0;
                         
                     }
                     completion:^(BOOL finished){
                         cell.iconImage.image = [UIImage imageNamed:@"camera.png"];
                         cell.iconImage.alpha = 1;
                         [[friends objectAtIndex:conversationCellId.row] setFriendType:2];
                         imageIsDoneUploading = YES;
                     }];
    
}

-(SEL)getAdded{
    return added;
}

-(void)imageIsDone{
    //[self refresh];
    //load her
    
}

-(UIImageView*)getIndicator{
    return addedIndicator;
}

- (void)getLatestFriends {
    
    if(friendsController != nil){
    friendsController = [[FriendsController alloc] init];
    }
    [friendsController initFriends];
    [friendsController initFriendRequests];
    NSLog(@"friends: %lu", (unsigned long)[[friendsController getFriends] count]);
    [friendsController test];
    friends = [friendsController getFriends];
    for(FriendModel * friend in friends){
        NSLog([friend username]);
    }
    
    friendRequests = [friendsController getFriendRequests];
    if([friendRequests count] != 0){
        sections = 2;
    }
    [self.tableView reloadData];
    [self.view setNeedsDisplay];
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    self.refreshControl.attributedTitle = attributedTitle;
    [self.refreshControl endRefreshing];
    
    
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
        NSLog(@"%@", cell.nameLabel.text);
        cell.backgroundColor = [colorHelper getColor];
        [cell iconImage].userInteractionEnabled =YES;
        //UITapGestureRecognizer *tapGr;
        //tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMessage:)];
        //tapGr.numberOfTapsRequired = 1;
        //[tapGr setCancelsTouchesInView: YES];
        //[tapGr setDelegate: self];
        
        /*  
         1 = konvoloutt
         2 = bilde
         3 = video
         */
        //[[cell iconImage] addGestureRecognizer:tapGr];
        if([friend type] == 0){
            cell.iconImage.image = [UIImage imageNamed:@""];
        }else if ([friend type] == 1){
                 cell.iconImage.contentMode = UIViewContentModeScaleAspectFit;
            cell.iconImage.image = [UIImage imageNamed:@"message.png"];
       
            
        }
        else if ([friend type] == 2){
            cell.iconImage.image = [UIImage imageNamed:@"camera.png"];
            
        }
        else if ([friend type] == 3){
            cell.iconImage.image = [UIImage imageNamed:@"video.png"];
            
        }
        
        
        if(indexPath.row == [friends count] - 1){
            self.tableView.backgroundColor = cell.backgroundColor;
        }
    }else{
        FriendModel *friendRequest =[friendRequests objectAtIndex:indexPath.row];
        if([friendRequest isRequester]){
         //Ikke vis
        }
        cell.nameLabel.text = [friendRequest username];
        cell.backgroundColor = [colorHelper getColor];
        [cell iconImage].userInteractionEnabled =YES;
        [cell.iconImage setImage:[UIImage imageNamed:@"tick.png"]];
        UITapGestureRecognizer *tapGr;
        tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(acceptFriendRequest:)];
        tapGr.numberOfTapsRequired = 1;
        //[tapGr setCancelsTouchesInView: YES];
        //[tapGr setDelegate: self];
        [[cell iconImage] addGestureRecognizer:tapGr];
        if(indexPath.row == [friends count] - 1){
            self.tableView.backgroundColor = cell.backgroundColor;
        }
    
    }
    

    return cell;
}

-(void)setCurrentIndexPath:(NSIndexPath *) indexPath{
   currentIndexPathFromCompose = indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)path
{
    if(!isAccepting && imageIsDoneUploading){
        bool toggle = NO;
        MainTableViewCell *cell = [self.tableView cellForRowAtIndexPath:path];
        conversationCellId = path;
        
        MessageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"friend"];
        ComposeViewController *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"compose"];
        if(path.section == 0){
            FriendModel *friendModel = [friends objectAtIndex:path.row];
            
            /*
             1 = konvoloutt
             2 = bilde
             3 = video
             */
            if([friendModel type] == 1){
                //SE din venn
                toggle = YES;
                //[vc2 setShouldSendNew:NO];
                
                [vc setFriend:friendModel withBool:YES];
                [vc setColor:cell.backgroundColor];
            }
            else if([friendModel type] == 2 || [friendModel type] == 3){
                //Se meg selv
                //vise vc
                //[vc2 setColor:cell.backgroundColor];
                toggle = YES;
                [vc setFriend:friendModel withBool:NO];
                [vc setColor:cell.backgroundColor];
            }
            
            else {
                toggle = NO;
                [vc2 setShouldSendNew:YES];
                [vc2 setCurrentIndexPath:path];
                [vc2 setColor:cell.backgroundColor];
                [vc2 setFriend:friendModel];
                
            }
            
            NSLog(@" der: %@ ",[friendModel userId]);
            
            self.navigationItem.backBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:@""
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil];
            
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
            if(toggle){
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                [self.navigationController pushViewController:vc2 animated:YES];
            }
            
        }else{
            FriendModel *friendModel = [friendRequests objectAtIndex:path.row];
            //[vc setFriend:friendModel];
        }
    
    }
    
   
 

}


-(void)showMessage:(UITapGestureRecognizer *) sender{
    //NSLog(@"show");
    //MessageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"friend"];
    //[self.navigationController pushViewController:vc animated:YES];
}

-(void)acceptFriendRequest:(UITapGestureRecognizer *) sender{
    isAccepting = YES;
    CGPoint tapLocation = [sender locationInView:self.tableView];
    NSIndexPath *tapIndexPath = [self.tableView indexPathForRowAtPoint:tapLocation];
    FriendModel *friendRequest = [friendRequests objectAtIndex:tapIndexPath.row];
    //NSString *userId = [NSString stringWithFormat:@"%d", [friendRequest userId] ];
    
    MainTableViewCell *cell = [self.tableView cellForRowAtIndexPath:tapIndexPath];
    cell.iconImage.image = nil;
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.alpha = 1.0;
    activityIndicator.center = CGPointMake(12.5, 12.5);
    activityIndicator.hidesWhenStopped = NO;
    
    [cell.iconImage addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    SEL success = @selector(acceptSuccess);
    
    NSLog(@"adding friend");
    
    currentIndexPathAccepting = tapIndexPath;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [friendsController acceptFriendRequestFromUser:[friendRequest userId] withSucess:success andObject:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            
        });
        
    });
}
-(void)refresh{
    [friendsController initFriends];
    [friendsController initFriendRequests];
    [friendsController test];
    friends = [friendsController getFriends];
    friendRequests = [friendsController getFriendRequests];
}
-(void)acceptSuccess{
    NSLog(@"success");
    activityIndicator.hidden = YES;
    [activityIndicator stopAnimating];
    MainTableViewCell *cell = [self.tableView cellForRowAtIndexPath:currentIndexPathAccepting];
    cell.iconImage.image = [UIImage imageNamed:@"tick.png"];
    [UIView animateWithDuration:0.3f
                          delay:0.5f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         cell.iconImage.alpha = 0.0;
                         
                     }
                     completion:^(BOOL finished){
                          isAccepting = NO;
                         [self refresh];
                         [self.tableView reloadData];
                     }];
   
}




// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        NSLog(@"delete user ere");
        if(indexPath.section == 0){
            FriendModel *friendModel = [friends objectAtIndex:indexPath.row];
            SEL successSelector = @selector(deleteFriendSuccessful);
            currentIndexPath = indexPath;
            [friendsController deleteFriend:[friendModel userId] withSuccess:successSelector andObject:self];
        }else{
            FriendModel *friendModel = [friendRequests objectAtIndex:indexPath.row];

        }
        
    }
}

-(void)deleteFriendSuccessful{
//HER er  brukeren slettet
    NSLog(@"brukeren er slettet");
    
    [friends removeObjectAtIndex:currentIndexPath.row];
    [self.tableView reloadData];
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
