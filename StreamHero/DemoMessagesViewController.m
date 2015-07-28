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

#import "DemoMessagesViewController.h"
#import "ProfileViewController.h"
#import "LMAlertView.h"
#import "LMModalItemTableViewCell.h"

#define kmainFireBase @"https://resplendent-fire-5031.firebaseio.com/"
#define kchatid @"https://resplendent-fire-5031.firebaseio.com/chats/"
#define kmessages @"https://resplendent-fire-5031.firebaseio.com/messages"

static NSString * const kSettingEmptyMessages = @"kSettingEmptyMessages";

@interface DemoMessagesViewController ()
@property (nonatomic) BOOL newMessagesOnTop;
@property (nonatomic) ProfileViewController *profile;
@property (strong, nonatomic) LMAlertView *ratingAlertView;
@end


@implementation DemoMessagesViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Hide the tabBar after selecting a chat
    
    self.tabBarController.tabBar.hidden = YES;
    
    //Init the user Id, DisplayName.
    
    self.senderId = [[NSUserDefaults standardUserDefaults]stringForKey:@"userId"];
    
    NSArray *userData = @[[[NSUserDefaults standardUserDefaults]arrayForKey:@"userArray"]];
    
    self.senderDisplayName =[[userData firstObject]firstObject];

    
    //Init the Firebase adresses
    
   
    NSString *chatmessagesPath = [NSString stringWithFormat:@"%@/%@",kmessages,self.currentChat];
    
    self.messagesFirebase = [[Firebase alloc]initWithUrl:kmessages];
    
    self.chatmessagesFirebase = [[Firebase alloc]initWithUrl:chatmessagesPath];
    
    
    
    //Init the array on we're going to put the messages.
    
    self.chat = [NSMutableArray new];
    
    //Set Messages on top (YES by default).
    
    self.newMessagesOnTop = YES;
    
    //Assigning existingPreviousMessages to (YES by default).
    
    __block BOOL existingPreviousMessages = YES;
    
    
    //Observe if there are new child (messages) added to the chat path.
    
    [self.chatmessagesFirebase observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        
        
        //Passing NSDate to NSNumber (Has to be improved in new versions).
        
        NSNumber *date = [snapshot.value objectForKey:@"date"];
        
        NSDate *aDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[date doubleValue]];
        
        
        JSQMessage *newMessage = [[JSQMessage alloc]initWithSenderId:[snapshot.value objectForKey:@"senderId"]
                                                  senderDisplayName:self.senderDisplayName
                                                  date:aDate text:[snapshot.value objectForKey:@"text"]];
        
        if(newMessage.text == [self.chat.lastObject valueForKey:@"text"] && newMessage.senderId == [self.chat.lastObject valueForKey:@"senderId"]){
            
        }else{
        
        [self.chat addObject:newMessage];
        [self finishReceivingMessageAnimated:YES];
            
            
      
        
    }
     
               if (!existingPreviousMessages) {
            [self finishReceivingMessageAnimated:YES];
        }
    }];
    
    // Value event fires right after we get the events already stored in the Firebase repo.
    // We've gotten the initial messages stored on the server, and we want to run reloadData on the batch.
    // Also set initialAdds=NO so that we'll reload after each additional childAdded event.
//    [self.chatmessagesFirebase observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
//        // Reload the table view so that the intial messages show up
//        
//        [self finishReceivingMessageAnimated:YES];
//        initialAdds = NO;
//    }];

    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    
    
    
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kSettingEmptyMessages];

    
    
    if (![NSUserDefaults incomingAvatarSetting]) {
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    }
    
    if (![NSUserDefaults outgoingAvatarSetting]) {
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    }
    
    self.showLoadEarlierMessagesHeader = YES;
    

    /**
     *  Register custom menu actions for cells.
     */
    [JSQMessagesCollectionViewCell registerMenuAction:@selector(customAction:)];
    [UIMenuController sharedMenuController].menuItems = @[ [[UIMenuItem alloc] initWithTitle:@"Custom Action" action:@selector(customAction:)] ];


   }

- (IBAction)ratingButtonTapped:(id)sender
{
    if (self.ratingAlertView != nil) {
        [self.ratingAlertView show];
        return;
    }
    
    self.ratingAlertView = [[LMAlertView alloc] initWithTitle:@"Rate the chat" message:@"Average" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Rate", nil];
    CGSize size = self.ratingAlertView.size;
    
    LMModalItemTableViewCell *cell = [self.ratingAlertView buttonCellForIndex: self.ratingAlertView.firstOtherButtonIndex];
    cell.isEnabled = NO;
    
    [self.ratingAlertView setSize:CGSizeMake(size.width, 152.0)];
    
    UIView *contentView = self.ratingAlertView.contentView;
    
    EDStarRating *starRating = [[EDStarRating alloc] initWithFrame:CGRectMake((size.width/2.0 - 190.0/2.0), 55.0, 190.0, 50.0)];
    starRating.starImage = [UIImage imageNamed:@"StarEmpty"];
    starRating.starHighlightedImage = [UIImage imageNamed:@"StarFull"];
    starRating.maxRating = 5.0;
    starRating.delegate = self;
    starRating.horizontalMargin = 12.0;
    starRating.editable = YES;
    starRating.displayMode = EDStarRatingDisplayFull;
    starRating.rating = 0;
    starRating.backgroundColor = [UIColor clearColor];
    
    [contentView addSubview:starRating];
    
    [self.ratingAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 1){
        
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)starsSelectionChanged:(EDStarRating *)control rating:(float)rating
{
    NSString *ratingDescription;
    
    switch ([[NSNumber numberWithFloat:rating] integerValue]) {
        case 0:
            ratingDescription = @"Not yet rated";
            break;
        case 1:
            ratingDescription = @"Piss poor";
            break;
        case 2:
            ratingDescription = @"Ok I guess";
            break;
        case 3:
            ratingDescription = @"Average";
            break;
        case 4:
            ratingDescription = @"Pretty good";
            break;
        case 5:
            ratingDescription = @"Freaking amazing";
            break;
        default:
            return;
    }
    
    LMModalItemTableViewCell *cell = [self.ratingAlertView buttonCellForIndex:self.ratingAlertView.firstOtherButtonIndex];
    cell.isEnabled = (rating > 0);
    
    self.ratingAlertView.message = ratingDescription;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    if(self.expertName != nil){
        
        self.title = self.expertName;
        
    }else{
        
        self.title = self.chatName;
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    /**
     *  Enable/disable springy bubbles, default is NO.
     *  You must set this from `viewDidAppear:`
     *  Note: this feature is mostly stable, but still experimental
     */
    self.collectionView.collectionViewLayout.springinessEnabled = [NSUserDefaults springinessSetting];

}



#pragma mark - Actions



- (void)closePressed:(UIBarButtonItem *)sender
{
    [self.delegateModal didDismissJSQDemoViewController:self];
}




#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    [self.chat addObject:message];
    
    self.chatmessagesFirebase = [self.messagesFirebase childByAppendingPath:self.currentChat];
    
    NSNumber *numberDate = [NSNumber numberWithDouble:[date timeIntervalSinceReferenceDate]];
    
    [[self.chatmessagesFirebase childByAutoId] setValue:@{@"senderId":self.userId ,
                                                          @"senderDisplayName":self.senderDisplayName ,
                                                          @"date":numberDate,
                                                          @"text": text}];

    
    
    
    [self finishSendingMessageAnimated:YES];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Media messages"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Send photo", @"Send location", @"Send video", nil];
    
    [sheet showFromToolbar:self.inputToolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    switch (buttonIndex) {
        case 0:
            [self.demoData addPhotoMediaMessage];
            break;
            
        case 1:
        {
            __weak UICollectionView *weakView = self.collectionView;
            
            [self.demoData addLocationMediaMessageCompletion:^{
                [weakView reloadData];
            }];
        }
            break;
            
        case 2:
            [self.demoData addVideoMediaMessage];
            break;
    }
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    [self finishSendingMessageAnimated:YES];
}



#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.chat objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.chat objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    
    return self.incomingBubbleImageData;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Return your previously created avatar image data objects.
     *
     *  Note: these the avatars will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    JSQMessage *message = [self.chat objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        if (![NSUserDefaults outgoingAvatarSetting]) {
            return nil;
        }
    }
    else {
        if (![NSUserDefaults incomingAvatarSetting]) {
            return nil;
        }
    }
    
    
//    return [self.demoData.avatars objectForKey:message.senderId];
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.chat objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.chat objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.chat objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.chat count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.chat objectAtIndex:indexPath.item];
    
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}




#pragma mark - Custom menu items

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        return YES;
    }

    return [super collectionView:collectionView canPerformAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(customAction:)) {
        [self customAction:sender];
        return;
    }

    [super collectionView:collectionView performAction:action forItemAtIndexPath:indexPath withSender:sender];
}

- (void)customAction:(id)sender
{
    NSLog(@"Custom action received! Sender: %@", sender);

    [[[UIAlertView alloc] initWithTitle:@"Custom Action"
                               message:nil
                              delegate:nil
                     cancelButtonTitle:@"OK"
                      otherButtonTitles:nil]
     show];
}



#pragma mark - JSQMessages collection view flow layout delegate

#pragma mark - Adjusting cell label heights

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.chat objectAtIndex:indexPath.item];
    if ([[currentMessage senderId] isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.chat objectAtIndex:indexPath.item - 1];
        if ([[previousMessage senderId] isEqualToString:[currentMessage senderId]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

#pragma mark - Responding to collection view tap events

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped avatar!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapMessageBubbleAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Tapped message bubble!");
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView didTapCellAtIndexPath:(NSIndexPath *)indexPath touchLocation:(CGPoint)touchLocation
{
    NSLog(@"Tapped cell at %@!", NSStringFromCGPoint(touchLocation));
}

@end