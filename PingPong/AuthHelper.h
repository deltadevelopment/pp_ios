//
//  AuthHelper.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthHelper : NSObject
- (void) storeCredentials:(NSMutableDictionary *) credentials;
-(void) resetCredentials;
- (NSString*) getAuthToken;
- (NSString *) getUserId;
@end
