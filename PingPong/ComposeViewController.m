//
//  ComposeViewController.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ComposeViewController.h"
#import "CameraHelper.h"
#import "MessageController.h"
#import "FriendModel.h"
@interface ComposeViewController ()

@end

@implementation ComposeViewController
CameraHelper *cameraHelper;
MessageController *messageController;
FriendModel *currentFriend;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *swipeRightGesture2=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sendMessage)];
    swipeRightGesture2.direction=UISwipeGestureRecognizerDirectionLeft;
    swipeRightGesture2.numberOfTouchesRequired = 1;
    [self.textView addGestureRecognizer:swipeRightGesture2];
    
    messageController = [[MessageController alloc] init];
   
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [messageController generateImageUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            
        });
        
    });
    
    
    cameraHelper = [[CameraHelper alloc] init];
    [self.textView becomeFirstResponder];
    self.textView.delegate = self;
    int random = rand()%6;
    float value =[[NSNumber numberWithInt:random] floatValue];
    [cameraHelper initializeCamera:self.cameraView];

    [NSTimer scheduledTimerWithTimeInterval:value
                                     target:self
                                   selector:@selector(takePicture)
                                   userInfo:nil
                                    repeats:NO];
    // Do any additional setup after loading the view.
}

-(void)sendMessage{
//
    NSLog(@"Send message here");
    //STEP 1
    [messageController uploadImage:[cameraHelper getImageAsData]];
    
    //STEP 2
   [messageController sendMessageToUser:[currentFriend userId] message:self.textView.text];
}

-(void)setFriend:(FriendModel*) friend{
    currentFriend = friend;
}

-(void)takePicture{
    NSLog(@"taking picture");
    [cameraHelper takePicture:self.view setImageAtView:self.cameraView];
    if([cameraHelper getImage] == nil){
        NSLog(@"nill");
    }
   
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
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
