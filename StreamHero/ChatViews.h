//
//  ChatViews.h
//  Petit Comité
//
//  Created by Markus on 16/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>

@interface ChatViews : UIViewController

@property (nonatomic, strong) Firebase* chatsFirebase;
@property (nonatomic, strong) Firebase* newwChatFirebase;
@property (nonatomic, strong) Firebase* currentChatSelectedFirebase;
@property (nonatomic, strong) Firebase* messagesChatFirebase;
@property (nonatomic, strong) NSString* userId;
@end
