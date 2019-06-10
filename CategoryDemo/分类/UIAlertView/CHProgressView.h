//
//  CHProgressView.h
//  TouchCPlatform
//
//  Created by 郑红 on 5/17/16.
//  Copyright © 2016 changhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHProgressView : UIView

@property(nonatomic, strong) UIColor* progressTintColor;
@property(nonatomic, strong) UIColor* trackTintColor;
@property(nonatomic, strong) UIImage* progressImage;
@property(nonatomic, strong) UIImage* trackImage;
@property(nonatomic, assign) CGFloat pProgress;

@end
