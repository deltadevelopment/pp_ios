//
//  SettingsViewController.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UIAlertViewDelegate, UITextFieldDelegate>
- (IBAction)logoutAction:(id)sender;
- (IBAction)deleteUser:(id)sender;
- (IBAction)changePass:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *changePass;




@end
