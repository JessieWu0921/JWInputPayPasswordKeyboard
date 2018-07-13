//
//  ViewController.m
//  JWInputPayPasswordKeyboard
//
//  Created by JessieWu on 2018/7/12.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

#import "ViewController.h"

#import "JWInputPasswordView.h"

#import <Masonry/Masonry.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *payPasswordBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - methods

#pragma mark - actions & events
- (IBAction)clickedBtn:(id)sender {
//    UIButton *btn = (UIButton *)sender;
//    btn.userInteractionEnabled = NO;
    [JWInputPasswordView showInputPasswordKeyboard:self.view forget:^{
        NSLog(@"i forget my password.");
//        btn.userInteractionEnabled = YES;
    } completion:^(NSString *password) {
//        btn.userInteractionEnabled = YES;
        NSLog(@"pay password is: %@", password);
    } cancel:^{
//        btn.userInteractionEnabled = YES;
        NSLog(@"input have been canceled.");
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //点击键盘外部，收起键盘
    CGPoint touchLocation = [((UITouch *)touches.anyObject) locationInView:self.view.subviews.lastObject];
    if ([self.view.subviews.lastObject isKindOfClass:[JWInputPasswordView class]] && touchLocation.y < 0) {
        [JWInputPasswordView dismissFromView:self.view];
    }
}

@end
