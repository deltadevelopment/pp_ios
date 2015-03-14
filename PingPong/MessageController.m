//
//  MessageController.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "MessageController.h"

@implementation MessageController
NSString *token;
NSString *key;

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
    NSLog(strdata);
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

-(void)getMessageFromUser{
    ///user/#{id}/message/#{receiver_id}
    
}
@end
