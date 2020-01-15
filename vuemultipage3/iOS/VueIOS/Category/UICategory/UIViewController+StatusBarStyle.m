//
//  UIViewController+StatusBarStyle.m
//  OfficeManagement
//
//  Created by Sjw on 2018/10/23.
//  Copyright © 2018年 LXshun. All rights reserved.
//

#import "UIViewController+StatusBarStyle.h"

@implementation UIViewController (StatusBarStyle)

-(BOOL)prefersStatusBarHidden {
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
