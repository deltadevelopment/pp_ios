//
//  MessageController.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "MessageController.h"
#import "MessageModel.h"

@implementation MessageController
NSString *token;
NSString *key;
NSString *tmessageId;
NSString *tbody;
NSString *tuserId;
bool reply;

- (id)init
{
    self = [super init];
    NSLog(@"sssss");
    authHelper = [[AuthHelper alloc] init];
    parserHelper = [[ParserHelper alloc] init];
    applicationHelper = [[ApplicationHelper alloc] init];
    
    return self;
}
-(void)sendMessageToUser:(NSString *) userId message:(NSString*) body{
    NSDictionary *jsonBody = @{
                               @"message":@{
                                       @"body" : body,
                                       @"media_type" : @"1",
                                       @"media_key": key
                                       }
                               };
    

    //Create json body from dictionary
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:jsonBody];
    
    NSData *response2 = [self postHttpRequest:[NSString stringWithFormat:@"user/%@/message/%@", [authHelper getUserId], userId]  json:jsonData];
    NSMutableDictionary *dic2 = [parserHelper parse:response2];
     NSString *strdata=[[NSString alloc]initWithData:response2 encoding:NSUTF8StringEncoding];
    if(isErrors){
        //feil
        [mainTableViewController cantSendToFriend:strdata];
    }
   
    //NSLog(strdata);
}

-(void)sendMessageToUserWithImage:(NSString *) userId message:(NSString*) body imgData:(NSData *) img{
    tuserId = userId;
    tbody = body;
    reply = NO;
    [self uploadImage:img];
}

-(void)replyToUser:(NSString *) messageId message:(NSString *) body{
// /message/#{id}/reply
    NSDictionary *jsonBody = @{
                               @"message":@{
                                       @"body" : body,
                                       @"media_type" : @"1",
                                       @"media_key": key
                                       }
                               };
    
    
    //Create json body from dictionary
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:jsonBody];
    
    NSData *response2 = [self postHttpRequest:[NSString stringWithFormat:@"message/%@/reply", messageId]  json:jsonData];
    NSMutableDictionary *dic2 = [parserHelper parse:response2];
    if(isErrors){
          NSString *strdata=[[NSString alloc]initWithData:response2 encoding:NSUTF8StringEncoding];
        //feil
        [mainTableViewController cantSendToFriend:strdata];
    }
  
    //NSLog(strdata);
}

-(void)replyToUserWithImage:(NSString *) messageId message:(NSString *) body image:(NSData *) imgData{
   
    tbody = body;
    reply = YES;
    tmessageId = messageId;
    [self uploadImage:imgData];
    SEL selc = @selector(imageIsUploaded);
    imageUpload = selc;
    subClass = self;
}

-(void)imageIsUploaded{
    NSLog(@"here---------------------");
    if(reply){
        [self replyToUser:tmessageId message:tbody];
    }else{
        [self sendMessageToUser:tuserId message:tbody];
    }
}

-(void)generateImageUrl{
    NSData *response = [self getHttpRequest:@"message/generate_upload_url"];
    NSMutableDictionary *dic = [parserHelper parse:response];
    token = dic[@"url"];
    key = dic[@"key"];
    NSLog(@"token: %@ key%@", token, key);
}

-(void)uploadImage:(NSData*) data{
    [self puttHttpRequestWithImage:data token:token];
}

-(MessageModel *)getMessageFromUser:(NSString *) userId{
    NSLog(@"userID: %@", userId);
    NSData *response = [self getHttpRequest:[NSString stringWithFormat:@"user/%@/message/%@", userId, [authHelper getUserId]]];
    ParserHelper *parserHelper =[[ParserHelper alloc] init];
    NSMutableDictionary *dic = [parserHelper parse:response];
    MessageModel *message = [[MessageModel alloc] init];
    [message build:dic[@"message"]];
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(strdata);
    return message;
    ///user/#{id}/message/#{receiver_id}
}

-(MessageModel *)getMessageSentToUser:(NSString *) userId{
   // http://p1ngp0ng.herokuapp.com/user/2/message/3
    
    NSLog(@"userID: %@", userId);
    NSData *resp = [self getHttpRequest:[NSString stringWithFormat:@"user/%@/message/%@", [authHelper getUserId], userId]];
    ParserHelper *parserHelper =[[ParserHelper alloc] init];
    NSMutableDictionary *dic = [parserHelper parse:resp];
    MessageModel *message = [[MessageModel alloc] init];
    [message build:dic[@"message"]];
    NSString *strdata=[[NSString alloc]initWithData:resp encoding:NSUTF8StringEncoding];
    NSLog(strdata);
    return message;

}

-(void)deleteMessage:(NSString *) withId{
    NSLog(@"Deleting message");
    NSData *response = [self deleteHttpRequest:[NSString stringWithFormat:@"message/%@", withId]];
    ParserHelper *parserHelper =[[ParserHelper alloc] init];
    NSMutableDictionary *dic = [parserHelper parse:response];
    MessageModel *message = [[MessageModel alloc] init];
    [message build:dic[@"message"]];
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(strdata);

}

@end
