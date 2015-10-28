//
//  OptionsViewController.h
//  VCTransitions
//
//  Created by Tyler Tillage on 7/3/13.
//  Copyright (c) 2013 CapTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#define USER_DEFAULTS_CUSTOM_TRANSITIONS @"CustomTransitionsEnabled"
#define USER_DEFAULTS_NAVIGATION_TRANSITION @"NavigationTransition"
#define USER_DEFAULTS_NAVIGATION_TRANSITION_SLIDE @"NavigationSlide"
#define USER_DEFAULTS_NAVIGATION_TRANSITION_FLIP @"NavigationFlip"
#define USER_DEFAULTS_NAVIGATION_TRANSITION_SCALE @"NavigationScale"

@interface OptionsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView *contentView;

-(IBAction)dismissModal:(id)sender;

@end
