//
//  FavoritesViewController.m
//  StreamHero
//
//  Created by Markus on 18/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import "FavoritesViewController.h"
#import "ProfileCell.h"
#import <Firebase/Firebase.h>

@interface FavoritesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray* myteachers;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, strong) Firebase* favoritesPathFirebase;
@property (nonatomic, strong) Firebase* currentUserFireBase;
@end

@implementation FavoritesViewController

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
   }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.myteachers = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"]];
        
        if(self.myteachers.count == 0){
            
            self.tabBarController.selectedIndex = 1;
        }
        
        else if([[NSUserDefaults standardUserDefaults]
                 stringForKey:@"userId"] == nil){
            
            self.tabBarController.selectedIndex = 3;
        }

}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    if(self.tabBarController.selectedIndex == 0){
    
    [self.navigationController popToRootViewControllerAnimated:NO];
        
    }

  self.myteachers = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favorites"]];
    
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 78;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
        return self.myteachers.count;
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
        ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"heroesCell"];
    
    if(self.myteachers != nil){
    
        cell.name.text = self.myteachers[indexPath.row][@"username"];
        
        [cell.profileImage setImageWithString:self.myteachers[indexPath.row][@"username"] color:nil circular:YES];
        
        
    }
    
        return cell;
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        [self.myteachers removeObjectAtIndex:indexPath.row];
        [self.tableview reloadData];
        
        
        
        NSString *favorites = [NSString stringWithFormat:@"%@/favorites",[[NSUserDefaults standardUserDefaults] objectForKey:@"autoId"]];
        
        self.favoritesPathFirebase = [[Firebase alloc]initWithUrl:favorites];
        
        [self.favoritesPathFirebase removeValue];
        
        NSString *childByAutoId = [[NSUserDefaults standardUserDefaults]stringForKey:@"autoId"];
        
        self.currentUserFireBase = [[Firebase alloc]initWithUrl:childByAutoId];
    
        [self.currentUserFireBase updateChildValues:@{@"favorites":self.myteachers.copy} withCompletionBlock:^(NSError *error, Firebase *ref) {
            
        }];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.myteachers.copy forKey:@"favorites"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
}

        

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier  isEqualToString:@"addhero"]){
        
        
        
       // self.tabBarController.selectedIndex = 1;
        
        
    }
    
}


@end
