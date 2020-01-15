//
//  UINavigationController+StatusBarStyle.m
//  OfficeManagement
//
//  Created by Sjw on 2018/10/23.
//  Copyright © 2018年 LXshun. All rights reserved.
//

#import "UINavigationController+StatusBarStyle.h"

@implementation UINavigationController (StatusBarStyle)

- (UIViewController *)childViewControllerForStatusBarStyle {
    
    return self.visibleViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.visibleViewController;
}

@end
