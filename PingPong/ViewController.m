//
//  ViewController.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ViewController.h"
#import "MainTableViewController.h"
#import "LoginController.h"

@interface ViewController ()

@end

@implementation ViewController
LoginController* loginController;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog([[UIDevice currentDevice] name]);
    NSString *name = [[UIDevice currentDevice] name];
    if(![name isEqualToString:@"Simen sin iPhone"]){
        self.usernameTextField.text = @"simentest";
        self.passwordTextField.text = @"simentest";
    }

    loginController = [[LoginController alloc] init];
    [self addLine:self.usernameTextField];
    [self addLine:self.passwordTextField];
    [super viewDidLoad];
    //loginController = [[LoginController alloc] init];
    self.usernameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    [self setTextFieldStyle:self.usernameTextField];
    [self setTextFieldStyle:self.passwordTextField];
    self.indicator.hidden = YES;
    self.errorOne.hidden = YES;
    self.errorTwo.hidden = YES;
   // self.loginButton.hidden = YES;
    [self.usernameTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    [self.passwordTextField addTarget:self
                               action:@selector(textFieldDidChange:)
                     forControlEvents:UIControlEventEditingChanged];
    [self setPlaceholderFont:self.usernameTextField];
    [self setPlaceholderFont:self.passwordTextField];
    //[self showLogin];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    //[self.usernameTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)textFieldDidChange:(UITextField *) textField{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.usernameTextField){
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
        return YES;
    }
    else if(textField == self.passwordTextField){
        //[self login:nil];
        [self.passwordTextField resignFirstResponder];
        return NO;
    }
    return YES;
}


-(void)keyboardWillShow:(NSNotification *)note {
    NSDictionary* info = [note userInfo];
    NSValue* aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    keyboardSize = [aValue CGRectValue].size;
    //NSLog(@"%d", keyboardSize.height);
    self.verticalConstraint.constant += keyboardSize.height;
}

-(void)keyboardWillHide {
    self.verticalConstraint.constant -= keyboardSize.height;
}

-(void)setTextFieldStyle:(UITextField *) textField{
    textField.borderStyle = UITextBorderStyleNone;
    [textField setBackgroundColor:[UIColor clearColor]];
}

-(void)addLine:(UITextField *) textField{
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height + 5, self.view.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.741 green:0.765 blue:0.78 alpha:1].CGColor;
    [textField.layer addSublayer:bottomBorder];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 20, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}


-(void)errorAnimation{
    [self.view setBackgroundColor:[UIColor colorWithRed:0.957 green:0.263 blue:0.212 alpha:1]];
    
    //Animate to black color over period of two seconds (changeable)
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:2];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [UIView commitAnimations];
}

-(void)setPlaceholderFont:(UITextField *) textField{
    [textField setValue:[UIFont fontWithName:@"HelveticaNeue-Italic" size:17] forKeyPath:@"_placeholderLabel.font"];
}

-(void)setView:(UIViewController *)controller second:(NSString *) controllerString{
    //self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    controller = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:controllerString];
    [self presentViewController:controller animated:NO completion:NULL];
}
-(void)showFriends{
    [self setView:[[MainTableViewController alloc] init] second:@"friendsNavigation"];
}

- (IBAction)login:(id)sender {
    //LOGIN og send til mainview
    
    [self.indicator setHidden:NO];
    
    [self.indicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [loginController login:self.usernameTextField.text pass:self.passwordTextField.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self.indicator stopAnimating];
            if([loginController hasError]){
                [self errorAnimation];
                NSLog(@"erors");
                 [self.indicator setHidden:YES];
            }else{
                [self showFriends];
            }
        });
    });
}

-(void)showError:(UILabel*) errorLabel
        errorMsg:(NSString*) error {
    
    if(error != nil){
        [errorLabel setHidden:false];
        errorLabel.text = error;
    }
    
    
}

- (IBAction)registerAction:(id)sender {
    [self.indicator setHidden:NO];
    
    [self.indicator startAnimating];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [loginController registerUser:self.usernameTextField.text pass:self.passwordTextField.text];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self.indicator stopAnimating];
            if([loginController hasError]){
                [self.indicator setHidden:YES];
                [self errorAnimation];
                [self showError:self.errorOne errorMsg:[loginController getUsernameError]];
                [self showError:self.errorTwo errorMsg:[loginController getPasswordError]];
                self.errorOne.hidden = NO;
                self.errorTwo.hidden = NO;
            }else{
                [self showFriends];
                self.errorOne.hidden = YES;
                self.errorTwo.hidden = YES;
            }
        });
    });
}
@end
