//
//  CameraHelper.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CameraHelper : NSObject<UIImagePickerControllerDelegate>
- (void) initializeCamera:(UIView *) cameraView;
- (void) takePicture:(UIView *) view setImageAtView:(UIView*) view2;
-(UIImage *) getImage;
-(NSData *) getImageAsData;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize img:(UIImage *) sourceImage;
@end
