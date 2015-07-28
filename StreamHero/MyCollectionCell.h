//
//  MyCollectionCell.h
//  
//
//  Created by Markus on 18/6/15.
//
//

#import <UIKit/UIKit.h>

@interface MyCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIImageView *icon;

@end
