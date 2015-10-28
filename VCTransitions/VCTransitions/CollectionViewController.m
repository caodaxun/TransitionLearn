//
//  CollectionViewController.m
//  VCTransitions
//
//  Created by Tyler Tillage on 7/3/13.
//  Copyright (c) 2013 CapTech. All rights reserved.
//

#import "CollectionViewController.h"

@implementation CollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

#pragma mark - Collection View Data Source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    for (UIView *v in cell.contentView.subviews) [v removeFromSuperview];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"apple_logo"]];
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.contentView addSubview:imageView];
    
    [cell.contentView removeConstraints:cell.contentView.constraints];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(imageView)]];
    return cell;
}

#pragma mark - Collection View Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(54.0, 54.0);
        
    CollectionViewController *VC = [[CollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
    VC.title = @"Mini Apples";
    VC.useLayoutToLayoutNavigationTransitions = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

@end
