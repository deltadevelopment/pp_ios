//
//  MessageController.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationController.h"
#import "MessageModel.h"
@interface MessageController : ApplicationController

-(void)sendMessageToUser:(NSString *) userId message:(NSString*) body;
-(void)uploadImage:(NSData*) data;
-(void)generateImageUrl;
-(MessageModel *)getMessageFromUser:(NSString *) userId;
-(void)replyToUser:(NSString *) messageId message:(NSString *) body;
-(void)replyToUserWithImage:(NSString *) messageId message:(NSString *) body image:(NSData *) imgData;
-(void)sendMessageToUserWithImage:(NSString *) userId message:(NSString*) body imgData:(NSData *) img;
-(void)imageIsUploaded;
-(MessageModel *)getMessageSentToUser:(NSString *) userId;
@end
