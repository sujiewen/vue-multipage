//
//  LXJSWebViewController.m
//  OfficeManagement
//
//  Created by sjw on 2019/11/7.
//  Copyright © 2019 Ideal-link. All rights reserved.
//

#import "LXJSWebViewController.h"
#import "WKWebView+JavaScriptBridge.h"
#import "MJExtension.h"
#import "NSObject+File.h"
#import "NSString+OTSTO.h"
#import <SPAlertController/SPAlertController.h>

@interface LXJSWebViewController ()

@end

@implementation LXJSWebViewController

- (void)dealloc
{
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isWatchTitleFlag = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.tTitle) {
        self.title = self.tTitle;
    }
    else {
        self.title = @"详情";
    }
    
    __weak typeof(self) weakSelf = self;
    [self.webView registerHandler:@"nativeCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"nativeCallback called: %@", data);
        responseCallback(@"Response from nativeCallback");
    }];
    
    [self.webView registerHandler:@"fromMobile" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSMutableDictionary *mobilePropDict = [weakSelf getJSResPara:weakSelf.tName title:weakSelf.tTitle anyObject:weakSelf.backlogItemObject router:weakSelf.tRouter];
        responseCallback([mobilePropDict toCompactString]);
    }];
    
    [self.webView registerHandler:@"jumpTo" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *tmpDict = data;
        LXJSWebViewController *webVC = [LXJSWebViewController new];
        webVC.backlogItemObject = tmpDict[@"params"];
        webVC.tTitle = tmpDict[@"title"];
        webVC.tName = tmpDict[@"name"];
        webVC.tRouter = tmpDict[@"router"];
        webVC.strUrl = @"";//[HTTPAgent getH5Path];
        webVC.strBaseUrl = weakSelf.strBaseUrl;
        webVC.webViewReloadBlock = ^{
            [weakSelf loadlHtml];
//            if (weakSelf.webView.URL == nil) {
//                
//            }
//            else {
//                [weakSelf.webView reload];
//            }
        };
        [weakSelf.navigationController pushViewController:webVC animated:YES];
    }];
    
    [self.webView registerHandler:@"goBack" handler:^(id data, WVJBResponseCallback responseCallback) {
        if(weakSelf.webViewReloadBlock) {
            weakSelf.webViewReloadBlock();
        }

        NSDictionary *tmpDict = data;
        if (tmpDict[@"num"]) {
            NSInteger backIndex = [tmpDict[@"num"] integerValue];
            if (backIndex != -1) {
                if (backIndex == 0) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
                else if ([weakSelf.navigationController.viewControllers count] > backIndex) {
                    NSInteger tmpIndex = [weakSelf.navigationController.viewControllers count] - backIndex - 1;
                    UIViewController *backVC = weakSelf.navigationController.viewControllers[tmpIndex];
                    [weakSelf.navigationController popToViewController:backVC animated:YES];
                }
                else {
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            }
            else {
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
        }
        NSMutableDictionary *result =  [NSMutableDictionary new];
        [result setObject:@(YES) forKey:@"success"];
        responseCallback(result);
    }];
    
    [self.webView registerHandler:@"getImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *tmpD = data;
        NSInteger maxLength = 5;
        if ([data isKindOfClass:[NSNumber class]] || [data isKindOfClass:[NSString class]]) {
            maxLength = [tmpD[@"maxLength"] integerValue];
        }
        [weakSelf popFileLsit:maxLength callback:^(NSArray *imgArray) {
            NSString *resultJson = [imgArray toCompactString];
            responseCallback(resultJson);
        }];
    }];
    
    [self.webView registerHandler:@"clearLocalImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSArray *array = data;
        for (NSDictionary *tmpD in array) {
            if (tmpD[@"url"]) {
                NSString *localPaht = tmpD[@"url"];
                if (localPaht) {
                    NSFileManager *fileManager = [NSFileManager defaultManager];
                    BOOL isDelete = [fileManager removeItemAtPath:localPaht error:nil];
                    if (!isDelete) {
                        NSLog(@"删除失败=%@",localPaht);
                    }
                }
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (BOOL)navigationShouldPopOnBackButton {
    
    if (self.webViewReloadBlock) {
        self.webViewReloadBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    return NO;
}

- (NSMutableDictionary *)getJSResPara:(NSString *)name title:(NSString *)title anyObject:(id )data router:(NSString *)strRouter {
    NSMutableDictionary *mobilePropDict = [NSMutableDictionary new];
    NSMutableDictionary *userInfoDict = [NSMutableDictionary new];
//    if ([GlobalData instance].userInfo) {
//        [userInfoDict setObject:[GlobalData instance].userInfo.userId forKey:@"id"];
//        [userInfoDict setObject:[GlobalData instance].userInfo.userName forKey:@"name"];
//    }
//
//    [mobilePropDict setObject:userInfoDict forKey:@"userInfo"];
//    NSMutableDictionary *orgInfoDict = [NSMutableDictionary new];
//    if ([GlobalData instance].companyInfo) {
//        if ([GlobalData instance].companyInfo.bloc) {
//            [orgInfoDict setObject:[GlobalData instance].companyInfo.orgId forKey:@"id"];
//        }
//        else {
//            [orgInfoDict setObject:[[GlobalData instance].companyInfo getOterhORGIDS] forKey:@"id"];
//        }
//
//        if ([GlobalData instance].companyInfo.orgName) {
//            [orgInfoDict setObject:[GlobalData instance].companyInfo.orgName forKey:@"name"];
//        }
//
//        if ([GlobalData instance].companyInfo.shortName) {
//            [orgInfoDict setObject:[GlobalData instance].companyInfo.shortName forKey:@"shortName"];
//        }
//
//        [orgInfoDict setObject:@([GlobalData instance].companyInfo.bloc) forKey:@"bloc"];
//    }
//    [mobilePropDict setObject:orgInfoDict forKey:@"orgInfo"];
    
    if (data) {
        [mobilePropDict setObject:data forKey:@"params"];
    }
    else {
        [mobilePropDict setObject:@{} forKey:@"params"];
    }
    
    [mobilePropDict setObject:strRouter forKey:@"router"];
    
    [mobilePropDict setObject:@"iOS" forKey:@"clientType"];
//
//    if ([GlobalData instance].userInfo.accessToken) {
//        NSRange range = [[GlobalData instance].userInfo.accessToken rangeOfString:@"@"];
//        NSString *strToken = [GlobalData instance].userInfo.accessToken;
//        if (range.location != NSNotFound) {
//            strToken = [strToken substringToIndex:range.location];
//        }
//        [mobilePropDict setObject:strToken forKey:@"token"];
//    }
//
//    [mobilePropDict setObject:[HTTPAgent getServiceUrl] forKey:@"baseUrl"];
    
    return mobilePropDict;
}

- (void)popFileLsit:(NSInteger)maxLength callback:(void (^)(NSArray *))callback {
    __weak typeof(self) weakSelf = self;
    SPAlertController *alertSheet = [SPAlertController alertControllerWithTitle:nil message:nil preferredStyle:SPAlertControllerStyleActionSheet animationType:SPAlertAnimationTypeDefault];
    
    SPAlertAction *actionPhoto = [SPAlertAction actionWithTitle:@"相册" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
//        if (maxLength == 0) {
//            [AlertControlManageTool AlertView:nil WithTitle:[NSString stringWithFormat:@"最多可选择%ld张图片",(long)weakSelf.maxCount] AndMsg:nil
//                                                 AndActionarray:nil Isjump:NO];
//            return;
//        }
        
        [weakSelf pickPhoto:maxLength callback:callback];
     }];
     [alertSheet addAction:actionPhoto];
     
     SPAlertAction * actionFile = [SPAlertAction actionWithTitle:@"文件" style:SPAlertActionStyleDefault handler:^(SPAlertAction * _Nonnull action) {
         [weakSelf pickFile:maxLength callback:callback];
     }];
     [alertSheet addAction:actionFile];
    
    SPAlertAction * cancelAction = [SPAlertAction actionWithTitle:@"取消" style:SPAlertActionStyleCancel handler:^(SPAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    [alertSheet addAction:cancelAction];
     
    [[UIViewController getCurrentVC] presentViewController:alertSheet animated:YES completion:nil];
}

- (void)pickPhoto:(NSInteger)selectCount callback:(void (^)(NSArray *))callback {
    __block NSMutableArray *tmpImageArray = [NSMutableArray new];
//    self.kitMediaFetcher.mediaTypes = @[(NSString *)kUTTypeImage];
//    self.kitMediaFetcher.limit = 5 - selectCount;
//    [self.kitMediaFetcher fetchPhotoFromLibrary:^(NSArray *images, NSString *path, PHAssetMediaType type) {
//        //写入沙盒
//        NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
//        NSString *prePath = [NSString stringWithFormat:@"%@/imagedisk",cachesPath];
//        [prePath createDirectory];
//
//        for (int i = 0; i < images.count; i++) {
//            NSData *data = UIImageJPEGRepresentation(images[i], 1);
//            NSString *fileName = [LXHelperTool createImageName:@"img" uuid:nil];;
//            NSString *path = [NSString stringWithFormat:@"%@/%@",prePath,fileName];
//            BOOL flag =  [data writeToFile:path atomically:YES];
//            if (flag) {
//                NSMutableDictionary *mutableDict = [NSMutableDictionary new];
//                if ([IMAGEARR containsObject:[fileName pathExtension]]) {//图片
//                    [mutableDict setObject:fileName forKey:@"name"];
//                    [mutableDict setObject:@"1" forKey:@"type"];
//                    [mutableDict setObject:@([data length]).stringValue forKey:@"sise"];
//                    [mutableDict setObject:[LXHelperTool createImageName:@"img" uuid:nil] forKey:@"id"];
//                    [mutableDict setObject:path forKey:@"url"];
//                }else if([VIDEOARR containsObject:[fileName pathExtension]]){
//                    [mutableDict setObject:fileName forKey:@"name"];
//                    [mutableDict setObject:@"2" forKey:@"type"];
//                    [mutableDict setObject:@([data length]).stringValue forKey:@"size"];
//                    [mutableDict setObject:[LXHelperTool createImageName:@"mov" uuid:nil] forKey:@"id"];
//                    [mutableDict setObject:path forKey:@"url"];
//                }else{
//                    [mutableDict setObject:fileName forKey:@"name"];
//                    [mutableDict setObject:@"3" forKey:@"type"];
//                    [mutableDict setObject:@([data length]).stringValue forKey:@"size"];
//                    [mutableDict setObject:[LXHelperTool createImageName:@"att" uuid:nil] forKey:@"id"];
//                    [mutableDict setObject:path forKey:@"url"];
//                }
//
//                [tmpImageArray addObject:mutableDict];
//            }
//        }
//
//        callback(tmpImageArray);
//    }];
}

- (void)pickFile:(NSInteger)selectCount callback:(void (^)(NSArray *))callback {

}

@end
