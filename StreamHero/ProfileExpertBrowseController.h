//
//  ProfileExpertBrowseController.h
//  StreamHero
//
//  Created by Markus on 22/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@class MBProgressHUD;
@interface ProfileExpertBrowseController : UIViewController{
    MBProgressHUD *HUD;
}

@property (strong, nonatomic) NSDictionary *selectedExpert;



@end
