//
//  SkillsCell.m
//  StreamHero
//
//  Created by Markus on 20/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import "SkillsCell.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface SkillsCell () <AMTagListDelegate>



@property (nonatomic, strong) AMTagView             *selection;



@end

@implementation SkillsCell



- (void)awakeFromNib {
    
    
    [super awakeFromNib];
    
    [[AMTagView appearance] setTagLength:10];
    [[AMTagView appearance] setTextPadding:14];
    [[AMTagView appearance] setTextFont:[UIFont fontWithName:@"Futura" size:14]];
    [[AMTagView appearance] setTagColor:UIColorFromRGB(0x1f8dd6)];
    
    self.tagListView.tagListDelegate = self;
    


    
}


- (BOOL)tagList:(AMTagListView *)tagListView shouldAddTagWithText:(NSString *)text resultingContentSize:(CGSize)size
{
    // Don't add a 'bad' tag
    return ![text isEqualToString:@"bad"];
}

@end
