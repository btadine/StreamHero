//
//  Created by Jesse Squires
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//


// Import all the things
#import "JSQMessages.h"

#import "DemoModelData.h"
#import "NSUserDefaults+DemoSettings.h"
#import <Firebase/Firebase.h>
#import <EDStarRating.h>
@class DemoMessagesViewController;

@protocol JSQDemoViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoViewController:(DemoMessagesViewController *)vc;

@end




@interface DemoMessagesViewController : JSQMessagesViewController <UIActionSheetDelegate,EDStarRatingProtocol, UIAlertViewDelegate>

@property (weak, nonatomic) id<JSQDemoViewControllerDelegate> delegateModal;

@property (strong, nonatomic) DemoModelData *demoData;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;



- (void)closePressed:(UIBarButtonItem *)sender;


@property (nonatomic, strong) NSString *chatName;
@property (nonatomic, strong) NSMutableArray* chat;
@property (nonatomic, strong) Firebase* mainFirebase;
@property (nonatomic, strong) Firebase* chatsFirebase;
@property (nonatomic, strong) Firebase* messagesFirebase;
@property (nonatomic, strong) Firebase* chatmessagesFirebase;

@property (nonatomic, strong) NSString* currentChat;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* expertName;
@end
