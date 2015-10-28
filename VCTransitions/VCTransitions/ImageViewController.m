//
//  ImageViewController.m
//  VCTransitions
//
//  Created by Tyler Tillage on 7/3/13.
//  Copyright (c) 2013 CapTech. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () {
    UIImageView *_imageView;
}

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    UIImage *image = [UIImage imageNamed:@"apple_logo"];
    _imageView = [[UIImageView alloc] initWithImage:image];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_imageView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_imageView]-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
}

@end
