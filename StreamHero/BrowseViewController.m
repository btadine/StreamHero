//
//  BrowseViewController.m
//  Petit Comité
//
//  Created by Markus on 17/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import "BrowseViewController.h"
#import "MyCollectionCell.h"
#import "SubCategoriesViewController.h"


@interface BrowseViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSMutableArray* subjectsArray;
@property (nonatomic, strong) NSArray* images;
@property (nonatomic, strong) NSArray* icons;
@property (nonatomic) NSInteger index;
@end

@implementation BrowseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.subjectsArray = [NSMutableArray arrayWithArray:@[@"Geography",@"Chemistry",@"Design",@"Citizenship",@"Maths",@"Art",@"History",@"Phisics",@"Programming",@"Languages",@"Publicity",@"Cinema"]];
    
    self.images = @[[UIImage imageNamed:@"map2.jpg"],[UIImage imageNamed:@"chemistry.jpg"],[UIImage imageNamed:@"design.jpg"],[UIImage imageNamed:@"citizenship.jpg"],[UIImage imageNamed:@"maths.jpg"],[UIImage imageNamed:@"art.jpg"],[UIImage imageNamed:@"history.jpg"],[UIImage imageNamed:@"physics2.jpg"],[UIImage imageNamed:@"programming.jpg"],[UIImage imageNamed:@"languages3.jpg"],[UIImage imageNamed:@"publicity.jpg"],[UIImage imageNamed:@"cinema.jpg"]];
    
    self.icons = @[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"], [UIImage imageNamed:@"3"], [UIImage imageNamed:@"4"], [UIImage imageNamed:@"5"], [UIImage imageNamed:@"6"], [UIImage imageNamed:@"7"], [UIImage imageNamed:@"8"], [UIImage imageNamed:@"9"], [UIImage imageNamed:@"10"], [UIImage imageNamed:@"11"], [UIImage imageNamed:@"12"]];

    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
   // [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.subjectsArray.count;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.index = indexPath.row;
    
    return YES;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"subjectCell" forIndexPath:indexPath];
    
    
    cell.label.text = self.subjectsArray[indexPath.row];
    
    UIImage* myImage = self.images[indexPath.row];
    
    UIImage* myIcon = self.icons[indexPath.row];
    
    cell.image.image = myImage;
    
    cell.icon.image = myIcon;

    
    return cell;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    SubCategoriesViewController * VC = segue.destinationViewController;
   
}


@end
