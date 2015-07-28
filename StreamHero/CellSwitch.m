//
//  CellSwitch.m
//  StreamHero
//
//  Created by Markus on 20/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import "CellSwitch.h"

@implementation CellSwitch
@synthesize delegate;

- (void)awakeFromNib {
    
  [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"expert"];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)expertSwitchButton:(id)sender {
    
    if (self.expertSwitch.isOn){
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"expert"];
    }
    
    if (!self.expertSwitch.isOn){
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"expert"];
    }
    
    if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(reloadMyTable)]) {
        [delegate reloadMyTable];

    }

    if(self.delegate != NULL && [self.delegate respondsToSelector:@selector(enableSaveButton)]){
        [delegate enableSaveButton];
    }
}

@end
