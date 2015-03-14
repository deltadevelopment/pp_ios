//
//  ComposeViewController.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ComposeViewController.h"
#import "CameraHelper.h"
@interface ComposeViewController ()

@end

@implementation ComposeViewController
CameraHelper *cameraHelper;
- (void)viewDidLoad {
    [super viewDidLoad];
    cameraHelper = [[CameraHelper alloc] init];
    [self.textView becomeFirstResponder];
    self.textView.delegate = self;
    int random = rand()%4;
    float value =[[NSNumber numberWithInt:random] floatValue];
    [cameraHelper initializeCamera:self.cameraView];

    [NSTimer scheduledTimerWithTimeInterval:value
                                     target:self
                                   selector:@selector(takePicture)
                                   userInfo:nil
                                    repeats:NO];
    // Do any additional setup after loading the view.
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
