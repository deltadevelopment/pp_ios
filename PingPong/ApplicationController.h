//
//  ApplicationController.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParserHelper.h"
#import "AuthHelper.h"
#import "ApplicationHelper.h"

@interface ApplicationController : NSObject<NSURLConnectionDataDelegate>{
    AuthHelper *authHelper;
    ParserHelper *parserHelper;
    ApplicationHelper *applicationHelper;
    BOOL isErrors;
    NSURLConnection *connection;
  //  UILabel *loadingLabel;
   // UIImageView *imageDone;
    SEL aSelector;
    SEL imageUploaded;
    NSObject *currentObject;
}

-(NSData *) getHttpRequest:(NSString *) url;
-(NSData  *) postHttpRequest:(NSString *) url
                        json:(NSString *) data;
-(NSData  *) deleteHttpRequest:(NSString *) url;
-(NSData  *) putHttpRequest:(NSString *) url
                       json:(NSString *) data;
-(void)puttHttpRequestWithImage:(NSData *) imageData token:(NSString *) token;

-(BOOL)hasError;

@end
