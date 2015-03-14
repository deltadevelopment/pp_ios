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

-(void)build:(NSMutableDictionary *)dic;
@end
