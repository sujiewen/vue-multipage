//
//  UIViewController+CurrentVC.h
//  OfficeManagement
//
//  Created by Sjw on 2018/12/9.
//  Copyright © 2018年 LXshun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (CurrentVC)

//可以push的ViewControoler
+ (UIViewController *)getCurrentVC;

//最顶端的ViewControoler
+ (UIViewController *)getCurrentTopVC;

@end

NS_ASSUME_NONNULL_END
