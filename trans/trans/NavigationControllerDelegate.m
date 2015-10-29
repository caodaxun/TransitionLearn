//
//  NavigationControllerDelegate.m
//  trans
//
//  Created by caodaxun_iMac on 15/10/29.
//  Copyright © 2015年 SWCM. All rights reserved.
//

#import "NavigationControllerDelegate.h"
#import "Animator.h"

static NSString * PushSegueIdentifier = @"push segue identifier";

@interface NavigationControllerDelegate ()

@property (weak, nonatomic) IBOutlet UINavigationController *navigationController;
@property (strong, nonatomic) Animator* animator;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;

@end

@implementation NavigationControllerDelegate

- (void)awakeFromNib {
    UIPanGestureRecognizer *panReconizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.navigationController.view addGestureRecognizer:panReconizer];
    self.animator = [Animator new];
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    
    UIView *view = self.navigationController.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:view];
        if (location.x > CGRectGetMinX(view.bounds) && self.navigationController.viewControllers.count == 1) {
            self.interactionController = [UIPercentDrivenInteractiveTransition new];
            
            //如果不是storyboard 直接使用pushViewController
            [self.navigationController.visibleViewController performSegueWithIdentifier:PushSegueIdentifier sender:self];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:view];
        // fabs() 求浮点数的绝对值
        //根据用户手指拖动的距离计算一个百分比，切换的动画效果也随着这个百分比来走
        CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
        [self.interactionController updateInteractiveTransition:d];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        //根据用户手势的停止状态来判断该操作是结束还是取消
        //velocityInView 检测手势的速度
        if ([recognizer velocityInView:view].x < 0) {
            [self.interactionController finishInteractiveTransition];
        } else {
            [self.interactionController cancelInteractiveTransition];
        }
        self.interactionController = nil;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (operation == UINavigationControllerOperationPush) {
        return self.animator;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return self.interactionController;
}

@end
