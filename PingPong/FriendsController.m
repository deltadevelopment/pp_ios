//
//  FriendsController.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "FriendsController.h"
#import "FriendModel.h"
#import "MessageModel.h"

@implementation FriendsController
NSMutableArray *friends;
NSMutableArray *friendRequests;
FriendModel *addedFriend;
NSMutableArray *messages;

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
        NSLog(@"friendRequests");
        FriendModel *friend = [[FriendModel alloc] init];
        [friend build:friendRaw[@"user"]];
        [friendRequests addObject:friend];
    }
}

-(NSMutableArray *)getFriends{
    return friends;
}

-(NSMutableArray *)getFriendRequests{
    NSMutableArray *friendRequests2 = [[NSMutableArray alloc] init];
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

-(void)test{
    //GET friend with username
    NSLog(@"test");
    messages = [[NSMutableArray alloc] init];
    NSData *response = [self getHttpRequest:[NSString stringWithFormat:@"user/%@/messages", [authHelper getUserId]]];
    ParserHelper* parserHelper = [[ParserHelper alloc] init];
    NSMutableDictionary *dic2 = [parserHelper parse:response];
    NSMutableArray *rawData = dic2[@"messages"];
    for(NSMutableDictionary *rawMessage in rawData){
        MessageModel*message = [[MessageModel alloc] init];
        [message build:rawMessage];
        [messages addObject:message];
    }
  
    
    for(MessageModel *message in messages){
        for(FriendModel *friend in friends){
            NSLog(@"friend: %@ message: %@", [friend userId], [[message user] userId]);
            if([[friend userId] intValue] == [[[message user] userId ] intValue]){
            //Dette er venn som du har melding med
               NSLog(@"friend: %@ message: %@", [message sender_id], [authHelper getUserId]);
                if([[message sender_id] intValue] != [[authHelper getUserId] intValue]){
                    //IKKe deg selv. vis konvolutt
                    friend.type = 1;
                    
                   
                }else if([[message sender_id] intValue] == [[authHelper getUserId] intValue]){
                    //Er deg selv som har sendt bilde
                    NSLog(@"du har sendt");
                    if([[message media_type] intValue] == 1){
                        NSLog(@"du har sendt");
                          friend.type = 2;
                        //Bilde du har sendt
                    }
                    else{
                    //video du har sendt
                        friend.type = 3;
                    }
                    
                }
                
                
            }
           
        }
    
    }

    //http://p1ngp0ng.herokuapp.com/user/2/messages

}


-(void)removeFriend{

}
@end
