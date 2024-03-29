//
//  UIButton+TitleImageSpace.m
//  MiDou
//
//  Created by midou on 2018/9/26.
//  Copyright © 2018年 WJ. All rights reserved.
//

#import "UIButton+TitleImageSpace.h"

@implementation UIButton (TitleImageSpace)

- (void)layoutButtonWithEdgeInsetsStyle:(WJButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space
{
     // 1. 得到imageView和titleLabel的宽、高
     CGFloat imageWith = self.imageView.frame.size.width;
     CGFloat imageHeight = self.imageView.frame.size.height;
     CGFloat labelWidth = 0.0;
     CGFloat labelHeight = 0.0;
     if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
          // 由于iOS8中titleLabel的size为0，用下面的这种设置
          labelWidth = self.titleLabel.intrinsicContentSize.width;
          labelHeight = self.titleLabel.intrinsicContentSize.height;
          
     }else {
          labelWidth = self.titleLabel.frame.size.width;
          labelHeight = self.titleLabel.frame.size.height;
          
     }
     // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
     UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
     UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
     // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
     switch (style) {
          case WJButtonEdgeInsetsStyleTop:
          {
               imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
               labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
               
          }
          break;
          case WJButtonEdgeInsetsStyleLeft:
          {
               imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
               labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
               
          }
          break;
          case WJButtonEdgeInsetsStyleBottom:
          {
               imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
               labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
               
          }
          break;
          case WJButtonEdgeInsetsStyleRight:
          {
               imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
               labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
               
          }
          break;
          default:
          break;
               
     }
     // 4. 赋值
     self.titleEdgeInsets = labelEdgeInsets;
     self.imageEdgeInsets = imageEdgeInsets;
     
}

@end
