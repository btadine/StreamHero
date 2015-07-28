//
//  MyTableViewCellWithTextField.m
//  StreamHero
//
//  Created by Markus on 19/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import "MyTableViewCellWithTextField.h"

@implementation MyTableViewCellWithTextField


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Here you layout your self.titleLabel and self.propertyTextField as you want them, like they are in the WiFi settings.
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
