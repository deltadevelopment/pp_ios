//
//  MessageViewController.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageRecieved;
@property (weak, nonatomic) IBOutlet UITextView *textRecieved;

@end
