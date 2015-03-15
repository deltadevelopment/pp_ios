//
//  SettingsViewController.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SettingsViewController.h"
#import "AuthHelper.h"
#import "ViewController.h"
#import "SettingsController.h"
#import "FriendModel.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController
AuthHelper *authHelper;
SettingsController *settingsController;
- (void)viewDidLoad {
    self.changePass.hidden = YES;
    self.changePass.delegate = self;
    
    
    settingsController =[[SettingsController alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        FriendModel *user = [settingsController getUser];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self.nameLabel setTitle:[user username] forState:UIControlStateNormal ];
        });
        
    });
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
       [[self navigationItem] setTitle:@"Settings"];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    [settingsController changePassword:self.changePass.text];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logoutAction:(id)sender {
    authHelper =[[AuthHelper alloc] init];
    [authHelper resetCredentials];
     [self setView:[[ViewController alloc] init] second:@"login"];
    //LOGUT
}

-(void)setView:(UIViewController *)controller second:(NSString *) controllerString{
    //self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    controller = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:controllerString];
    [self presentViewController: controller animated:YES completion:nil];
}

- (IBAction)deleteUser:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Question"
                                                   message:@"Are you sure you want to delete account?"
                                                  delegate:self
                                         cancelButtonTitle:@"No"
                                         otherButtonTitles:@"Yes",nil];
    [alert show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 0 = Tapped yes
    if (buttonIndex == 0)
    {
        //ikke slett konto
    }else{
        //Slett konto
       
        [settingsController deleteUser];
        [authHelper resetCredentials];
        [self setView:[[ViewController alloc] init] second:@"login"];
        
    }
}


- (IBAction)changePass:(id)sender {
    self.changePass.hidden = NO;
    [self.changePass becomeFirstResponder];
    
}
@end
