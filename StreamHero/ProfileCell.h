//
//  ProfileCell.h
//  StreamHero
//
//  Created by Markus on 24/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+Letters.h"
#import <QuartzCore/QuartzCore.h>

@interface ProfileCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *headline;



@end
