//
//  SettingsController.m
//  PingPong
//
//  Created by Simen Lie on 15/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "SettingsController.h"
#import "FriendModel.h"
@implementation SettingsController
-(void)deleteUser{
    
    authHelper = [[AuthHelper alloc]init];
    NSData *response = [self deleteHttpRequest:[NSString stringWithFormat:@"user/%@", [authHelper getUserId]]];
    //Parse login request
    NSMutableDictionary *dic = [parserHelper parse:response];
    //Store parsed login data in sskey secure
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(strdata);
    
}
-(void)changePassword:(NSString*) newPassword{
    NSLog(@"testbruker");
    NSDictionary *body = @{
                           @"user":@{
                                   @"password" : newPassword
                                   }
                           };
    
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:body];
    //Create the request with the body
    //NSMutableURLRequest *request =[self postHttpRequest:@"login"  json:jsonData];
    NSData *response = [self putHttpRequest:[NSString stringWithFormat:@"user/%@", [authHelper getUserId]]  json:jsonData];
    //Parse login request
    NSMutableDictionary *dic = [parserHelper parse:response];
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(strdata);
    
}

-(FriendModel*)getUser{
    NSData *response = [self getHttpRequest:[NSString stringWithFormat:@"user/%@", [authHelper getUserId]]];
    //Parse login request
    NSMutableDictionary *dic = [parserHelper parse:response];
    FriendModel *user = [[FriendModel alloc] init];
    [user build:dic[@"user"]];
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(strdata);
    return user;
}
@end
