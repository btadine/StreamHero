//
//  ProfileExpertBrowseController.m
//  StreamHero
//
//  Created by Markus on 22/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import "ProfileExpertBrowseController.h"
#import "DemoMessagesViewController.h"
#import <UIImageView+Letters.h>
#import "ProfileCell.h"
#import "ChatCell.h"
#import "MBProgressHUD.h"
#import "DescriptionCell.h"
#import "StartChatCell.h"

#define kchatid @"https://resplendent-fire-5031.firebaseio.com/chats/"

@interface ProfileExpertBrowseController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate,MBProgressHUDDelegate, StartChatDelegate>

@property (nonatomic, strong) Firebase* newwChatFirebase;
@property (nonatomic, strong) Firebase* chatsFirebase;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* expertId;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *favorited;
@property (strong, nonatomic) NSMutableArray *favoritedComplete;
@property (strong, nonatomic) Firebase *currentUserFireBase;

@end

@implementation ProfileExpertBrowseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSString *childByAutoId = [[NSUserDefaults standardUserDefaults]stringForKey:@"autoId"];
    
    self.currentUserFireBase = [[Firebase alloc]initWithUrl:childByAutoId];
    
    
    [self.currentUserFireBase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
    
            
           self.favorited = snapshot.value [@"favorites"];
    }];



    self.favoritedComplete = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"]];
    
    self.chatsFirebase = [[Firebase alloc]initWithUrl:kchatid];
    
    self.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    
    self.expertId = [self.selectedExpert objectForKey:@"userId"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        
        self.tabBarController.selectedIndex = 3;
    }
}

-(void)addtoFavorites{
    
     NSString *userId = [self.selectedExpert objectForKey:@"userId"];
    
    [self.favorited addObject:userId];
    
    [self.favoritedComplete addObject:self.selectedExpert];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.favoritedComplete.copy forKey:@"favorites"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.currentUserFireBase updateChildValues:@{@"favorites":self.favoritedComplete} withCompletionBlock:^(NSError *error, Firebase *ref) {
       
    }];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    HUD.alpha = 0.5;
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.delegate = self;
    HUD.labelText = @"Added";
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1.3];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)startChat{
    
    if(self.userId == nil){
        
        UIAlertView *noUser = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Cannot start a chat without login" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Login", nil];
        
        [noUser show];
    }else{
    
    DemoMessagesViewController *chat = [self.storyboard instantiateViewControllerWithIdentifier:@"messages"];
    
    self.newwChatFirebase = [self.chatsFirebase childByAutoId] ;
    
    chat.expertName = [self.selectedExpert objectForKey:@"username"];
    
    chat.userId = self.userId;
    
    NSArray *defaults = [[NSUserDefaults standardUserDefaults] objectForKey:@"userArray"];
    
     NSString *username = [NSString stringWithFormat:@"%@ %@",[defaults firstObject],[defaults objectAtIndex:1]];
    
    __weak __typeof__(self) weakSelf = self;
    
    [self.newwChatFirebase setValue:@{@"userId" : self.userId,
                                      @"expertId": self.expertId,
                                      @"userName": username,
                                      @"expertName":[self.selectedExpert objectForKey:@"username"]
                                      
                                      
                                                                } withCompletionBlock:^(NSError *error, Firebase *ref) {
                                         
                                          
                                          
                                          
                                          NSArray * array = [ref.description componentsSeparatedByString:@"/"];
                                          
                                          chat.currentChat = [array objectAtIndex:4];
                                          
                                          
                                          
                                          
                                          UINavigationController *navigation = weakSelf.tabBarController.viewControllers[2];
                                          
                                          weakSelf.tabBarController.selectedIndex = 2;
                                          
                                          
                                          [navigation popToRootViewControllerAnimated:NO];
                                          
                                          [navigation hidesBottomBarWhenPushed];
                                          
                                          [navigation pushViewController:chat animated:NO];
           
                                          
                                          
                                          
                                          
                                          
                                          
                                      }];
    
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(section == 0){
    
    return 1;
    }
    if(section == 1){
        
        return 1;
    }

    
    if(section == 2){
        
        return 1;
        
    }
    
    if(section == 3){
        
        return 1;
        
    }

        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section ==0){
        return 209;
    }
    
    if(indexPath.section ==1){
        
        return 44;
    }
    
    if(indexPath.section ==2){
        return 44;
    }
    
    if(indexPath.section ==3){
        
        return 255;
    }
    
    return 0;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(indexPath.section == 0){
    
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
    
    NSString *userName = [self.selectedExpert objectForKey:@"username"];
    
    NSString *headline = [self.selectedExpert objectForKey:@"headline"];
    
    [cell.profileImage setImageWithString:userName color:nil circular:YES];
    
    cell.name.text = userName;
    
    cell.headline.text = headline;
    
    
    return cell;
        
    }
    
    if(indexPath.section == 1){
        
       ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"actionCell"];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addtoFavorites)];
        tapGesture.numberOfTapsRequired=1;
        [cell.star addGestureRecognizer:tapGesture];
    
        return cell;
    }
    
    if(indexPath.section == 2){
        
        StartChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"startChatCell"];
        
        cell.delegate = self;
        
        return cell;
    }
    
    
    
    if(indexPath.section == 3){
        
        DescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descriptionCell"];
        
        return cell;
        
    }

    
    return nil;
    
    
    
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
