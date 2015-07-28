//
//  SecondViewController.h
//  Petit Comité
//
//  Created by Markus on 15/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>


@interface ChatController : UIViewController 

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* chatName;
@property (nonatomic, strong) NSMutableArray* chat;
@property (nonatomic, strong) Firebase* mainFirebase;
@property (nonatomic, strong) Firebase* chatsFirebase;
@property (nonatomic, strong) Firebase* messagesFirebase;
@property (nonatomic, strong) Firebase* chatmessagesFirebase;

@property (nonatomic, strong) NSString* currentChat;
@property (nonatomic, strong) NSString* userId;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;



@end

