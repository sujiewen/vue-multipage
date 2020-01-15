//
//  NSString+Additions.m
//  OfficeManagement
//
//  Created by Sjw on 2018/9/11.
//  Copyright © 2018年 LXshun. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

- (NSString *) trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
