//
//  CameraHelper.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "CameraHelper.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@implementation CameraHelper
AVCaptureSession *session;
AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
AVCaptureStillImageOutput * stillImageOutput;
AVCaptureDevice *frontCamera;
CGRect screenBound;
CGSize screenSize;
CGFloat screenWidth;
CGFloat screenHeight;
NSData *imgTakenData;

UIImage *imgTaken;
-(id)init{
    screenBound = [[UIScreen mainScreen] bounds];
    screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    return self;
}
- (void) initializeCamera:(UIView *) cameraView {
    
    
    session = [[AVCaptureSession alloc] init];
    
    
    session.sessionPreset = AVCaptureSessionPresetPhoto;
    
    captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
    
    [captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    CGRect rect = cameraView.bounds;
    rect.size.height = screenHeight;
    rect.size.width = screenWidth;
    cameraView.bounds = rect;
    NSLog(@"height: %f",cameraView.bounds.size.height);
    captureVideoPreviewLayer.frame = cameraView.bounds;
    
    //[cameraView.layer addSublayer:captureVideoPreviewLayer];
    //[cameraView.layer insertSublayer:captureVideoPreviewLayer atIndex:0];
    
    
    
    UIView *view = cameraView;
    CALayer *viewLayer = [view layer];
    [viewLayer setMasksToBounds:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        CGRect bounds = [view bounds];
        [captureVideoPreviewLayer setFrame:bounds];
        
        NSArray *devices = [AVCaptureDevice devices];
        
        for (AVCaptureDevice *device in devices) {
            
            NSLog(@"Device name: %@", [device localizedName]);
            
            if ([device hasMediaType:AVMediaTypeVideo]) {
                
                if ([device position] == AVCaptureDevicePositionBack) {
                    NSLog(@"Device position : back");
                    //frontCamera = device;
                }
                else {
                    NSLog(@"Device position : front");
                    frontCamera = device;
                }
            }
        }
        //Denne biten inn i annen kode
        NSError *error = nil;
        AVCaptureDeviceInput *input;
       
            input = [AVCaptureDeviceInput deviceInputWithDevice:frontCamera error:&error];
        
        
        if (!input) {
            NSLog(@"ERROR: trying to open camera: %@", error);
        }
        [session addInput:input];
        //SLUTT BIt I KODE HER
        stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [stillImageOutput setOutputSettings:outputSettings];
        
        [session addOutput:stillImageOutput];
        
        [session startRunning];
        
    });
}
-(UIImage *) getImage{
    return imgTaken;
}
-(NSData *) getImageAsData{
    return imgTakenData;
}
- (void) takePicture:(UIView *) view setImageAtView:(UIView*) view2 { //method to capture image from AVCaptureSession video feed
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in stillImageOutput.connections) {
        
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        
        if (videoConnection) {
            break;
        }
    }
    
    NSLog(@"about to request a capture from: %@", stillImageOutput);
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        if (imageSampleBuffer != NULL) {
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
            //imgTakenData = imageData;
            imgTaken = [UIImage imageWithData:imageData];
            
            CGSize size = CGSizeMake(screenWidth, screenHeight);
            NSLog(@"%f", screenHeight);
            //UIImageView *imgView2 =[[UIImageView alloc] initWithFrame:CGRectMake(0,100, screenWidth,screenHeight)];
            //imgView2.image = [self imageByScalingAndCroppingForSize:size img:imgTaken];
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[self imageByScalingAndCroppingForSize:size img:imgTaken]];
            view2.hidden = NO;
            //[view2 insertSubview:imgView atIndex:0];
            CGRect cropRect = CGRectMake(0 ,0 ,screenWidth ,screenHeight);
            UIGraphicsBeginImageContextWithOptions(cropRect.size, view, 1.0f);
            [imgTaken drawInRect:cropRect];
            UIImage * customScreenShot = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSData* data = UIImagePNGRepresentation(customScreenShot);
            imgTakenData = data;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //[feedController sendImageToServer:data];
                
                
            });
            //UIImage *imgTaken = [UIImage imageWithData:imageData];
            
            //[feed removeObjectAtIndex:0];
            
            [session stopRunning];
            [captureVideoPreviewLayer removeFromSuperlayer];
            //_tableView.scrollEnabled = YES;
            //self.cancelButton.hidden = YES;
           // [_tableView reloadData];
            //[self processImage:[UIImage imageWithData:imageData]];
        }
        
    }];
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



@end
