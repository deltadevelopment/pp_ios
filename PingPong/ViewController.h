//
//  ViewController.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>{
   CGSize keyboardSize;
}
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verticalConstraint;
- (IBAction)login:(id)sender;
- (IBAction)registerAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *errorOne;
@property (weak, nonatomic) IBOutlet UILabel *errorTwo;
@property (weak, nonatomic) IBOutlet UILabel *errorThree;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;








@end

