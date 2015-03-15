//
//  MessageModel.m
//  PingPong
//
//  Created by Simen Lie on 15/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

-(void)build:(NSMutableDictionary *)dic{
    _body = dic[@"body"];
    _media_type = dic[@"media_type"];
    if((NSNull*)dic[@"seen"] != [NSNull null]){
        _seen = [[dic objectForKey:@"seen"] boolValue];
    }
    _media_url = dic[@"media_url"];
    //NSLog(@"hey: %@", _media_url);
    _Id =dic[@"id"];
    _parent_id =dic[@"parent_id"];
    _user = [[FriendModel alloc] init];
    [_user build:dic[@"user"]];
    _receiver_id = dic[@"receiver_id"];
    _sender_id = dic[@"sender_id"];
    //NSLog(_username);
    
};
/*
 message: {
 id: 6
 media_type: 1
 seen: true
 user: {
 id: 2
 username: "simenlie"
 }-
 }
 
 */

-(void)downloadImage{
        NSLog(@"Donwloading image with %@", _media_url);
        _media = [NSData dataWithContentsOfURL:[NSURL URLWithString:_media_url]];
        NSLog(@"image donwloaded");

    
}


-(NSData*)getMedia{
    if(![_media isKindOfClass:[NSNull class]] && ![_media_url isKindOfClass:[NSNull class]]){
        if(_media == nil && _media_url != nil){
            [self downloadImage];
        }
    }
    
    else if(_media_url == nil){
        return nil;
    }
    return _media;
}

@end
