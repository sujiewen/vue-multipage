//
//  UILabel+ContextSize.m
//  OfficeManagement
//
//  Created by Sjw on 2018/12/4.
//  Copyright © 2018年 LXshun. All rights reserved.
//

#import "UILabel+ContextSize.h"

@implementation UILabel (ContextSize)

- (CGSize)contentSize:(NSString*)content width:(CGFloat)width {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:self.lineBreakMode];
    [style setAlignment:self.textAlignment];
    NSDictionary *dic = @{NSFontAttributeName : self.font, NSParagraphStyleAttributeName : style};
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil].size;
    return size;
}

@end
