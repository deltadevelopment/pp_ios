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
bool shouldNotDelete;
- (void)viewDidLoad {
     shouldNotDelete = NO;
    [super viewDidLoad];
    screenBound = [[UIScreen mainScreen] bounds];
    screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    self.imageRecieved.userInteractionEnabled =YES;
    if(messageController == nil){
    messageController =[[MessageController alloc] init];
    }
    
    self.navigationController.navigationItem.leftBarButtonItem.target = self;
    self.navigationController.navigationItem.leftBarButtonItem.action = @selector(backButtonDidPressed:);
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        //[self.delegate setParentSelectedCity:self.selectedCity];
        
    }
    [super viewWillDisappear:animated];
    if(!shouldNotDelete){
        [messageController deleteMessage:[message Id]];
    }
}

- (void)backButtonDidPressed:(id)aResponder {
    NSLog(@"skal slette her");
    
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(void)sendMessage{
    [messageController sendMessageToUser:@"4" message:@"Hei hei"];
}
-(void)setColor:(UIColor *) color{
    
    self.view.backgroundColor = color;

}

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage
{
    NSLog(@"----SCALING IMAGE");
    // NSLog(@"THE size is width: %f height: %f", targetSize.width, targetSize.height);
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        
        //NSLog(@"fit height %f", targetSize.width);
        scaleFactor = widthFactor; // scale to fit height
        
        
        
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = 0;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = 0;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
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
            
            CGSize size = CGSizeMake(screenWidth, screenHeight);
            
            self.imageRecieved.image =  [self imageByScalingAndCroppingForSize:size img:[UIImage imageWithData:data]];
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
    //[self setView:[[MainTableViewController alloc] init] second:@"friendsNavigation"];
     [self.navigationController popToRootViewControllerAnimated:YES];
    //MainTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"friendsNavigation"];
    //[self.navigationController pushViewController:[[MainTableViewController alloc] init] animated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
    // [self presentViewController:vc animated:YES completion:NULL];
}

-(void)setView:(UIViewController *)controller second:(NSString *) controllerString{
    //self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    controller = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:controllerString];
    //[self.window makeKeyAndVisible];
    [self.navigationController pushViewController:controller animated:NO];
    
    
}





-(void)handleSwipeGestureLeft{
    if(tisFromFriend){
        /*
        NSLog(@"sqipe left");
        //composeViewController=[[ComposeViewController alloc] initWithNibName:@"ComposeViewController" bundle:[NSBundle mainBundle]];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        composeViewController = [storyboard instantiateViewControllerWithIdentifier:@"compose"];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.75;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromRight;
        transition.delegate = self;
        [self.view.layer addAnimation:transition forKey:nil];
        [self.view addSubview:composeViewController.view];
        //[self presentViewController:composeViewController animated:NO completion:nil];
        */
        shouldNotDelete = YES;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        composeViewController = [storyboard instantiateViewControllerWithIdentifier:@"compose"];
        [composeViewController setMessageFriend:message];
         [self setView:composeViewController second:@"compose"];
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
