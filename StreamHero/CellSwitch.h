//
//  CellSwitch.h
//  StreamHero
//
//  Created by Markus on 20/6/15.
//  Copyright (c) 2015 Marcos Palacios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellSwitchDelegate <NSObject>
@required
- (void)reloadMyTable;
-(void)enableSaveButton;
@end

@interface CellSwitch : UITableViewCell


@property (weak, nonatomic) IBOutlet UISwitch *expertSwitch;
@property (weak, nonatomic)id<CellSwitchDelegate> delegate;
@end
