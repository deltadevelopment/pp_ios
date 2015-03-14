//
//  FriendModel.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FriendModel.h"

@implementation FriendModel

-(void)build:(NSMutableDictionary *)dic{
    _userId = dic[@"id"];
    _username = dic[@"username"];
    _isRequester = [[dic objectForKey:@"is_requester"] boolValue];
    //NSLog(_username);
    
};
@end
