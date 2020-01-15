//
//  LXPublicWebViewController.h
//  OfficeManagement
//
//  Created by sjw on 2019/11/7.
//  Copyright © 2019 Ideal-link. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXPublicWebViewController : UIViewController

@property (nonatomic, strong, readonly) WKWebView *webView;

@property (strong, nonatomic) NSString* strUrl;
@property (strong, nonatomic) NSString* strBaseUrl;

@property (nonatomic) BOOL isWatchTitleFlag;

- (void)loadlHtml;

@end

NS_ASSUME_NONNULL_END
