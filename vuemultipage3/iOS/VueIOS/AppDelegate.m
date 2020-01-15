//
//  AppDelegate.m
//  VueIOS
//
//  Created by sjw on 2020/1/14.
//  Copyright © 2020 sjw. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LXJSWebViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 13.0, *)) {
        //屏蔽暗黑模式
        window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
    
    self.window = window;
    
    LXJSWebViewController *jsWebVC = [[LXJSWebViewController alloc] init];
    jsWebVC.strBaseUrl = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] bundlePath],@"vue"];
    jsWebVC.strUrl = [[NSBundle mainBundle] pathForResource:@"vue/report" ofType:@"html"];;
    UINavigationController *rootVC = [[UINavigationController alloc] initWithRootViewController:jsWebVC];
    
    window.rootViewController = rootVC;
    
    [window makeKeyAndVisible];
    
    return YES;
}

@end
