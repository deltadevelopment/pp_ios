//
//  MessageController.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationController.h"

@interface MessageController : ApplicationController

-(void)sendMessageToUser:(NSString *) userId message:(NSString*) body;
-(void)uploadImage:(NSData*) data;
-(void)generateImageUrl;

@end
