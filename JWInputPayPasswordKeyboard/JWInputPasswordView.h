//
//  JWInputPasswordView.h
//  JWInputPayPasswordKeyboard
//
//  Created by JessieWu on 2018/7/12.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^completionBlock)(NSString *password);
typedef void(^cancelBlock)(void);

@interface JWInputPasswordView : UIView

+ (void)showInputPasswordKeyboard:(id)view completion:(completionBlock)block cancel:(cancelBlock)cancel;
+ (void)dismissFromView:(UIView *)view;

@end
