//
//  CYCustomArcImageView.h
//  ProjectComponentDemo
//
//  Created by Mr.GCY on 2018/4/20.
//  Copyright © 2018年 Mr.GCY. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CYCustomArcImageView : UIView

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat borderRadius;
@property (nonatomic, assign) CGFloat borderTopLeftRadius;
@property (nonatomic, assign) CGFloat borderTopRightRadius;
@property (nonatomic, assign) CGFloat borderBottomLeftRadius;
@property (nonatomic, assign) CGFloat borderBottomRightRadius;
@end
