//
//  RegisterViewController.m
//  Petit Comité
//
//  Created by Markus on 16/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import "RegisterViewController.h"


#define kMainPath @"https://resplendent-fire-5031.firebaseio.com/"
#define kUsersPath @"https://resplendent-fire-5031.firebaseio.com/users/"

@interface RegisterViewController () <UITextFieldDelegate>
@property (nonatomic, strong) NSNumber* isTeacher;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)register{
    
    NSString *email = self.email.text;
    
    NSString *password = self.password.text;
    
    Firebase *ref = [[Firebase alloc] initWithUrl:kMainPath];
    
    [ref createUser:email password:password
withValueCompletionBlock:^(NSError *error, NSDictionary *result) {
    if (error) {
       

        
        self.light.backgroundColor = [UIColor redColor];
        
    } else {
        NSString *uid = [result objectForKey:@"uid"];
        
        
        self.userId = uid;
        
        self.light.backgroundColor = [UIColor greenColor];
        
        if(self.expertSwitch.isOn){
            
            self.isTeacher = @YES;
            
        }else{
            
            self.isTeacher = @NO;
            
        }
        
        
        self.userFirebase = [[Firebase alloc]initWithUrl:kUsersPath];
        
        [[self.userFirebase childByAppendingPath:self.userId] setValue:@{@"username":self.email.text,
                                                                         @"is_expert":self.isTeacher}];
    }
}];

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self register];
    
        return NO;
}
- (IBAction)cancelButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)registerButton:(id)sender {
    
    [self.view endEditing:YES];
    [self register];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
