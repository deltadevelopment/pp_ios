//
//  FriendsController.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApplicationController.h"
@interface FriendsController : ApplicationController
-(void)addFriend:(NSString*) username withSelector:(SEL) selector withSuccess:(SEL) successSelector withObject:(NSObject *) object;
-(void)initFriends;
-(NSMutableArray *)getFriends;
-(void)initFriendRequests;
-(NSMutableArray *)getFriendRequests;
-(void)deleteFriend:(NSString *) userId withSuccess:(SEL) success andObject:(NSObject *) object;
-(void)acceptFriendRequestFromUser:(NSString *) userId withSucess:(SEL)success andObject: (NSObject *) object;
@end
