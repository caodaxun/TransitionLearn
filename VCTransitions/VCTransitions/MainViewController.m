//
//  MainViewController.m
//  VCTransitions
//
//  Created by Tyler Tillage on 7/3/13.
//  Copyright (c) 2013 CapTech. All rights reserved.
//

#import "MainViewController.h"
#import "OptionsViewController.h"
#import "ImageViewController.h"
#import "CollectionViewController.h"

#import "ModalAnimation.h"
#import "SlideAnimation.h"
#import "ShuffleAnimation.h"
#import "ScaleAnimation.h"

@interface MainViewController () {
    NSArray *_cellTitles, *_cellActions;
    ModalAnimation *_modalAnimationController;
    SlideAnimation *_slideAnimationController;
    ShuffleAnimation *_shuffleAnimationController;
    ScaleAnimation *_scaleAnimationController;
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    //Setup our table view info
    _cellTitles = @[@"Image View", @"Collection View"];
    _cellActions = @[@"presentImageController", @"presentCollectionController"];
    
    //Load our animation controllers
    _modalAnimationController = [[ModalAnimation alloc] init];
    _slideAnimationController = [[SlideAnimation alloc] init];
    _shuffleAnimationController = [[ShuffleAnimation alloc] init];
    _scaleAnimationController = [[ScaleAnimation alloc] initWithNavigationController:self.navigationController];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _scaleAnimationController.viewForInteraction = nil;
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _cellTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [_cellTitles objectAtIndex:indexPath.row];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 0) return @"Tap Options for different animations and other settings.";
    return nil;
}

#pragma mark - Table View Delegate

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SEL selector = NSSelectorFromString([_cellActions objectAtIndex:indexPath.row]);
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector];
    }
}

#pragma mark - Custom Methods

-(IBAction)showOptions:(id)sender {
    OptionsViewController *modal = [[OptionsViewController alloc] initWithNibName:@"OptionsViewController" bundle:[NSBundle mainBundle]];
    modal.transitioningDelegate = self;
    modal.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:modal animated:YES completion:nil];
}

-(void)presentImageController {
    ImageViewController *imageController = [[ImageViewController alloc] init];
    imageController.title = @"Apple";
    _scaleAnimationController.viewForInteraction = imageController.view;
    [self.navigationController pushViewController:imageController animated:YES];
}

-(void)presentCollectionController {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(80.0, 80.0);
    CollectionViewController *collectionController = [[CollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
    collectionController.title = @"Apples";
    [self.navigationController pushViewController:collectionController animated:YES];
}

#pragma mark - Transitioning Delegate (Modal)
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    _modalAnimationController.type = AnimationTypePresent;
    return _modalAnimationController;
}

-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    _modalAnimationController.type = AnimationTypeDismiss;
    return _modalAnimationController;
}

#pragma mark - Navigation Controller Delegate

-(id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:USER_DEFAULTS_CUSTOM_TRANSITIONS]) return nil;
    if ([fromVC isKindOfClass:CollectionViewController.class] && ![toVC isEqual:self]) return nil;
    
    BaseAnimation *animationController;
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_NAVIGATION_TRANSITION] isEqualToString:USER_DEFAULTS_NAVIGATION_TRANSITION_SLIDE]) {
        animationController = _slideAnimationController;
    } else if ([[[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_NAVIGATION_TRANSITION] isEqualToString:USER_DEFAULTS_NAVIGATION_TRANSITION_FLIP]) {
        animationController = _shuffleAnimationController;
    } else if ([[[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_NAVIGATION_TRANSITION] isEqualToString:USER_DEFAULTS_NAVIGATION_TRANSITION_SCALE]) {
        animationController = _scaleAnimationController;
    }
    switch (operation) {
        case UINavigationControllerOperationPush:
            animationController.type = AnimationTypePresent;
            return  animationController;
        case UINavigationControllerOperationPop:
            animationController.type = AnimationTypeDismiss;
            return animationController;
        default: return nil;
    }

}

-(id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    if ([animationController isKindOfClass:[ScaleAnimation class]]) {
        ScaleAnimation *controller = (ScaleAnimation *)animationController;
        if (controller.isInteractive) return controller;
        else return nil;
    } else return nil;
}

@end
