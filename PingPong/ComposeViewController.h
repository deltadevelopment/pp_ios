//
//  ComposeViewController.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"
#import "MessageModel.h"
@interface ComposeViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
-(void)setFriend:(FriendModel*) friend;
-(void)setMessageFriend:(MessageModel*) message;
-(void)setShouldSendNew:(BOOL) should;
-(void)setCurrentIndexPath:(NSIndexPath *) indexPath;
-(void)setColor:(UIColor *) color;
@end
