//
//  parserHelper.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParserHelper : NSObject
- (NSMutableDictionary *) parse:(NSData *) response;
@end
