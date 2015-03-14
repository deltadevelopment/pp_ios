//
//  ApplicationHelper.h
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApplicationHelper : NSObject
-(NSString*) generateUrl:(NSString*) relativePath;
-(NSString*) generateJsonFromDictionary:(NSDictionary *) dictionary;
@end
