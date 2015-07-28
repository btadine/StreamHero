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

@interface JSQViewController : JSQMessagesViewController
@property (nonatomic, strong) ChatController* dataChat;


@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@end
