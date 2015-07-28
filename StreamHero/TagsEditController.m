//
//  AMViewController.m
//  TagListViewDemo
//
//  Created by Andrea Mazzini on 20/01/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import "TagsEditController.h"
#import "AMTagListView.h"
#import "ProfileController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TagsEditController () <UITextFieldDelegate, UIAlertViewDelegate, AMTagListDelegate>

@property (weak, nonatomic) IBOutlet UITextField    *textField;
@property (weak, nonatomic) IBOutlet AMTagListView	*tagListView;
@property (nonatomic, strong) AMTagView             *selection;


@end

@implementation TagsEditController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setTitle:@"Your Skills"];
	
	[self.textField.layer setBorderColor:UIColorFromRGB(0x1f8dd6).CGColor];
	[self.textField.layer setBorderWidth:2];
	[self.textField setDelegate:self];
    
	[[AMTagView appearance] setTagLength:10];
	[[AMTagView appearance] setTextPadding:14];
	[[AMTagView appearance] setTextFont:[UIFont fontWithName:@"Futura" size:14]];
	[[AMTagView appearance] setTagColor:UIColorFromRGB(0x1f8dd6)];
	
	
    [[AMTagView appearance] setAccessoryImage:[UIImage imageNamed:@"close"]];
    
    
    [self.tagListView addTags:self.skills.copy];
    
    
    
    self.tagListView.tagListDelegate = self;
	
	__weak TagsEditController* weakSelf = self;
	[self.tagListView setTapHandler:^(AMTagView *view) {
		weakSelf.selection = view;
        
        [self.tagListView removeTag:self.selection];
        [self.skills removeObjectIdenticalTo:self.selection.tagText];
        
        
			}];
}

- (BOOL)tagList:(AMTagListView *)tagListView shouldAddTagWithText:(NSString *)text resultingContentSize:(CGSize)size
{
    // Don't add a 'bad' tag
    return ![text isEqualToString:@"bad"];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self.tagListView addTag:textField.text];
    [self.skills addObject:textField.text];
    [self.textField setText:@""];
    
	return YES;
}

// Close the keyboard when the user taps away froma  textfield
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]])
			[view resignFirstResponder];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.delegate skillsChanged:self.skills.copy];
}

@end
