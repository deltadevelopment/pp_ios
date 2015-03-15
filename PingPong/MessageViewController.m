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
#import "MainTableViewController.h"

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
    
    textRecieved.hidden = YES;

    CALayer *textLayer = (CALayer *)[self.textRecieved.layer.sublayers objectAtIndex:0];
    textLayer.shadowColor = [UIColor blackColor].CGColor;
    textLayer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    textLayer.shadowOpacity = 1.0f;
    textLayer.shadowRadius = 0.0f;
    
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
-(void)setColor:(UIColor *) color{
    
    self.view.backgroundColor = color;

}


-(void)setFriend:(FriendModel*) friend withBool:(bool) isfromFriend{
    [self.indicator startAnimating];
    self.indicator.hidden = NO;
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
            [self.indicator stopAnimating];
            self.indicator.hidden = YES;
            textRecieved.selectable = YES;
            textRecieved.hidden = NO;
            textRecieved.text =[message body];
            textRecieved.selectable = NO;
            
        });
        
    });
    
    
   // NSLog(@"media url is: %@", [message media_url]);
    //self.navigationController.navigationBar.topItem.title =@"test";//[friend username];
    NSLog(@"USERNAM %@", [friend username]);
    [[self navigationItem] setTitle:[friend username]];
}

-(void)handleSwipeGestureRight{
    NSLog(@"sqipe right");
    if(tisFromFriend){
    //slett melding
        [messageController deleteMessage:[message Id]];
        
    }
    [self setView:[[MainTableViewController alloc] init] second:@"friendsNavigation"];
    //[self.navigationController pushViewController:[[MainTableViewController alloc] init] animated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void)setView:(UIViewController *)controller second:(NSString *) controllerString{
    //self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    controller = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:controllerString];
   
    [self presentViewController:controller animated:YES completion:NULL];
    //[self presentationController an]
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
