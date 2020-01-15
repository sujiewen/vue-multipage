//
//  LXJSWebViewController.h
//  OfficeManagement
//
//  Created by sjw on 2019/11/7.
//  Copyright © 2019 Ideal-link. All rights reserved.
//

#import "LXPublicWebViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXJSWebViewController : LXPublicWebViewController

@property (nonatomic, strong) NSString *tTitle;
@property (nonatomic, strong) NSString *tName;
@property (nonatomic, strong) NSString *tRouter;
@property (nonatomic, strong) id backlogItemObject;

@property (nonatomic, copy) void (^webViewReloadBlock)(void);

@end

NS_ASSUME_NONNULL_END
