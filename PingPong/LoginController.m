//
//  LoginController.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "LoginController.h"

@implementation LoginController
NSDictionary* errors;
NSString *usernameError;
NSString *emailError;
NSString *passwordError;
-(void)login:(NSString *) username
        pass:(NSString *) password{
    //Logout
    [authHelper resetCredentials];
    //Create dictionary with username and password
    //NSString *uniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary *credentials = @{
                                  @"username" : username,
                                  @"password" : password
                                  };
    //Create json body from dictionary
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:credentials];
    //Create the request with the body
    //NSMutableURLRequest *request =[self postHttpRequest:@"login"  json:jsonData];
    NSData *response = [self postHttpRequest:@"login"  json:jsonData];
    //Parse login request
    NSMutableDictionary *dic = [parserHelper parse:response];
    //Store parsed login data in sskey secure
    [authHelper storeCredentials:dic];
    //Debugging
    NSLog([authHelper getAuthToken]);
    NSLog([authHelper getUserId]);
}

-(void)registerUser:(NSString *) username
               pass:(NSString *) password
{
    //Logout
    [authHelper resetCredentials];
    //Create dictionary with username and password
    NSDictionary *credentials = @{
                                  @"user":@{
                                          @"username" : username,
                                          @"password" : password
                                          }
                                  };
    //Create json body from dictionary
    NSString *jsonData = [applicationHelper generateJsonFromDictionary:credentials];
    //Create the request with the body
    //NSMutableURLRequest *request =[self postHttpRequest:@"login"  json:jsonData];
    NSData *response = [self postHttpRequest:@"register"  json:jsonData];
    //Parse login request
    NSMutableDictionary *dic = [parserHelper parse:response];
    NSMutableDictionary *dic2 = dic[@"errors"];
    NSArray *usernameErrorArray = dic2[@"username"];
    NSArray *passwordErrorArray = dic2[@"password"];
    NSArray *emailErrorArray = dic2[@"email"];
    usernameError =usernameErrorArray[0];
    emailError = emailErrorArray[0];
    passwordError = passwordErrorArray[0];
    
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"register: %@",strdata);
  
    //Store parsed login data in sskey secure
    if(!isErrors){
        [authHelper storeCredentials:dic[@"user"]];
    }
    
    
    //NSLog(usernameError);
    //  NSLog(passwordError[0]);
    // NSLog(emailError[0]);
};

-(NSString *) getUsernameError{
    if(usernameError == nil){
        return nil;
    }
    return [NSString stringWithFormat:@"%@ %@",@"Username",usernameError];
    
};
-(NSString *) getPasswordError{
    if(passwordError == nil){
        return nil;
    }
    return [NSString stringWithFormat:@"%@ %@",@"Password",passwordError];
};
@end
