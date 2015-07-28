//
//  ChatViewController.h
//  Petit Comité
//
//  Created by Markus on 15/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import <JSQMessagesViewController/JSQMessages.h>
#import <JSQMessagesViewController/JSQMessage.h>
#import <Firebase/Firebase.h>


@interface ChatControllerTest2 : JSQMessagesViewController

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSMutableArray* chat;
@property (nonatomic, strong) Firebase* mainFirebase;
@property (nonatomic, strong) Firebase* chatsFirebase;
@property (nonatomic, strong) Firebase* messagesFirebase;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* userName;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) UIImageView *outgoingBubbleImageView;
@property (strong, nonatomic) UIImageView *incomingBubbleImageView;

@end


