//
//  FriendsController.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FriendsController.h"
#import "FriendModel.h"

@implementation FriendsController
NSMutableArray *friends;
NSMutableArray *friendRequests;
FriendModel *addedFriend;

-(void)initFriends{
    friends = [[NSMutableArray alloc] init];
    NSString *url = [NSString stringWithFormat:@"user/%@/friends", [authHelper getUserId]];
    NSData *response = [self getHttpRequest:url];
    //NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    //NSLog(@"HER: %@",strdata);
    ParserHelper* parserHelper = [[ParserHelper alloc] init];
    NSMutableDictionary *dic2 = [parserHelper parse:response];
    NSArray *friendsRaw = dic2[@"friends"];
    for(NSMutableDictionary* friendRaw in friendsRaw){

        FriendModel *friend = [[FriendModel alloc] init];
        [friend build:friendRaw[@"user"]];
        [friends addObject:friend];
    }

}
-(void)initFriendRequests{
    friendRequests = [[NSMutableArray alloc] init];
    NSString *url = [NSString stringWithFormat:@"user/%@/friend_requests", [authHelper getUserId]];
    NSData *response = [self getHttpRequest:url];
    NSString *strdata=[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding];
    NSLog(@"HER: %@",strdata);
    ParserHelper* parserHelper = [[ParserHelper alloc] init];
    NSMutableDictionary *dic2 = [parserHelper parse:response];
    NSArray *friendsRaw = dic2[@"friends"];
    for(NSMutableDictionary* friendRaw in friendsRaw){
        
        FriendModel *friend = [[FriendModel alloc] init];
        [friend build:friendRaw[@"user"]];
        [friendRequests addObject:friend];
    }
}

-(NSMutableArray *)getFriends{
    return friends;
}

-(NSMutableArray *)getFriendRequests{
    NSMutableArray *friendRequests2;
    for(FriendModel *friend in friendRequests){
        if(![friend isRequester]){
            [friendRequests2 addObject:friend];
        }
    }
    
    return friendRequests2;
}

-(void)deleteFriend:(NSString *) userId withSuccess:(SEL) success andObject:(NSObject *) object{
    NSData *response2 = [self deleteHttpRequest:[NSString stringWithFormat:@"user/%@/friend/%@", [authHelper getUserId], userId]];
    NSMutableDictionary *dic = [parserHelper parse:response2];
    [object performSelector:success];
}

-(void)acceptFriendRequestFromUser:(NSString *) userId withSucess:(SEL)success andObject: (NSObject *) object{
    ///user/#{id}/accept_friend/#{friend_id}
    NSData *response2 = [self postHttpRequest:[NSString stringWithFormat:@"user/%@/accept_friend/%@", [authHelper getUserId], userId]  json:nil];
    NSMutableDictionary *dic = [parserHelper parse:response2];
    
    if(!isErrors){
        NSLog(@"ingen feil her");
        
        [object performSelector:success];
        
    }
    NSString *strdata=[[NSString alloc]initWithData:response2 encoding:NSUTF8StringEncoding];
    NSLog(strdata);
}


-(void)addFriend:(NSString*) username withSelector:(SEL) selector withSuccess:(SEL) successSelector withObject:(NSObject *) object{
    NSLog(@"adding friend now");
    //GET friend with username
    NSData *response = [self getHttpRequest:[NSString stringWithFormat:@"user_by_username/%@", username]];
    ParserHelper* parserHelper = [[ParserHelper alloc] init];
    NSMutableDictionary *dic2 = [parserHelper parse:response];
    FriendModel *friend = [[FriendModel alloc] init];
    [friend build:dic2[@"user"]];
    

    if(isErrors){
        NSLog(@"ISerrors");
        dispatch_sync(dispatch_get_main_queue(), ^{
            [object performSelector:selector];
        });
        
    }else{
        NSData *response2 = [self postHttpRequest:[NSString stringWithFormat:@"user/%@/friend/%@", [authHelper getUserId], [friend userId]]  json:nil];
        NSMutableDictionary *dic = [parserHelper parse:response2];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [object performSelector:successSelector];
        });
        //NSString *strdata=[[NSString alloc]initWithData:response2 encoding:NSUTF8StringEncoding];
        //NSLog(strdata);
    }


    

    
    
}


-(void)removeFriend{

}
@end
