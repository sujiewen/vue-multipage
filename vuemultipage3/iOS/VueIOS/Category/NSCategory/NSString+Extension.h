//
//  NSString+Extension.h
//  OfficeManagement
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 LXshun. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Extension)

//文件在caches目录中的路径
- (instancetype)cacheDir;
//文件在tmp目录中的路径
- (instancetype)tempDir;
//文件在Document目录中的路径
- (instancetype)documentDir;

- (BOOL)timeCompare:(NSString *)time;

+ (NSString *)lr_stringDate;

-(NSString *)timeListShow;
//时分
-(NSString *)hoursAndMintues;

/**
 字符串转成月日时分

 @return string
 */
-(NSString *)monthDayAndHoursAndMintues;

-(NSString *)unHoursAndMintues;
//年月日
-(NSString *)yearAndMonth;

-(NSString *)showDayAndHoursTypeString;

/**
 时间戳转换成时间字符串

 @param str 时间戳
 @return 时间字符串
 */
+ (NSString *)dateFromNSString:(NSString *)str;
/**
 从日期中的到周
 @return 返回 week
 */
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

/**
 字符串转分钟数

 @return nsinteger
 */
- (NSInteger)ToMintues;

//计算文字高度
- (CGSize)calculateSizeString:(CGFloat)width font:(UIFont *)font;
/**计算文字宽度*/
- (CGFloat)calculateeStringHeight:(CGFloat)height font:(UIFont *)font;

/**是否是纯数字*/
- (BOOL )allIsNumberCharacter;

/**截取中文*/
-(NSString*)subZNTextString:(NSInteger)len;

@end
