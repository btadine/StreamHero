//
//  ProfileController.m
//  Petit Comité
//
//  Created by Markus on 16/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import "ProfileController.h"
#import "ProfileViewController.h"
#import "MyTableViewCellWithTextField.h"
#import "SkillsCell.h"
#import "MBProgressHUD.h"




#define kUsersPath @"https://resplendent-fire-5031.firebaseio.com/users/"

@interface ProfileController () <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ProfileViewController *VC;
@property (nonatomic, strong) NSArray *editableInfo;
@property (nonatomic, strong) NSArray *nonEditableInfo;
@property (nonatomic, strong) NSMutableArray *allTheInfo;
@property (nonatomic, strong) NSArray *allTheInfoCopy;
@property (nonatomic, strong) NSArray *skills;
@property (nonatomic, strong) Firebase *userFirebase;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) NSString *savedName;
@property (strong, nonatomic) NSString *savedSurname;
@property (strong, nonatomic) NSString *savedHeadline;
@property (strong, nonatomic) NSArray *editableValues;
@end

@implementation ProfileController





-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    [self.tableView reloadData];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.savedName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userArray"] firstObject];
    
    self.savedSurname = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userArray"] objectAtIndex:1];
    
    self.savedHeadline = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userArray"] objectAtIndex:2];
    
    self.editableValues = [[NSArray alloc]init];
    
    self.editableValues = @[self.savedName, self.savedSurname, self.savedHeadline];
    
    self.childByAutoId = [[NSUserDefaults standardUserDefaults]stringForKey:@"autoId"];
    

    
    self.skills = [[NSArray alloc]init];
    
    
    self.editableInfo = @[@"Name",@"Surname",@"Headline"];
    
    self.nonEditableInfo = @[@"I'm an expert"];
    
    self.allTheInfo = [[NSMutableArray alloc]init];
    
    [self.allTheInfo addObject:self.editableInfo];
    [self.allTheInfo addObject:self.nonEditableInfo];
    
    self.allTheInfoCopy = self.allTheInfo.copy;
    
    
    self.saveButton.enabled = NO;
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    self.VC = [[ProfileViewController alloc]init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)skillsChanged:(NSArray *)array{
    
    self.skills = array;
    
    self.saveButton.enabled = YES;
    
    [self.tableView reloadData];
    
}

-(void)enableSaveButton{
    
    self.saveButton.enabled = YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    self.saveButton.enabled = YES;
    
   NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    
    if(index.row == 0){
        
        self.savedName = textField.text;
    
    
    }else if(index.row == 1){
        
        self.savedSurname = textField.text;
    
    }else if(index.row == 2){
        
        self.savedHeadline = textField.text;
    }
}

- (IBAction)saveProfile:(id)sender {
    
     Firebase *save = [[Firebase alloc]initWithUrl:self.childByAutoId];
    
    NSString *username = [NSString stringWithFormat:@"%@ %@",self.savedName, self.savedSurname];
    
    NSString *userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    
    NSString *mail = [[[NSUserDefaults standardUserDefaults]objectForKey:@"userArray"]objectAtIndex:4];
    
    
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"expert"] ==YES){
        
        [save updateChildValues:@{@"username": username,
                         @"headline":self.savedHeadline,
                         @"expert":@"YES",
                         @"userId":userId,
                        @"mail":mail,
                        @"skills":self.skills}];
    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"expert"] == NO){
        
        [save updateChildValues:@{@"username": username,
                         @"headline":self.savedHeadline,
                         @"expert":@"NO"}];

    }
    
    
    [self.tableView endEditing:YES];
    
    self.saveButton.enabled = NO;
    
   
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    
    HUD.alpha = 0.5;
    
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    
    HUD.delegate = self;
    HUD.labelText = @"Saved";
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1.3];

    
    
}

- (void)reloadMyTable{
    [self.tableView reloadData];
}

- (IBAction)logout:(id)sender {
    
    [self.VC.loginFirebase unauth];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userId"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"expert"] == YES){
        
        return 3;
   
    }else
   
    return 2;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0)
        return [[self.allTheInfo objectAtIndex:0] count];
    
    if (section == 1)
        return [[self.allTheInfo objectAtIndex:1] count];
    
    if (section == 2)
        return 1;
    
    return 0;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Personal";
            break;
        case 1:
            sectionName = @"";
            break;
        case 2:
            sectionName = @"Expertise Areas";
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 2){
        
        return 140;
    }else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        
        MyTableViewCellWithTextField *cell = [tableView dequeueReusableCellWithIdentifier:@"textfieldCell"];
        
        NSString  *keys = [self.allTheInfoCopy objectAtIndex:0][indexPath.row];
        
        cell.name.text = keys;
        
        cell.theTextField.text = self.editableValues[indexPath.row];
        
        return cell;
        
    }else if (indexPath.section == 1){
        
    CellSwitch *cell = [tableView dequeueReusableCellWithIdentifier:@"Areas"];
        
        cell.delegate = self;
        
        cell.textLabel.text = [self.allTheInfoCopy objectAtIndex:1][indexPath.row];
        
        return cell;
    
    }else if(indexPath.section == 2){
        
        SkillsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tagListCell"];
        
        [cell.tagListView removeAllTags];
        
        for(NSString *tag in self.skills){
            
            [cell.tagListView addTag:tag];
            
        }

        
        return cell;

    }
    
    return nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.userFirebase = [[Firebase alloc]initWithUrl:kUsersPath];
    
    
//
//    [[self.userFirebase childByAppendingPath:self.userId] setValue:@{@"username":self.email.text,@"is_expert":self.isTeacher}];
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    TagsEditController* VC = segue.destinationViewController;
    
    VC.skills = [[NSMutableArray alloc]initWithArray:self.skills];
    
    VC.delegate = self;

    
}


@end
