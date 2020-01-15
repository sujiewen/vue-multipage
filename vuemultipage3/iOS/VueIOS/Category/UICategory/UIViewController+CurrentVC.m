//
//  UIViewController+CurrentVC.m
//  OfficeManagement
//
//  Created by Sjw on 2018/12/9.
//  Copyright © 2018年 LXshun. All rights reserved.
//

#import "UIViewController+CurrentVC.h"
#import <SPAlertController/SPAlertController.h>

@implementation UIViewController (CurrentVC)

+ (UIViewController *)getCurrentVC {
    
    UIViewController *result = nil;
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    do {
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)rootVC;
            UIViewController *vc = [navi.viewControllers lastObject];
            if ([vc isKindOfClass:[UITabBarController class]]) {
                UITabBarController *tab = (UITabBarController *)vc;
                result = tab;
                rootVC = [tab.viewControllers objectAtIndex:tab.selectedIndex];
            }
            else {
                result = vc;
                rootVC = vc.presentedViewController;
            }
            continue;
        } else if([rootVC isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)rootVC;
            result = tab;
            rootVC = [tab.viewControllers objectAtIndex:tab.selectedIndex];
            continue;
        }else if([rootVC isKindOfClass:[SPAlertController class]]) {
            rootVC = nil;
        }
        else if([rootVC isKindOfClass:[UIViewController class]]) {
            result = rootVC;
            rootVC = nil;
        }
        
    } while (rootVC != nil);
    
    return result;
}

+ (UIViewController *)getCurrentTopVC {
    
    UIViewController *result = nil;
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    do {
        if ([rootVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navi = (UINavigationController *)rootVC;
            UIViewController *vc = [navi.viewControllers lastObject];
            if ([vc isKindOfClass:[UITabBarController class]]) {
                UITabBarController *tab = (UITabBarController *)vc;
                result = tab;
                rootVC = [tab.viewControllers objectAtIndex:tab.selectedIndex];
            }
            else {
                result = vc;
                rootVC = vc.presentedViewController;
            }
            continue;
        } else if([rootVC isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tab = (UITabBarController *)rootVC;
            result = tab;
            rootVC = [tab.viewControllers objectAtIndex:tab.selectedIndex];
            continue;
        }else if([rootVC isKindOfClass:[SPAlertController class]]) {
            result = rootVC;
            rootVC = rootVC.presentedViewController;
        }
        else if([rootVC isKindOfClass:[UIViewController class]]) {
            result = rootVC;
            rootVC = rootVC.presentedViewController;
        }
        
    } while (rootVC != nil);
    
    return result;
}


@end
