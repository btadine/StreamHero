//
//  StartChatCell.h
//  StreamHero
//
//  Created by Markus on 26/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StartChatDelegate <NSObject>
@required
- (void)startChat;
@end

@interface StartChatCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *startChatButton;
@property (weak, nonatomic)id<StartChatDelegate> delegate;

@end
