//
//  CYCustomArcButton.h
//  mandarinApp
//
//  Created by TonyReet on 2019/4/25.
//  Copyright © 2019 PKL. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CYCustomArcButton : UIButton

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) CGFloat borderRadius;
@property (nonatomic, assign) CGFloat borderTopLeftRadius;
@property (nonatomic, assign) CGFloat borderTopRightRadius;
@property (nonatomic, assign) CGFloat borderBottomLeftRadius;
@property (nonatomic, assign) CGFloat borderBottomRightRadius;

@end

NS_ASSUME_NONNULL_END
