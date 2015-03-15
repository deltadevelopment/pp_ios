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
#import "MessageModel.h"
#import "MessageController.h"
#import "CameraHelper.h"

@interface MessageViewController ()

@end

@implementation MessageViewController
@synthesize textRecieved;
@synthesize messageController;
ComposeViewController *composeViewController;
FriendModel *currentFriend;
CGRect screenBound;
CGSize screenSize;
CGFloat screenWidth;
CGFloat screenHeight;
bool tisFromFriend;
MessageModel *message;

- (void)viewDidLoad {
    [super viewDidLoad];
    screenBound = [[UIScreen mainScreen] bounds];
    screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    self.imageRecieved.userInteractionEnabled =YES;
    if(messageController == nil){
    messageController =[[MessageController alloc] init];
    }
    
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


-(void)setFriend:(FriendModel*) friend withBool:(bool) isfromFriend{
    tisFromFriend = isfromFriend;
    currentFriend = friend;
    NSLog(@"------------------------");
    
    if(messageController == nil){
        messageController =[[MessageController alloc] init];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if(isfromFriend){
            message = [messageController getMessageFromUser:[currentFriend userId]];
        }else{
            message =[messageController getMessageSentToUser:[currentFriend userId]];
        }
        
        NSData *data =[message getMedia];
        
        NSLog(@"----------HER");
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            CameraHelper *cameraHelper = [[CameraHelper alloc]init];
            CGSize size = CGSizeMake(screenWidth, screenHeight);
            
            self.imageRecieved.image =  [cameraHelper imageByScalingAndCroppingForSize:size img:[UIImage imageWithData:data]];
            textRecieved.selectable = YES;
            textRecieved.text =[message body];
            textRecieved.selectable = NO;
        });
        
    });
    
    
   // NSLog(@"media url is: %@", [message media_url]);
    //self.navigationController.navigationBar.topItem.title =@"test";//[friend username];
    [[self navigationItem] setTitle:[friend username]];
}

-(void)handleSwipeGestureRight{
    NSLog(@"sqipe right");
}

-(void)handleSwipeGestureLeft{
    if(tisFromFriend){
        NSLog(@"sqipe left");
        //composeViewController=[[ComposeViewController alloc] initWithNibName:@"ComposeViewController" bundle:[NSBundle mainBundle]];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        composeViewController = [storyboard instantiateViewControllerWithIdentifier:@"compose"];
        [composeViewController setMessageFriend:message];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.75;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromRight;
        transition.delegate = self;
        [self.view.layer addAnimation:transition forKey:nil];
        [self.view addSubview:composeViewController.view];
        //[self presentViewController:composeViewController animated:NO completion:nil];
    }

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
