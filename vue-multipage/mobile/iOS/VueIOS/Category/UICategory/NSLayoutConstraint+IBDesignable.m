//
//  NSLayoutConstraint+IBDesignable.m
//  OfficeManagement
//
//  Created by Sjw on 2019/1/24.
//  Copyright © 2019年 ideal-link. All rights reserved.
//

#import "NSLayoutConstraint+IBDesignable.h"

@implementation NSLayoutConstraint (IBDesignable)

-(void)setWidthScreen:(BOOL)widthScreen{
    if (widthScreen) {
        self.constant = SCALE_WIDTH(self.constant);
    }else{
        self.constant = self.constant;
    }
}

-(BOOL)widthScreen{
    return self.widthScreen;
}

@end
