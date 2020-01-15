//
//  NSString+SFormat.m
//  OfficeManagement
//
//  Created by Su jw on 2019/6/4.
//  Copyright © 2019 Ideal-link. All rights reserved.
//

#import "NSString+SFormat.h"

@implementation NSString (SFormat)

- (NSString *)phoneFourFormat {
    
    if (self.length == 13) {
        return self;
    }
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\\b"];
    if ([self rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return self;
    }
    
    NSMutableString *noBlankString =  [NSMutableString stringWithString:[self stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    // 插入空格
    if(noBlankString.length >= 4 && noBlankString.length < 8) {
        [noBlankString insertString:@" " atIndex:3];
    } else if(noBlankString.length > 7) {
        [noBlankString insertString:@" " atIndex:3];
        [noBlankString insertString:@" " atIndex:8];
    }
    
    return noBlankString;
}

@end
