//
//  NSObject+File.h
//  Dentist
//
//  iOS 5.1开始，应用可以使用NSURLIsExcludedFromBackupKey 或 kCFURLIsExcludedFromBackupKey 文件属性来防止文件被iCound备份
//
//  Created by Sjw on 16/3/15.
//  Copyright © 2016年 YunYa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (File)

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)url;

+ (BOOL)getSkipBackupAttributeToItemAtURL:(NSURL *)url;

+ (NSString*)getDocumentPath;
+ (BOOL)createDirectory:(NSString *)filePath;
+ (BOOL)createFile:(NSString *)file;

+(unsigned long long)fileSizeAtPath:(NSString*)filePath;
+(unsigned long long)folderSizeAtPath:(NSString*)folderPath;

+(BOOL)moveFileName:(NSString *)srcFilePath toPath:(NSString *)destFilePath;
+(BOOL)renameFileName:(NSString *)srcFilePath toPath:(NSString *)destFilePath;
+(BOOL)copyFile:(NSString *)srcFilePath toPath:(NSString *)destFilePath;
/**
 * deleteF 自身目录是否删除
 **/
+ (BOOL)deleteSDir:(NSString *)strDir Flag:(BOOL)deleteF;

@end

@interface NSString (File)

- (short)addSkipBackupAttributeToItemAtPath;
- (BOOL)createDirectory;
- (BOOL)createFile;

@end
