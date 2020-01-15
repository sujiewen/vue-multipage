//
//  NSString+OTSTO.h
//  YKT
//
//  Created by Sjw on 15/6/12.
//  Copyright (c) 2015年 ekangtong. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * Json串转对象
 */
@interface NSString (StringtoJSONObject)

-(id)toJSONObject;

-(NSString *)toString;
-(NSString *)toCompactString;

@end

/*
 * 字典转Json串
 */
@interface NSDictionary (DictionaryToString)

-(NSString *)toString;
-(NSString *)toCompactString;

@end


/*
 * 数组转Json串
 */
@interface NSArray (ArrayToString)

-(NSString *)toString;
-(NSString *)toCompactString;

@end
