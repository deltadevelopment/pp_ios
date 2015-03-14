//
//  ConfigHelper.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ConfigHelper.h"

@implementation ConfigHelper
- (id)init
{
    self = [super init];
    if (self) {
        _baseUrl = @"http://p1ngp0ng.herokuapp.com";
    }
    
    return self;
}

@end
