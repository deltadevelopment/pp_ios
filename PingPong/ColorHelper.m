//
//  ColorHelper.m
//  PingPong
//
//  Created by Simen Lie on 14/03/15.
//  Copyright (c) 2015 ddev. All rights reserved.
//

#import "ColorHelper.h"
#import <UIKit/UIKit.h>

@implementation ColorHelper
NSArray* colors;
int indexColor;
-(void)initColors{
    colors = [NSArray arrayWithObjects:[UIColor colorWithRed:0.404 green:0.227 blue:0.718 alpha:1],
              [UIColor colorWithRed:0.247 green:0.318 blue:0.71 alpha:1],
              [UIColor colorWithRed:0.129 green:0.588 blue:0.953 alpha:1],
              [UIColor colorWithRed:1 green:0.341 blue:0.133 alpha:1],
              [UIColor colorWithRed:0.612 green:0.153 blue:0.69 alpha:1]
              , nil];
}

-(UIColor*)getColor{
    if(indexColor == [colors count]){
        indexColor = 0;
    }
    
    UIColor *returningColor = [colors objectAtIndex:indexColor];
    indexColor++;
    return returningColor;
}

@end
