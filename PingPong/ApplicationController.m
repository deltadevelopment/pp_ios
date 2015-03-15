//
//  ApplicationController.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ApplicationController.h"
#import "ApplicationHelper.h"
#import "ViewController.h"
#import "MessageController.h"

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

-(void)setView:(UIViewController *)controller second:(NSString *) controllerString{
    //self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    controller = (UIViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:controllerString];
  
    
    UIViewController *root = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
 
    [root presentViewController: controller animated:YES completion:nil];
    
    
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
        [self setView:[[ViewController alloc] init] second:@"login"];
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
    NSMutableURLRequest * serviceReq = [NSMutableURLRequest requestWithURL:serviceUrl];
    [serviceReq setValue:@"text" forHTTPHeaderField:@"Content-type"];
    [serviceReq addValue:[authHelper getAuthToken] forHTTPHeaderField:@"X-AUTH-TOKEN"];
    [serviceReq setHTTPMethod:@"GET"];
    return [self getResp:serviceReq];
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

-(void)puttHttpRequestWithImage:(NSData *) imageData token:(NSString *) token{
    //POST/PUT to Amazon
    //STEP 2: Upload image to S3 with generated token from backend
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[imageData length]];
    
    // Init the URLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"PUT"];
    [request setURL:[NSURL URLWithString:token]];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:imageData];
    NSLog(@"token is --- %@", token);
    
    
    NSURLConnection * connection2 = [[NSURLConnection alloc]
                                     initWithRequest:request
                                     delegate:self startImmediately:NO];
    
    [connection2 scheduleInRunLoop:[NSRunLoop mainRunLoop]
                           forMode:NSDefaultRunLoopMode];
    
    [connection2 start];
    if (connection2) {
        NSLog(@"connection---");
    };
    
}

- (void)connection:(NSURLConnection *)connection
   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    long percentageDownloaded = (totalBytesWritten * 100)/totalBytesExpectedToWrite;
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    if(percentageDownloaded == 100){
        NSLog(@"herja");
        
        //[self performSelector:imageUpload];
        MessageController *messageController = self;
        [messageController imageIsUploaded];
        
    }
    NSLog(@"Skrevet %ld av totalt %ld percentage %d", (long)totalBytesWritten, (long)totalBytesExpectedToWrite, percentageDownloaded);
}


@end
