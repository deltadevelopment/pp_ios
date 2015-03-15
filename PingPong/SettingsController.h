//
//  SettingsController.h
//  PingPong
//
//  Created by Simen Lie on 15/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationController.h"
#import "FriendModel.h"

@interface SettingsController : ApplicationController
-(void)deleteUser;
-(void)changePassword:(NSString*) newPassword;
-(FriendModel*)getUser;
@end
