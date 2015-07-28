//
//  ProfileViewController.h
//  Petit Comité
//
//  Created by Markus on 15/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) NSString *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIView *light;
@property (nonatomic, strong) NSString *userId;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;


@property (nonatomic, strong) Firebase *userFirebase;
@property (nonatomic, strong) Firebase *loginFirebase;

@property (weak, nonatomic) IBOutlet UISwitch *expertSwitch;

@end
