//
//  MyTableCell.m
//  StreamHero
//
//  Created by Markus on 18/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import "MyTableCell.h"
#import <UIImageView+Letters.h>

@implementation MyTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
   
    
    self.layer.borderWidth = 0.0f;
    
    self.photoView.layer.cornerRadius = self.photoView.frame.size.width/2;
    self.photoView.layer.masksToBounds = YES;
    

    
 
}

@end
