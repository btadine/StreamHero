//
//  MyTableViewCellWithTextField.h
//  StreamHero
//
//  Created by Markus on 19/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTableViewCellWithTextField : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UITextField *theTextField;

@end
