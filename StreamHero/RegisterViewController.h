//
//  RegisterViewController.h
//  Petit Comité
//
//  Created by Markus on 16/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>


@interface RegisterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancel;
@property (weak, nonatomic) IBOutlet UIView *light;
@property (weak, nonatomic) IBOutlet UISwitch *expertSwitch;
@property (nonatomic, strong) Firebase *userFirebase;
@property (nonatomic, strong) NSString *userId;
@end
