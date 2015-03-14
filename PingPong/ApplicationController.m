//
//  ApplicationController.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController.h"
#import "ApplicationHelper.h"


@implementation ApplicationController


- (id)init
{
    self = [super init];
    if (self) {
        //imageUploaded = @selector(imageUploadDone);
        authHelper = [[AuthHelper alloc] init];
        parserHelper = [[ParserHelper alloc] init];
        applicationHelper = [[ApplicationHelper alloc] init];
    }
    return self;
}

-(NSData*)getResp:(NSMutableURLRequest *) request{
    NSURLResponse *response;
    NSError *error;
    
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    //NSLog(urlData);
    
    //  NSString *strdata=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    // NSLog(@"%@",strdata);
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    if([httpResponse statusCode] == 200 || [httpResponse statusCode] == 201){
        isErrors = false;
    }else if([httpResponse statusCode] == 403 ){
        //[authHelper resetCredentials];
        [authHelper resetCredentials];
        isErrors = true;
    }
    else{
        NSLog(@"ERROR");
        isErrors = true;
    }
    
    NSLog(@"response status code: %ld on %@", (long)[httpResponse statusCode], [request URL]);
    return urlData;
}

-(NSData *) getHttpRequest:(NSString *) url{
    NSURL * serviceUrl = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"text" forHTTPHeaderField:@"Content-type"];
    [serviceRequest addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [serviceRequest setHTTPMethod:@"GET"];
    return [self getResp:serviceRequest];
};
-(BOOL)hasError{
    return isErrors;
};


-(NSData *) postHttpRequest:(NSString *) url
                       json:(NSString *) data{
    NSURL * serviceUrl = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSLog(@"",serviceUrl);
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [serviceRequest addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [serviceRequest setHTTPMethod:@"POST"];
    [serviceRequest setHTTPBody:[data dataUsingEncoding:NSASCIIStringEncoding]];
    return [self getResp:serviceRequest];
};

-(NSData *) deleteHttpRequest:(NSString *) url{
    NSURL * serviceUrl = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"text" forHTTPHeaderField:@"Content-type"];
    [serviceRequest addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [serviceRequest setHTTPMethod:@"DELETE"];
    return [self getResp:serviceRequest];
    
};
-(NSData *) putHttpRequest:(NSString *) url
                      json:(NSString *) data{
    NSURL * serviceUrl = [NSURL URLWithString:[applicationHelper generateUrl:url]];
    NSMutableURLRequest * serviceRequest = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceRequest setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [serviceRequest addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [serviceRequest setHTTPMethod:@"PUT"];
    [serviceRequest setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    return [self getResp:serviceRequest];
    
};

@end
