//
//  MessageViewController.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"
#import "MessageController.h"
@interface MessageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageRecieved;
@property (weak, nonatomic) IBOutlet UITextView *textRecieved;
@property (strong, nonatomic) MessageController* messageController;
-(void)setFriend:(FriendModel*) friend withBool:(bool) isfromFriend;
-(void)setShouldReply:(BOOL) should;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
-(void)setColor:(UIColor *) color;
@end
