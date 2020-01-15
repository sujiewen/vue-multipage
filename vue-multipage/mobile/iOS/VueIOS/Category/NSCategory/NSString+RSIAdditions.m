//
//  NSString+RSIAdditions.m
//
//  Created by Rafael Souza on 02/10/13.
//  Copyright (c) 2013 Rafael Souza. All rights reserved.
//

#import "NSString+RSIAdditions.h"

#import <CommonCrypto/CommonDigest.h>


@implementation NSString (RSIAdditions)

- (NSString *)md5
{
    const char * str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG) strlen(str), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}


-(NSString *)sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
	NSData *data 	 = [NSData dataWithBytes:cstr length:self.length];
    
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
	CC_SHA1(data.bytes, (CC_LONG) data.length, digest);
    
	NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
	for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", digest[i]];
    
	return output;
}


-(NSString *)stringByStrippingWhitespace
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(NSString *)substringFrom:(NSInteger)from to:(NSInteger)to {
    NSString *rightPart = [self substringFromIndex:from];
    return [rightPart substringToIndex:to-from];
}


-(NSString *)stringWithURLEncode {
    NSString *charactersToEscape = @"!*'\"();:@&=+$,/?%#[] ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedUrl = [self stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    return encodedUrl;
}

-(NSString *)stringWithURLDecode
{
    CFStringRef decoded = CFURLCreateStringByReplacingPercentEscapes( kCFAllocatorDefault,
                                                                      (__bridge CFStringRef)self,
                                                                      CFSTR("!*'\"();:@&=+$,/?%#[] ") );
    return [NSString stringWithString:(__bridge_transfer NSString *)decoded];
}


-(BOOL)isEmpty
{
    return [[self stringByStrippingWhitespace] isEqualToString:@""];
}


-(BOOL)containsString:(NSString *)string
{
    NSRange range = [self rangeOfString:string];
    return (range.location != NSNotFound);
}

@end
