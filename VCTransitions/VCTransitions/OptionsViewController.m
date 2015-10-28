//
//  OptionsViewController.m
//  VCTransitions
//
//  Created by Tyler Tillage on 7/3/13.
//  Copyright (c) 2013 CapTech. All rights reserved.
//

#import "OptionsViewController.h"

@interface OptionsViewController () {
    NSArray *_sectionTitles, *_cellTitles, *_cellActions;
    UISwitch *_transitionSwitch;
    NSString *_navigationTransition;
}

-(void)switchWasChanged;
-(void)toggleTransitions;

-(void)enableSlideAnimation;
-(void)enableShuffleAnimation;
-(void)enableScaleAnimation;

@end

@implementation OptionsViewController

static NSString *CellIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    _transitionSwitch = [[UISwitch alloc] init];
    [_transitionSwitch addTarget:self action:@selector(switchWasChanged) forControlEvents:UIControlEventValueChanged];
    
    // Modal view styling
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowOffset = CGSizeMake(0.0, 8.0);
    self.view.layer.shadowOpacity = 0.5;
    self.view.layer.shadowRadius = 10.0;
    self.view.layer.cornerRadius = 3.0;
    self.contentView.layer.cornerRadius = 3.0;
    self.contentView.layer.masksToBounds = YES;
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    _sectionTitles = @[@"General", @"Transition Type"];
    _cellTitles = @[@[@"Nav Transitions"], @[@"3D Slide", @"Shuffle", @"Scale"]];
    _cellActions = @[@[@"toggleTransitions"], @[@"enableSlideAnimation", @"enableShuffleAnimation", @"enableScaleAnimation"]];
}

#pragma mark - Table View Data Source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_sectionTitles objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionTitles = [_cellTitles objectAtIndex:section];
    return sectionTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[_cellTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        if (indexPath.row == 0) {
            _transitionSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:USER_DEFAULTS_CUSTOM_TRANSITIONS];
            cell.accessoryView = _transitionSwitch;
        }
    } else if (indexPath.section == 1) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *transition = [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULTS_NAVIGATION_TRANSITION];
        if (indexPath.row == 0 && [transition isEqualToString:USER_DEFAULTS_NAVIGATION_TRANSITION_SLIDE]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else if (indexPath.row == 1 && [transition isEqualToString:USER_DEFAULTS_NAVIGATION_TRANSITION_FLIP]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else if (indexPath.row == 2 && [transition isEqualToString:USER_DEFAULTS_NAVIGATION_TRANSITION_SCALE]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1) return @"The scale animation is interactive using a pinch gesture.";
    return nil;
}

#pragma mark - Table View Delegate

#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SEL selector = NSSelectorFromString([[_cellActions objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector];
    }
}

#pragma mark - Custom Methods

-(IBAction)dismissModal:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)toggleTransitions {
    [_transitionSwitch setOn:!_transitionSwitch.on animated:YES];
    [self switchWasChanged];
}

-(void)switchWasChanged {
    [[NSUserDefaults standardUserDefaults] setBool:_transitionSwitch.on forKey:USER_DEFAULTS_CUSTOM_TRANSITIONS];
}

-(void)enableSlideAnimation {
    [[NSUserDefaults standardUserDefaults] setObject:USER_DEFAULTS_NAVIGATION_TRANSITION_SLIDE forKey:USER_DEFAULTS_NAVIGATION_TRANSITION];
    [self.tableView reloadData];
}

-(void)enableShuffleAnimation {
    [[NSUserDefaults standardUserDefaults] setObject:USER_DEFAULTS_NAVIGATION_TRANSITION_FLIP forKey:USER_DEFAULTS_NAVIGATION_TRANSITION];
    [self.tableView reloadData];
}

-(void)enableScaleAnimation {
    [[NSUserDefaults standardUserDefaults] setObject:USER_DEFAULTS_NAVIGATION_TRANSITION_SCALE forKey:USER_DEFAULTS_NAVIGATION_TRANSITION];
    [self.tableView reloadData];
}

@end
