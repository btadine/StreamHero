//
//  ProfileController.h
//  Petit Comité
//
//  Created by Markus on 16/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagsEditController.h"
#import "CellSwitch.h"

@class MBProgressHUD;

@interface ProfileController : UIViewController <TagsEditControllerDelegate,CellSwitchDelegate>{
    MBProgressHUD *HUD;
}

@property (weak, nonatomic) IBOutlet UIView *tagView;
@property (nonatomic, strong) NSArray* userInfo;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* childByAutoId;


@end
