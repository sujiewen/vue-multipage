//
//  NSString+RSIAdditions.h
//
//  Created by Rafael Souza on 02/10/13.
//  Copyright (c) 2013 Rafael Souza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RSIAdditions)

- (NSString *)md5;
- (NSString *)sha1;
- (NSString *)stringWithURLEncode;
- (NSString *)stringWithURLDecode;
- (NSString *)stringByStrippingWhitespace;
- (NSString *)substringFrom:(NSInteger)from to:(NSInteger)to;

- (BOOL)containsString:(NSString *)string;
- (BOOL)isEmpty;

@end
