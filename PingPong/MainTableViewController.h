//
//  MainTableViewController.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewController : UITableViewController<UITextFieldDelegate>
- (IBAction)search:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addFriendButton;

@end
