//
//  AMViewController.h
//  TagListViewDemo
//
//  Created by Andrea Mazzini on 20/01/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagsEditControllerDelegate <NSObject>

@required

-(void)skillsChanged:(NSArray *)array;

@end

@interface TagsEditController : UIViewController

@property (weak, nonatomic)
id<TagsEditControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *skills;

@end
