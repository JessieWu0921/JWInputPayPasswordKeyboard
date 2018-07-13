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
}


#pragma mark - methods

#pragma mark - actions & events
- (IBAction)clickedBtn:(id)sender {
    [JWInputPasswordView showInputPasswordKeyboard:self.view forget:^{
        NSLog(@"i forget my password.");
    } completion:^(NSString *password) {
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
