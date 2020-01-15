//
//  UILabel+ContextSize.h
//  OfficeManagement
//
//  Created by Sjw on 2018/12/4.
//  Copyright © 2018年 LXshun. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (ContextSize)

- (CGSize)contentSize:(NSString*)content width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
