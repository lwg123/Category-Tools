//
//  CHTextView.h
//  TouchCPlatform
//
//  Created by dengjc on 16/5/16.
//  Copyright © 2016年 changhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHTextView : UITextView

@property (nonatomic,strong) NSString *placeholder;

- (void)setPlaceholder:(NSString *)placeholder;

@end
