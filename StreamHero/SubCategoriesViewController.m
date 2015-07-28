//
//  SubCategoriesViewController.m
//  StreamHero
//
//  Created by Markus on 23/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import "SubCategoriesViewController.h"
#import "MyCollectionCell.h"

@interface SubCategoriesViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSMutableArray *subcategories;
@end

@implementation SubCategoriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.subcategories = [NSMutableArray arrayWithArray:@[@"Javascript",@"Objective-C",@"Android",@"PHP",@"Scala",@"Swift",@"C",@"C++",@"C#"]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.subcategories.count;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"subCategoryCell" forIndexPath:indexPath];
    
    cell.label.text = self.subcategories[indexPath.row];
    
    cell.image.image = [UIImage imageNamed:@"template"];
    
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
