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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self layoutUI];
}


#pragma mark - methods
- (void)layoutUI {
    UIView *view1 = [[UIView alloc] init];
    [self.view addSubview:view1];
    
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(200);
        make.height.mas_equalTo(300);
    }];
    [view1 setBackgroundColor:[UIColor redColor]];
}

#pragma mark - actions & events
- (IBAction)clickedBtn:(id)sender {
    [JWInputPasswordView showInputPasswordKeyboard:self.view completion:^(NSString *password) {
        NSLog(@"pay password is: %@", password);
    } cancel:^{
        NSLog(@"input have been canceled.");
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint touchLocation = [((UITouch *)touches.anyObject) locationInView:self.view.subviews.lastObject];
    if ([self.view.subviews.lastObject isKindOfClass:[JWInputPasswordView class]] && touchLocation.y < 0) {
        [JWInputPasswordView dismissFromView:self.view];
    }
}

@end
