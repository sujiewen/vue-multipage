//
//  NSString+Extension.m
//  OfficeManagement
//
//  Created by zhaoyt on 16/7/27.
//  Copyright © 2016年 LXshun. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)


- (instancetype)cacheDir
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:[self lastPathComponent]];
}

- (instancetype)tempDir
{
    NSString *path = NSTemporaryDirectory();
    return [path stringByAppendingPathComponent:[self lastPathComponent]];
}

- (instancetype)documentDir
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [path stringByAppendingPathComponent:self];
}

+ (NSString *)lr_stringDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    return dateString;
}
//年月日时分秒
-(NSString *)hoursAndMintues{
    if (self) {
        if (self.length >= 16) {
            NSString *dateString = [self substringToIndex:16];
            return dateString;
            
        }else{
            return self;
        }
    }else{
        return @"   ";
    }
}
//月日时分
-(NSString *)monthDayAndHoursAndMintues{
    if (self) {
        if (self.length >= 16) {
            NSString *dateString = [self substringWithRange:NSMakeRange(5, 11)];
            return dateString;
            
        }else{
            return self;
        }
    }else{
        return @"   ";
    }
}


- (NSInteger)ToMintues {
    if (self.length != 5) {
        return 0;
    }else {
        NSInteger hours = [[self substringToIndex:2] integerValue];
        NSInteger mintue = [[self substringFromIndex:3] integerValue];
        return hours*60 + mintue;
    }
}


//年月日
-(NSString *)yearAndMonth{
    if (self) {
        if (self.length >= 10) {
            NSString *dateString = [self substringToIndex:10];
            return dateString;
            
        }else{
            return self;
        }
    }else{
        return @"   ";
    }
    
}

-(NSString *)unHoursAndMintues{
    if (self) {
        if (self.length >= 16) {
            NSString *dateString = [self substringToIndex:16];
            return [dateString stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
            
        }else{
            return [self stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
        }
    }else{
        return @"   ";
    }
}

- (BOOL)timeCompare:(NSString *)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSDate *oldDate = [formatter dateFromString:time];
    
    NSTimeInterval oldInterval = [oldDate timeIntervalSince1970] * 1000;
    NSDate *now = [formatter dateFromString:self];
    NSTimeInterval nowInterval = [now timeIntervalSince1970] * 1000;
    
    return (nowInterval < oldInterval);
}

//显示xx天xx小时或者xx小时 传值为分钟

-(NSString *)showDayAndHoursTypeString{
    if (self) {
        int time = [self intValue];
        int day = time/(60*24);
        int hours = (time%(24*60))/60;
        if (day != 0 && hours != 0) {
            return [NSString stringWithFormat:@"%d天%d小时",day,hours];
        }else if (day != 0 && hours == 0){
            return [NSString stringWithFormat:@"%d天",day];
        }else if (day == 0 && hours != 0){
            return [NSString stringWithFormat:@"%d小时",hours];
        }else{
            return @" ";
        }
        
    }
    return @" ";
}


+ (NSString *)dateFromNSString:(NSString *)str{
    //Tue, 30 Jun 2015 03:55:54 GMT
    //30 Jun 2015 03:55:54
    NSString *timeStr=[str substringWithRange:NSMakeRange(5, 20)];//截取字符串
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    NSLocale *local=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:local];//需要配置区域，不然会造成模拟器正常，真机日期为null的情况
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"dd MMM yyyy HH:mm:ss"];//设置源时间字符串的格式
    NSDate* date = [formatter dateFromString:timeStr];//将源时间字符串转化为NSDate
    
    //可以自己再换格式，上面是源，下面是目标
    NSDateFormatter* toformatter = [[NSDateFormatter alloc] init];
    [toformatter setDateStyle:NSDateFormatterMediumStyle];
    [toformatter setTimeStyle:NSDateFormatterShortStyle];
    [toformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设置目标时间字符串的格式
    NSString *targetTime = [toformatter stringFromDate:date];//将时间转化成目标时间字符串
    //    NSDate* toDate = [formatter dateFromString:targetTime];//将源时间字符串转化为NSDate
    return targetTime;
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate{
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

- (CGSize)calculateSizeString:(CGFloat)width font:(UIFont *)font {

    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    style.alignment = NSTextAlignmentLeft;
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style} context:nil].size;
    return size;
}
//计算文字宽度
- (CGFloat)calculateeStringHeight:(CGFloat)height font:(UIFont *)font {
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    style.alignment = NSTextAlignmentLeft;
    CGSize size = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:style} context:nil].size;
    return size.width;
}


- (BOOL)allIsNumberCharacter{
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [self rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"0123456789"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

-(NSString*)subZNTextString:(NSInteger)len {
    if(self.length<=len)
        return self;
    int count=0;
    NSMutableString *sb = [NSMutableString string];
    for (int i=0; i<self.length; i++) {
        NSRange range = NSMakeRange(i, 1) ;
        NSString *aStr = [self substringWithRange:range];
        count += [aStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>1?2:1;
        [sb appendString:aStr];
        if(count >= len*2) {
            return (i==self.length-1)?[sb copy]:[NSString stringWithFormat:@"%@...",[sb copy]];
        }
    }
    
    return self;
}

@end
