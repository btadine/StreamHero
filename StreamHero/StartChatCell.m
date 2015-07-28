//
//  StartChatCell.m
//  StreamHero
//
//  Created by Markus on 26/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import "StartChatCell.h"

@implementation StartChatCell
@synthesize delegate;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)startAction:(id)sender {


if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(startChat)]) {
    [delegate startChat];
    
}
}

@end
