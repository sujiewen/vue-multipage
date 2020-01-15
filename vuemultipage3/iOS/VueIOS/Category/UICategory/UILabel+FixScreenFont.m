//
//  UILabel+FixScreenFont.m
//  OfficeManagement
//
//  Created by Sjw on 2019/1/24.
//  Copyright © 2019年 ideal-link. All rights reserved.
//

#import "UILabel+FixScreenFont.h"

@implementation UILabel (FixScreenFont)

- (void)setFixWidthScreenFont:(float)fixWidthScreenFont{
    
    if (fixWidthScreenFont > 0 ) {
        self.font = [UIFont systemFontOfSize:SCALE_WIDTH(fixWidthScreenFont)];
    }else{
        self.font = self.font;
    }
}

- (float )fixWidthScreenFont{
    return self.fixWidthScreenFont;
}

@end
