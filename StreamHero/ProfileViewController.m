//
//  ProfileViewController.m
//  Petit Comité
//
//  Created by Markus on 15/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileController.h"
#import <LIALinkedInApplication.h>
#import <LIALinkedInHttpClient.h>
#import <LIALinkedInAuthorizationViewController.h>

#define kMainPath @"https://resplendent-fire-5031.firebaseio.com/"
#define kUsersPath @"https://resplendent-fire-5031.firebaseio.com/users/"

@interface ProfileViewController () <UITextFieldDelegate>
@end

@implementation ProfileViewController



-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if([[NSUserDefaults standardUserDefaults]
        stringForKey:@"userId"] != nil){
        
        ProfileController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"loggedin"];
        
        [VC.navigationItem setHidesBackButton:YES animated:NO];
        
        [self.navigationController pushViewController:VC animated:NO];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.loginButton.layer.cornerRadius = self.loginButton.frame.size.height/2;
    
    self.loginButton.layer.masksToBounds = YES;
    
    self.registerButton.layer.cornerRadius = self.loginButton.frame.size.height/2;
    
    self.registerButton.layer.masksToBounds = YES;
    
    self.name.layer.cornerRadius = self.name.layer.frame.size.height/2;
    
    self.name.layer.masksToBounds = YES;
    
    self.password.layer.cornerRadius = self.password.layer.frame.size.height/2;
    
    self.password.layer.masksToBounds = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)loginButton:(id)sender {
    
    [self.view endEditing:YES];
    
    [self login];
}

-(void)login{
    
    self.userName = self.name.text;
    
    NSString *password = self.password.text;
    
    self.loginFirebase = [[Firebase alloc] initWithUrl:kMainPath];
    
    [self.loginFirebase authUser:self.userName password:password withCompletionBlock:^(NSError *error, FAuthData *authData) {
    if (error) {
        // There was an error logging in to this account
        self.light.backgroundColor = [UIColor redColor];
        
        
    } else {
        
        self.light.backgroundColor = [UIColor greenColor];
        
        self.userId = authData.uid;
        
        self.userFirebase = [[Firebase alloc]initWithUrl:kUsersPath];
        
        
        
        [[NSUserDefaults standardUserDefaults] setObject:self.userId forKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}];
    
   

}
- (IBAction)loginWithLinkedin:(id)sender {
        [self.client getAuthorizationCode:^(NSString *code) {
            [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
                NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
                [self requestMeWithToken:accessToken];
                
                
            }                   failure:^(NSError *error) {
                NSLog(@"Quering accessToken failed %@", error);
            }];
        }                      cancel:^{
            NSLog(@"Authorization was cancelled by user");
        }                     failure:^(NSError *error) {
            NSLog(@"Authorization failed %@", error);
        }];

}

- (void)requestMeWithToken:(NSString *)accessToken {
    
        [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,maiden-name,email-address,headline)?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
            
            NSLog(@"%@", result);
            
            
            NSString *username = [NSString stringWithFormat:@"%@ %@",[result objectForKey:@"firstName"],[result objectForKey:@"lastName"]];
            
            NSString *headline = [result objectForKey:@"headline"];
            
            NSString *userId = [result objectForKey:@"id"];
            
            NSString *mail = [result objectForKey:@"emailAddress"];
            
            
            
            self.userFirebase = [[Firebase alloc]initWithUrl:kUsersPath];
            
            
            [[[self.userFirebase queryOrderedByChild:@"mail"] queryEqualToValue:mail] observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
                
                if([snapshot.value isKindOfClass:[NSDictionary class]]){
                    
                    if([[snapshot.value allValues] firstObject][@"favorites"] != nil){
                        
                        [[NSUserDefaults standardUserDefaults] setObject:[[snapshot.value allValues] firstObject][@"favorites"] forKey:@"favorites"];
                    }
                    
                     NSArray* userArray = @[[result objectForKey:@"firstName"],[result objectForKey:@"lastName"],headline,userId,mail];
                    
                    NSString *path = [NSString stringWithFormat:@"%@/%@",kUsersPath,[[[snapshot value] allKeys] firstObject]];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:path forKey:@"autoId"];
                    
                      [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
                      [[NSUserDefaults standardUserDefaults] setObject:userArray forKey:@"userArray"];
                    
                     [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    ProfileController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"loggedin"];
                    
                    
                    [VC.navigationItem setHidesBackButton:YES animated:NO];
                    
                    [self.navigationController pushViewController:VC animated:YES];
                    
                } else if (![snapshot.value isKindOfClass:[NSDictionary class]]){
                
                    
                    [[self.userFirebase childByAutoId] setValue:@{@"username":username,
                                                                  @"userId":userId,
                                                                  @"mail":mail,
                                                                  @"headline":headline}withCompletionBlock:^(NSError *error, Firebase *ref) {
                                                                      NSString *childByAutoId = [NSString stringWithFormat:@"%@",ref];
                                                                      
                                                                      NSArray* userArray = @[[result objectForKey:@"firstName"],[result objectForKey:@"lastName"],headline,userId,mail];
                                                                      
                                                                      
                                                                      [[NSUserDefaults standardUserDefaults] setObject:userArray forKey:@"userArray"];
                                                                      [[NSUserDefaults standardUserDefaults] setObject:userId forKey:@"userId"];
                                                                      [[NSUserDefaults standardUserDefaults] setObject:childByAutoId forKey:@"autoId"];
                                                                      
                                                                      [[NSUserDefaults standardUserDefaults] synchronize];
                                                                      
                                                                      ProfileController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"loggedin"];
                                                                      
                                                                      
                                                                      
                                                                      
                                                                      [VC.navigationItem setHidesBackButton:YES animated:NO];
                                                                      
                                                                      [self.navigationController pushViewController:VC animated:YES];
                                                                  }];
                }
            }];
            
        }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed to fetch current user %@", error);
        }];
    }
              
    
- (LIALinkedInHttpClient *)client {
        LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:@"http://www.streamhero.co"
                                                                                        clientId:@"77d8o18hpq08uo"
                                                                                    clientSecret:@"SNfvi7TSobKGjNqq"
                                                                                           state:@"DCEEFWF45453sdffef424"
                                                                                   grantedAccess:@[@"r_basicprofile", @"r_emailaddress"]];
        
        
        return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
        
        
}

- (IBAction)keyboardRelease:(id)sender {
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    [self login];
    
    return NO;
    
}




@end
