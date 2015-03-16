//
//  FriendModel.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject

@property (nonatomic,strong) NSString * userId;
@property (nonatomic,strong) NSString * username;
@property(nonatomic) BOOL isRequester;
@property(nonatomic) int type;

-(void)build:(NSMutableDictionary *)dic;
-(void)setFriendType:(int)theType;
@end
