//
//  ExpertsViewController.m
//  Petit Comité
//
//  Created by Markus on 17/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import "ExpertsViewController.h"
#import "MyTableCell.h"
#import "ProfileExpertBrowseController.h"
#import <Firebase/Firebase.h>
#import "UIImageView+Letters.h"

#define kusers @"https://resplendent-fire-5031.firebaseio.com/users/"


@interface ExpertsViewController () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) NSMutableArray* expertsFound;
@property(nonatomic, strong) NSMutableArray* expertsKeys;
@property (nonatomic, strong) NSMutableArray* headline;
@property(nonatomic, strong) UIImage *expertImage;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Firebase *usersFirebase;
@end

@implementation ExpertsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activity startAnimating];
    
    self.usersFirebase = [[Firebase alloc]initWithUrl:kusers];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
    __block BOOL initialAdds = YES;
    

    
    
    [[[self.usersFirebase queryOrderedByChild:@"skills"] queryEqualToValue:@"iOS"] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        
        if([snapshot.value isKindOfClass:[NSNull class]]){
            
            
            
        }
        
        if(![snapshot.value isKindOfClass:[NSNull class]]){
            
            
            
            
     
            
            self.expertsKeys = [[NSMutableArray alloc]initWithArray:[snapshot.value allKeys]];
            self.expertsFound = [[NSMutableArray alloc]initWithArray:[snapshot.value allValues]];
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.reloadView.alpha = 0;
                self.activity.alpha = 0;
                self.loading.alpha = 0;
            } completion:^(BOOL finished) {
                self.activity.hidden = YES;
                self.reloadView.hidden = YES;
                self.loading.hidden = YES;
                [self.activity stopAnimating];
            }];
            
            
        }
        // Reload the table view so the new message will show up.
        if (!initialAdds) {
            
            [self.tableView reloadData];
        }
    }];
    
    // Value event fires right after we get the events already stored in the Firebase repo.
    // We've gotten the initial messages stored on the server, and we want to run reloadData on the batch.
    // Also set initialAdds=NO so that we'll reload after each additional childAdded event.
    [self.usersFirebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Reload the table view so that the intial messages show up
        [self.tableView reloadData];
        initialAdds = NO;
    }];
    
    
    self.expertImage = [UIImage imageNamed:@"MarcosSocial"];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
    
    return self.expertsFound.count;
    
    
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 78;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   MyTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expertsCell"];
    
    cell.accessoryView = [[ UIImageView alloc ]
                            initWithImage:[UIImage imageNamed:@"more2" ]];
    
    NSString *userName = [self.expertsFound[indexPath.row] objectForKey:@"username"];
    
    cell.name.text = userName;
    
    
    [cell.photoView setImageWithString:userName color:nil circular:YES];
    
    
    
//    cell.photoView.image = self.expertImage;
    
    return cell;
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ProfileExpertBrowseController *VC = segue.destinationViewController;
    
    NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    
    VC.selectedExpert = self.expertsFound[index.row];


}


@end
