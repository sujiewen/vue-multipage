//
//  NSObject+File.m
//  Dentist
//
//  Created by Sjw on 16/3/15.
//  Copyright © 2016年 YunYa. All rights reserved.
//

#import "NSObject+File.h"

@implementation NSObject (File)

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)url
{
    //条件返回错误 程序停止
    assert([[NSFileManager defaultManager] fileExistsAtPath: [url path]]);
    
    NSError *error = nil;
    BOOL success = [url setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        SWriteLog(@"Error excluding %@ from backup %@", [url lastPathComponent], error);
    }
    return success;
}

+ (BOOL)getSkipBackupAttributeToItemAtURL:(NSURL *)url
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [url path]]);
//    NSError *error = nil;
    BOOL success = NO;
    
    NSDictionary *dict = [url resourceValuesForKeys:@[NSURLIsExcludedFromBackupKey] error:nil];
    if (!dict || [dict[NSURLIsExcludedFromBackupKey] integerValue] != 1) {
        success = NO;
    }
    else success = YES;
    
    return success;
}

//if (&NSURLIsExcludedFromBackupKey == nil) { // iOS <= 5.0.1
//    const char* filePath = [[URL path] fileSystemRepresentation];
//    
//    const char* attrName = "com.apple.MobileBackup";
//    u_int8_t attrValue = 1;
//    
//    int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
//    return result == 0;
//} else { // iOS >= 5.1
//    
//    SWriteLog(@"%d",[URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil]);
//    return [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
//}


+ (BOOL)deleteSDir:(NSString *)strDir Flag:(BOOL)deleteF
{
    NSError *error = nil;
    NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:strDir error:nil];
    for (NSString *strPath in array) {
        NSString * fullPath = [strDir stringByAppendingPathComponent:strPath];
        BOOL isDir = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir])
        {
            if (isDir) {
                if([self deleteSDir:fullPath Flag:YES])
                {
                    SWriteLog(@"deleteSDir= %s = %@ error = %@",__PRETTY_FUNCTION__,fullPath,[error description]);
                }
            }
            else
            {
                BOOL flag = [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
                if (!flag) {
                    SWriteLog(@"deleteSDir= %s = %@ error = %@",__PRETTY_FUNCTION__,fullPath,[error description]);
                }
            }
        }
    }
    
    if (deleteF) {
        BOOL flag = [[NSFileManager defaultManager] removeItemAtPath:strDir error:&error];
        if (!flag) {
            SWriteLog(@"deleteSDir= %s = %@ error = %@",__PRETTY_FUNCTION__,strDir,[error description]);
        }
    }
    
    return YES;
}

+ (NSString*)getDocumentPath
{
    //获取Documents路径
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    return path;
}

+ (BOOL)createDirectory:(NSString *)filePath
{
    BOOL isSuccess = NO;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL isDir = NO;
    if(![fileManager fileExistsAtPath:filePath isDirectory:&isDir]){
        isSuccess = [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else {
        isSuccess = YES;
    }
    
    if(isSuccess) {
        [filePath addSkipBackupAttributeToItemAtPath];
    }
    
    return isSuccess;
}

+ (BOOL)createFile:(NSString *)file
{
    BOOL isSuccess = NO;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL isDir = NO;
    if(![fileManager fileExistsAtPath:file isDirectory:&isDir]){
        isSuccess = [fileManager createFileAtPath:file contents:nil attributes:nil];
    }
    else {
        isSuccess = YES;
    }
    
    if(isSuccess) {
        [file addSkipBackupAttributeToItemAtPath];
    }
    return isSuccess;
}

+(unsigned long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL isExist=[fileManager fileExistsAtPath:filePath];
    if(isExist){
        unsigned long long fileSize = [[fileManager attributesOfItemAtPath:filePath error:nil] fileSize];
        return fileSize;
    }else{
        return 0;
    }
}

+(unsigned long long)folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL isExist=[fileManager fileExistsAtPath:folderPath];
    if(isExist){
        NSEnumerator *childFileEnumerator=[[fileManager subpathsAtPath:folderPath] objectEnumerator];
        unsigned long long folderSize=0;
        NSString *fileName=@"";
        while((fileName=[childFileEnumerator nextObject])!=nil){
            NSString*fileAbsolutePath=[folderPath stringByAppendingPathComponent:fileName];
            folderSize+=[self fileSizeAtPath:fileAbsolutePath];
        }
        return folderSize;
    }else{
        
        return 0;
    }
}

+(BOOL)moveFileName:(NSString *)srcFilePath toPath:(NSString *)destFilePath
{
    NSFileManager*fileManager=[NSFileManager defaultManager];
    NSError *error = nil;
    BOOL isSuccess=[fileManager moveItemAtPath:srcFilePath toPath:destFilePath error:&error];
    if(isSuccess) {
        [destFilePath addSkipBackupAttributeToItemAtPath];
    }
    return isSuccess;
}

+(BOOL)renameFileName:(NSString *)srcFilePath toPath:(NSString *)destFilePath
{
    //通过移动该文件对文件重命名
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    BOOL isSuccess=[fileManager moveItemAtPath:srcFilePath toPath:destFilePath error:&error];
    if(isSuccess) {
        [destFilePath addSkipBackupAttributeToItemAtPath];
    }
    return isSuccess;
}

+(BOOL)copyFile:(NSString *)srcFilePath toPath:(NSString *)destFilePath {
    BOOL isSuccess = NO;
    NSError *error;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:destFilePath])
    {
        //removing file
        if (![[NSFileManager defaultManager] removeItemAtPath:destFilePath error:&error])
        {
            SWriteLog(@"Could not remove old files. Error:%@",error);
        }
    }
    
    BOOL success = [[NSFileManager defaultManager] copyItemAtPath:srcFilePath toPath:destFilePath error:&error];
    if (success == YES)
    {
        NSURL *filePath = [NSURL fileURLWithPath:destFilePath];
        [NSObject addSkipBackupAttributeToItemAtURL:filePath];
        isSuccess = YES;
    }
    else
    {
        SWriteLog(@"Not Copied %@", error);
    }
    
    return isSuccess;
}


@end

@implementation NSString (File)

//-1,添加失败；0，是已存在；1，添加成功
- (short)addSkipBackupAttributeToItemAtPath
{
    short flag = -1;
    NSURL *filePath = [NSURL fileURLWithPath:self];
    if (![NSObject getSkipBackupAttributeToItemAtURL:filePath]) {
        //防止iCound备份
        BOOL bSkipBackup = [NSObject addSkipBackupAttributeToItemAtURL:filePath];
        if (!bSkipBackup)
        {
            SWriteLog(@"FilePath=%@ addSkipBackupAttributeToItemAtURL State= %@ 失败",[filePath absoluteString],[NSNumber numberWithBool:bSkipBackup]);
        }
        else flag = 1;
    }
    else {
        flag = 0 ;
    }
    
    return flag;
}

- (BOOL)createDirectory {
    BOOL isSuccess = NO;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL isDir = NO;
    if(![fileManager fileExistsAtPath:self isDirectory:&isDir]){
        isSuccess = [fileManager createDirectoryAtPath:self withIntermediateDirectories:YES attributes:nil error:nil];
    }
    else {
        isSuccess = YES;
    }
    
    if(isSuccess) {
        [self addSkipBackupAttributeToItemAtPath];
    }
    
    return isSuccess;
}

- (BOOL)createFile {
    BOOL isSuccess = NO;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    BOOL isDir = NO;
    if(![fileManager fileExistsAtPath:self isDirectory:&isDir]){
        isSuccess = [fileManager createFileAtPath:self contents:nil attributes:nil];
    }
    else {
        isSuccess = YES;
    }
    
    if(isSuccess) {
        [self addSkipBackupAttributeToItemAtPath];
    }
    return isSuccess;
}

@end
