//
//  MessageModel.h
//  PingPong
//
//  Created by Simen Lie on 15/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendModel.h"

@interface MessageModel : NSObject
@property (nonatomic,strong) NSString * body;
@property (nonatomic,strong) NSString * Id;
@property (nonatomic,strong) NSString * media_type;
@property (nonatomic) BOOL seen;
@property (nonatomic,strong) NSString * parent_id;
@property (nonatomic,strong) NSString * sender_id;
@property (nonatomic,strong) NSString * receiver_id;
@property (nonatomic,strong) NSString * media_url;
@property (nonatomic,strong) NSData * media;

@property (nonatomic,strong) FriendModel * user;
-(void)build:(NSMutableDictionary *)dic;
-(NSData*)getMedia;



@end
