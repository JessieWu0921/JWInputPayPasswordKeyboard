//
//  JWInputPasswordView.m
//  JWInputPayPasswordKeyboard
//
//  Created by JessieWu on 2018/7/12.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

#import "JWInputPasswordView.h"

#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

#import <Masonry/Masonry.h>
#import <IQKeyboardManager/IQKeyboardManager.h>

#define TextFieldContainerHeight 150.0f
#define TextFieldWidth  50.0f
#define TextFieldHeight 50.0f
#define TextFieldLeftOffset 10.0f
#define TextFieldRightOffset 10.0f

static CGFloat keyboardHeight = 0.0;

@interface JWInputPasswordView()<UITextFieldDelegate>

@property (nonatomic, copy) NSArray *textFields;
@property (nonatomic, copy) completionBlock completionBlock;
@property (nonatomic, copy) cancelBlock cancelBlock;
@property (nonatomic, copy) forgetPasswordBlock forgetPasswordBlock;
@property (nonatomic, strong) UIView *showInView;
@property (nonatomic, strong) UITextField *hiddenTextField;

@end

@implementation JWInputPasswordView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addKeyboardNotification];
        [self UILayout];
    }
    return self;
}

- (void)dealloc {
    [self removeNotification];
}

#pragma mark - setter & getter

#pragma mark - private methods
- (void)resetUI {
    CGRect frame = self.frame;
    CGSize size = frame.size;
    CGFloat height = TextFieldContainerHeight + keyboardHeight;
    size.height = height;
    frame.size = size;
    self.frame = frame;
}

- (void)UILayout {
    [self layoutHiddenTextField];
    //container view
    UIView *containerView = [[UIView alloc] init];
    [self addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.equalTo(@(TextFieldContainerHeight));
    }];
    [containerView setBackgroundColor:[UIColor whiteColor]];
    //布局toolbar
    UIView *toolBar = [[UIView alloc] init];
    [containerView addSubview:toolBar];
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(containerView);
        make.height.mas_equalTo(50);
    }];
    [self layoutToolbar:toolBar];
    
    UILabel *introLabel = [[UILabel alloc] init];
    [containerView addSubview:introLabel];
    [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(toolBar.mas_bottom).mas_offset(10);
        make.left.equalTo(containerView).mas_offset(10);
    }];
    [introLabel setText:@"请输入支付密码"];
    [introLabel setFont:[UIFont systemFontOfSize:16.0f]];
    
    UIButton *forgetPasswordBtn = [[UIButton alloc] init];
    [containerView addSubview:forgetPasswordBtn];
    [forgetPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(containerView);
        make.top.equalTo(toolBar.mas_bottom).mas_offset(10);
        make.width.mas_equalTo(100);
        make.centerY.equalTo(introLabel.mas_centerY);
    }];
    [forgetPasswordBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [forgetPasswordBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [forgetPasswordBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [forgetPasswordBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [forgetPasswordBtn addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    //布局textfield
    [self layoutTextfield:containerView];
}

- (void)layoutHiddenTextField {
    //hiddentextfield
    self.hiddenTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 70.0)];
    [self addSubview:self.hiddenTextField];
    [self textFieldConfig];
}

- (void)layoutTextfield:(UIView *)containerView {
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat betweenWidth = (width - TextFieldLeftOffset - TextFieldRightOffset - 6 * TextFieldWidth) / 5;
    CGFloat topOffset = 10.0;
    
    NSMutableArray *subViews = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 6; i++) {
        UITextField *textField = [[UITextField alloc] init];
        [containerView addSubview:textField];
        [subViews addObject:textField];
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(TextFieldWidth);
            make.height.mas_equalTo(TextFieldHeight);
            make.bottom.equalTo(containerView).offset(-topOffset);
            if (i == 0) {
                make.left.equalTo(self).mas_offset(TextFieldLeftOffset);
            } else if (i == 5) {
                make.right.equalTo(self).mas_offset(-TextFieldRightOffset);
            } else {
                UITextField *lastView = (UITextField *)subViews[i - 1];
                make.left.equalTo(lastView.mas_right).mas_offset(betweenWidth);
            }
        }];
        [self textFieldConfig:textField];
    }
    self.textFields = [NSArray arrayWithArray:subViews];
}

- (void)layoutToolbar:(UIView *)toolBar {
    UIView *topLine = [[UIView alloc] init];
    [toolBar addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(toolBar);
        make.height.mas_equalTo(1);
    }];
    [topLine setBackgroundColor:[UIColor lightGrayColor]];
    
    UIButton *cancelBtn = [[UIButton alloc] init];
    [toolBar addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(toolBar);
        make.left.equalTo(toolBar).mas_equalTo(10);
        make.width.mas_equalTo(50);
    }];
    [cancelBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *titleLabel = [[UILabel alloc] init];
    [toolBar addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(toolBar);
        make.left.equalTo(cancelBtn.mas_right);
        make.center.equalTo(toolBar);
    }];
    [titleLabel setText:@"输入密码"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *lineView = [[UIView alloc] init];
    [toolBar addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(toolBar);
        make.height.mas_equalTo(1);
    }];
    [lineView setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)textFieldConfig:(UITextField *)textField {
    textField.secureTextEntry = YES;
    textField.userInteractionEnabled = NO;
    textField.layer.masksToBounds = YES;
    textField.layer.borderColor = [UIColor blackColor].CGColor;
    textField.layer.borderWidth = 1.0f;
    textField.textAlignment = NSTextAlignmentCenter;
}

- (void)textFieldConfig {
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    self.hiddenTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.hiddenTextField.delegate = self;
    [self.hiddenTextField becomeFirstResponder];
}

- (void)showOrHiddenAnimation:(BOOL)show {
    //0.25f是从键盘的弹出动画的duration获取的，也可以通过获取keyboard里的信息来动态设置这个时间
    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame = self.frame;
        if (show) {
            if (frame.size.height > TextFieldContainerHeight) {
                frame.origin.y = CGRectGetHeight(self.showInView.frame) - CGRectGetHeight(self.frame);
            }
        } else {
            frame.origin.y = CGRectGetHeight(self.showInView.frame);
            [self removeFromSuperview];
        }
        self.frame = frame;
    }];
}

- (void)dismiss {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self showOrHiddenAnimation:NO];
}

#pragma mark - notification
- (void)addKeyboardNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - public method
+ (void)showInputPasswordKeyboard:(id)view forget:(forgetPasswordBlock)forget completion:(completionBlock)completion cancel:(cancelBlock)cancel {
    JWInputPasswordView *inputView = [[JWInputPasswordView alloc] initWithFrame:CGRectMake(0, ((UIView *)view).frame.size.height, ((UIView *)view).frame.size.width, TextFieldContainerHeight + keyboardHeight)];
    inputView.showInView = view;
    [inputView.showInView addSubview:inputView];
    
    inputView.forgetPasswordBlock = forget;
    inputView.completionBlock = completion;
    inputView.cancelBlock = cancel;
    
    //动画
    [inputView showOrHiddenAnimation:YES];
}

+ (void)dismissFromView:(UIView *)view {
    if ([view.subviews.lastObject isKindOfClass:[JWInputPasswordView class]]) {
        JWInputPasswordView *subView = view.subviews.lastObject;
        [subView dismiss];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.location >= 6) {
        return NO;
    } else {
        NSUInteger location = range.location;
        UITextField *tf = self.textFields[location];
        tf.text = string;
    }
    if (range.location == 5 && string.length > 0) {
        NSMutableString *passwordStr = [NSMutableString stringWithString:textField.text];
        [passwordStr appendString:string];
        if (self.completionBlock) {
            self.completionBlock(passwordStr);
        }
    }
    return YES;
}

#pragma mark - actions & events
- (void)showKeyboard:(NSNotification *)notification {
    //键盘将出现
    NSDictionary *userInfo = notification.userInfo;
    NSValue *keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect frame = keyboardFrame.CGRectValue;
    CGFloat height = CGRectGetHeight(frame);
    if (keyboardHeight != height) {
        keyboardHeight = CGRectGetHeight(frame);
        [self resetUI];
    }
}

- (void)hideKeyboard:(NSNotification *)notification {
    //键盘消失
}

- (void)forgetPassword:(id)sender {
    if (self.forgetPasswordBlock) {
        self.forgetPasswordBlock();
    }
}

- (void)cancel:(id)sender {
    [self dismiss];
    [self removeNotification];
}

@end
