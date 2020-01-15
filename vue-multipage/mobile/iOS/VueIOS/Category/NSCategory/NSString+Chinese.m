//
//  NSString+Chinese.m
//  OfficeManagement
//
//  Created by sjw on 2019/10/31.
//  Copyright © 2019 Ideal-link. All rights reserved.
//

#import "NSString+Chinese.h"

@implementation NSString (Chinese)

- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

@end
