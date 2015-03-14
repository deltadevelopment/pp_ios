//
//  ComposeViewController.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"
@interface ComposeViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
-(void)setFriend:(FriendModel*) friend;

@end
