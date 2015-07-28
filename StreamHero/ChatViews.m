//
//  ChatViews.m
//  Petit Comité
//
//  Created by Markus on 16/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import "ChatViews.h"

#import "DemoMessagesViewController.h"

#import "ProfileCell.h"

#define kchatid @"https://resplendent-fire-5031.firebaseio.com/chats/"
#define kmessages @"https://resplendent-fire-5031.firebaseio.com/messages/"
#define kUsersPath @"https://resplendent-fire-5031.firebaseio.com/users/"

@interface ChatViews () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nomessages;
@property (nonatomic, strong) NSMutableArray *chatKeysArray;
@property (nonatomic, strong) NSMutableArray *chatsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSInteger selectedItem;
@property (nonatomic, strong) Firebase *userFirebase;
@property (nonatomic, strong) NSString *userName;
@property (strong, nonatomic) IBOutlet UILabel *loading;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UIView *greyView;
@property (strong, nonatomic) IBOutlet UILabel *loginWarning;

@end

@implementation ChatViews

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.loginWarning.hidden = YES;
    
    self.nomessages.hidden = YES;
    
    self.loading.hidden = NO;
    
    [self.activity startAnimating];
    
    
    
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Chats"
                                      style:UIBarButtonItemStylePlain
                                     target:nil
                                     action:nil];
    
    self.userId = [[NSUserDefaults standardUserDefaults]stringForKey:@"userId"];

    
    self.chatsFirebase = [[Firebase alloc]initWithUrl:kchatid];
    
    self.userFirebase = [[Firebase alloc]initWithUrl:kUsersPath];
    
    NSString *firstName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userArray"]firstObject];
    
    NSString *lastName = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userArray"]objectAtIndex:1];

    
     self.userName = [NSString stringWithFormat:@"%@ %@", firstName, lastName ];
    
   
    
    // This allows us to check if these were messages already stored on the server
    // when we booted up (YES) or if they are new messages since we've started the app.
    // This is so that we can batch together the initial messages' reloadData for a perf gain.
    __block BOOL initialAdds = YES;
    
    [[[self.chatsFirebase queryOrderedByChild:@"userId"] queryEqualToValue:self.userId] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        
        if([snapshot.value isKindOfClass:[NSNull class]]){
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.activity.hidden = NO;
                self.greyView.hidden = NO;
                self.loading.hidden = NO;
                
                self.greyView.alpha = 0;
                self.activity.alpha = 0;
                self.loading.alpha = 0;
            } completion:^(BOOL finished) {
                self.activity.hidden = YES;
                self.greyView.hidden = YES;
                self.loading.hidden = YES;
                [self.activity stopAnimating];
               
                
            }];

            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]== nil){
                
                self.loginWarning.hidden = NO;
            }
            
            
           
            
            
        }
        
        if(![snapshot.value isKindOfClass:[NSNull class]]){
            
            self.nomessages.hidden = YES;
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                self.activity.hidden = NO;
                self.greyView.hidden = NO;
                self.loading.hidden = NO;
                
                self.greyView.alpha = 0;
                self.activity.alpha = 0;
                self.loading.alpha = 0;
            } completion:^(BOOL finished) {
                
                self.activity.hidden = YES;
                self.greyView.hidden = YES;
                self.loading.hidden = YES;
                [self.activity stopAnimating];
            }];

            
        
            
        self.chatKeysArray = [[NSMutableArray alloc]initWithArray:[snapshot.value allKeys]];
        self.chatsArray = [[NSMutableArray alloc]initWithArray:[snapshot.value allValues]];
        }
        // Reload the table view so the new message will show up.
        if (!initialAdds) {
            [self.tableView reloadData];
        }
    }];
    [[[self.chatsFirebase queryOrderedByChild:@"expertId"] queryEqualToValue:self.userId] observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Add the chat message to the array.
        
        if([snapshot.value isKindOfClass:[NSNull class]]){
            
            self.nomessages.hidden = NO;
          
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]== nil){
                
                self.loginWarning.hidden = NO;
            }
            
        }
        
        if(![snapshot.value isKindOfClass:[NSNull class]]){
            
            self.nomessages.hidden = YES;
            
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                
                self.activity.hidden = NO;
                self.greyView.hidden = NO;
                self.loading.hidden = NO;
                
                self.greyView.alpha = 0;
                self.activity.alpha = 0;
                self.loading.alpha = 0;
            } completion:^(BOOL finished) {
                self.activity.hidden = YES;
                self.greyView.hidden = YES;
                self.loading.hidden = YES;
                
                [self.activity stopAnimating];
            }];
            
            
            self.chatKeysArray = [[NSMutableArray alloc]initWithArray:[snapshot.value allKeys]];
            self.chatsArray = [[NSMutableArray alloc]initWithArray:[snapshot.value allValues]];
        }
        // Reload the table view so the new message will show up.
        if (!initialAdds) {
            [self.tableView reloadData];
        }
    }];
    
    
    
    // Value event fires right after we get the events already stored in the Firebase repo.
    // We've gotten the initial messages stored on the server, and we want to run reloadData on the batch.
    // Also set initialAdds=NO so that we'll reload after each additional childAdded event.
    [self.chatsFirebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        // Reload the table view so that the intial messages show up
        [self.tableView reloadData];
        initialAdds = NO;
    }];
    
    
    
    

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 78;
}



- (IBAction)aliveOrHistory:(UISegmentedControl *)sender {
    
    UISegmentedControl *segmentedControl = (UISegmentedControl*)sender;
    
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if(selectedSegment == 0){
        
        
    }
    
    if(selectedSegment == 1){
        
        
    }
    
    
}



-(void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"userId"] != nil){
        
        self.loginWarning.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.chatsArray.count;
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    
    NSDictionary *chatMessage = [self.chatsArray objectAtIndex:indexPath.row];
    
    if([chatMessage[@"userName"] isEqualToString:self.userName]){
    
    cell.name.text = chatMessage[@"expertName"];
        
    [cell.profileImage setImageWithString:chatMessage[@"expertName"] color:nil circular:YES];
        
    }else{
        
        cell.name.text = chatMessage[@"userName"];
        
        [cell.profileImage setImageWithString:chatMessage[@"userName"] color:nil circular:YES];
    }
    
    return cell;
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedItem = indexPath.row;
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        
        NSString *chatPath = [NSString stringWithFormat:@"%@/%@",kchatid,self.chatKeysArray[indexPath.row]];
        self.currentChatSelectedFirebase = [[Firebase alloc]initWithUrl:chatPath];
        NSString *chatMessagesPath = [NSString stringWithFormat:@"%@/%@",kmessages,self.chatKeysArray[indexPath.row]];
        self.messagesChatFirebase = [[Firebase alloc]initWithUrl:chatMessagesPath];
        [self.currentChatSelectedFirebase removeValue];
        [self.messagesChatFirebase removeValue];
        [self.chatsArray removeObjectAtIndex:indexPath.row];
        [self.chatKeysArray removeObjectAtIndex:indexPath.row];
        
        
        
        [self.tableView reloadData]; // tell table to refresh now
    }
}

- (IBAction)addChat:(id)sender {
    
    
    self.newwChatFirebase = [self.chatsFirebase childByAutoId];
    
    [self.newwChatFirebase setValue:@{@"userId" : self.userId}];
    
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
     DemoMessagesViewController *chatsVC = segue.destinationViewController;
    
    NSString *currentChat = self.chatKeysArray[self.selectedItem];
    
    chatsVC.userId = self.userId;
    
    chatsVC.currentChat = currentChat;
    
     NSIndexPath *index = [self.tableView indexPathForSelectedRow];
    
    NSDictionary *chatmessage = self.chatsArray[index.row];
    
    if([chatmessage[@"userName"] isEqualToString:self.userName]){
        
        chatsVC.chatName = [chatmessage objectForKey:@"expertName"];
    
    }else{
        
        chatsVC.chatName = [chatmessage objectForKey:@"userName"];
    }

    
    
  
    
    
   
    
    
    
    


}


@end
