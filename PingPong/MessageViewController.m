//
//  MessageViewController.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "MessageViewController.h"
#import "ComposeViewController.h"
#import "FriendModel.h"
#import "MessageController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController
ComposeViewController *composeViewController;
FriendModel *currentFriend;
MessageController* messageController;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageRecieved.userInteractionEnabled =YES;
    messageController =[[MessageController alloc] init];
    UISwipeGestureRecognizer *swipeRightGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureRight)];
    swipeRightGesture.direction=UISwipeGestureRecognizerDirectionRight;
    swipeRightGesture.numberOfTouchesRequired = 1;
    [self.textRecieved addGestureRecognizer:swipeRightGesture];
    
    UISwipeGestureRecognizer *swipeRightGesture2=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureLeft)];
    swipeRightGesture2.direction=UISwipeGestureRecognizerDirectionLeft;
    swipeRightGesture2.numberOfTouchesRequired = 1;
    [self.textRecieved addGestureRecognizer:swipeRightGesture2];
    //[self sendMessage];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    // [self.navigationItem.rightBarButtonItem setBackgroundImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal barMetrics:nil];
}

-(void)sendMessage{
    [messageController sendMessageToUser:@"4" message:@"Hei hei"];
}

-(void)setFriend:(FriendModel*) friend{
    currentFriend = friend;
    //self.navigationController.navigationBar.topItem.title =@"test";//[friend username];
    [[self navigationItem] setTitle:[friend username]];
}

-(void)handleSwipeGestureRight{
    NSLog(@"sqipe right");
}

-(void)handleSwipeGestureLeft{
    NSLog(@"sqipe left");
    //composeViewController=[[ComposeViewController alloc] initWithNibName:@"ComposeViewController" bundle:[NSBundle mainBundle]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    composeViewController = [storyboard instantiateViewControllerWithIdentifier:@"compose"];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.75;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
    [self.view addSubview:composeViewController.view];
    //[self presentViewController:composeViewController animated:NO completion:nil];
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

@end
