//
//  NSString+OTSTO.m
//  YKT
//
//  Created by Sjw on 15/6/12.
//  Copyright (c) 2015年 ekangtong. All rights reserved.
//

#import "NSString+OTSTO.h"

@implementation NSString (StringtoJSONObject)

-(id)toJSONObject
{
    id object = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    return object;
}

-(NSString*)toString
{
    return (NSString *)self;
}

-(NSString*)toCompactString
{
    return (NSString *)self;
}

@end

@implementation NSDictionary (DictionaryToString)

-(NSString*)toString
{
    if (![self isKindOfClass:[NSString class]]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        NSString* jsonString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        return jsonString;
    }
    else {
        return (NSString *)self;
    }
}

-(NSString*)toCompactString
{
    if (![self isKindOfClass:[NSString class]]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
        NSString* jsonString = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        return jsonString;
    }
    else {
        return (NSString *)self;
    }
}

@end

@implementation NSArray (ArrayToString)

-(NSString*)toString
{
    if (![self isKindOfClass:[NSString class]]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
        NSString *msgJson=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        msgJson = [msgJson stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        return msgJson;
    }
    else {
        return (NSString *)self;
    }
}

-(NSString*)toCompactString
{
    if (![self isKindOfClass:[NSString class]]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
        NSString *msgJson=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        msgJson = [msgJson stringByReplacingOccurrencesOfString:@"\\/" withString:@"/"];
        return msgJson;
    }
    else {
        return (NSString *)self;
    }
}

@end
