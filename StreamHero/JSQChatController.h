//
//  JSQViewController.h
//  Petit Comité
//
//  Created by Markus on 17/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import "JSQMessagesViewController.h"
#import <JSQMessagesViewController/JSQMessages.h>
#import <JSQMessagesViewController/JSQMessage.h>
#import "ChatController.h"
#import <Firebase/Firebase.h>


@interface JSQChatController : JSQMessagesViewController
@property (nonatomic, strong) ChatController* dataChat;


@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;


@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSMutableArray* chat;
@property (nonatomic, strong) Firebase* mainFirebase;
@property (nonatomic, strong) Firebase* chatsFirebase;
@property (nonatomic, strong) Firebase* messagesFirebase;
@property (nonatomic, strong) NSString* userId;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
