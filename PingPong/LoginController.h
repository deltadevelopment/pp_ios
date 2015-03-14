//
//  LoginController.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationController.h"
@interface LoginController : ApplicationController

-(void)login:(NSString *) username
        pass:(NSString *) password;
-(void)registerUser:(NSString *) username
               pass:(NSString *) password;

-(NSString *) getUsernameError;
-(NSString *) getPasswordError;
-(NSString *) getEmailError;
@end
