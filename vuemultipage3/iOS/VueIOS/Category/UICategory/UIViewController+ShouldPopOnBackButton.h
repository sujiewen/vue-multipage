//
//  UIViewController+ShouldPopOnBackButton.h
//  OfficeManagement
//
//  Created by Sjw on 2019/2/25.
//  Copyright © 2019年 Ideal-link. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// Override this method in UIViewController derived class to handle 'Back' button click
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>

@end
NS_ASSUME_NONNULL_END
